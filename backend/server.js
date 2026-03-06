require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { MongoClient } = require('mongodb');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;
const API_PREFIX = process.env.API_PREFIX || '/api/v1';
const LOG_HTTP_REQUESTS = process.env.LOG_HTTP_REQUESTS === 'true';

// MongoDB connection configuration
const mongoOptions = {
  maxPoolSize: 10,
  minPoolSize: 2,
  serverSelectionTimeoutMS: 30000,
  connectTimeoutMS: 30000,
  socketTimeoutMS: 30000,
  family: 4, // Force IPv4
};

const adminDbUri = process.env.ADMIN_DB_URI;
const webDbUri = process.env.WEB_DB_URI;

// Database connection instances
let adminClient = null;
let webClient = null;
let adminDb = null;
let webDb = null;

// ============================================================================
// MIDDLEWARE SETUP
// ============================================================================

// CORS configuration
const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or Postman)
    if (!origin) return callback(null, true);

    // In development, allow all origins
    if (process.env.NODE_ENV !== 'production') {
      return callback(null, true);
    }

    // In production, check against allowed origins
    const allowedOrigins = (process.env.ALLOWED_ORIGINS || 'http://localhost:5173').split(',');
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));

// Body parser middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Request timeout middleware
app.use((req, res, next) => {
  res.setTimeout(parseInt(process.env.REQUEST_TIMEOUT || '30000'));
  next();
});

// Logging middleware
app.use((req, res, next) => {
  if (!LOG_HTTP_REQUESTS) {
    return next();
  }

  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url} - Status: ${res.statusCode} - ${duration}ms`);
  });
  next();
});

// ============================================================================
// DATABASE CONNECTION
// ============================================================================

async function connectToDatabase() {
  try {
    console.log('\n📡 Connecting to databases...');

    // Connect to Admin Database
    if (!adminClient) {
      adminClient = new MongoClient(adminDbUri, mongoOptions);
      await adminClient.connect();
      adminDb = adminClient.db();
      console.log('✓ Connected to MongoDB Admin Database');
    }

    // Connect to Web Database
    if (!webClient) {
      webClient = new MongoClient(webDbUri, mongoOptions);
      await webClient.connect();
      webDb = webClient.db();
      console.log('✓ Connected to MongoDB Web Database');
    }

  } catch (error) {
    console.error('✗ Database connection error:', error.message);
    // Don't exit immediately, allow server to start but mark as unhealthy
  }
}

// ============================================================================
// ROUTES - HEALTH & INFO
// ============================================================================

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Relstone Backend API',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString(),
    endpoints: {
      health: `${API_PREFIX}/health`,
      auth: `${API_PREFIX}/auth`,
      users: `${API_PREFIX}/users`,
      documents: `${API_PREFIX}/documents`,
    }
  });
});

// Health check endpoint
app.get(`${API_PREFIX}/health`, (req, res) => {
  const adminConnected = adminClient && adminClient.topology.isConnected();
  const webConnected = webClient && webClient.topology.isConnected();

  res.json({
    message: 'Backend Health Check',
    status: adminConnected && webConnected ? 'healthy' : 'degraded',
    timestamp: new Date().toISOString(),
    databases: {
      admin: {
        connected: adminConnected
      },
      web: {
        connected: webConnected
      }
    }
  });
});

// ============================================================================
// ROUTES - PLACEHOLDER API ROUTES
// ============================================================================

function registerInsuranceRoutes(prefix) {
  app.get(`${prefix}/insurance/states`, async (req, res) => {
    if (!webDb) {
      return res.status(503).json({
        error: 'Service Unavailable',
        message: 'Web database is not connected'
      });
    }

    try {
      const states = await webDb
        .collection('states')
        .find({})
        .project({
          _id: 0,
          name: 1,
          slug: 1,
          heroTitle: 1,
          providerInfo: 1,
        })
        .sort({ name: 1 })
        .toArray();

      return res.status(200).json({ states });
    } catch (error) {
      return res.status(500).json({
        error: 'Database Error',
        message: error.message,
      });
    }
  });

  app.get(`${prefix}/insurance/states/:slug`, async (req, res) => {
    if (!webDb) {
      return res.status(503).json({
        error: 'Service Unavailable',
        message: 'Web database is not connected'
      });
    }

    const stateSlug = (req.params.slug || '').toLowerCase().trim();
    if (!stateSlug) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'State slug is required'
      });
    }

    try {
      const state = await webDb.collection('states').findOne(
        { slug: stateSlug },
        {
          projection: {
            _id: 0,
            name: 1,
            slug: 1,
            heroTitle: 1,
            providerInfo: 1,
            introBullets: 1,
            ceBullets: 1,
            requirements: 1,
            examInstructions: 1,
            metaDescription: 1,
          }
        }
      );

      if (!state) {
        return res.status(404).json({
          error: 'Not Found',
          message: `State '${stateSlug}' not found`
        });
      }

      const courses = await webDb
        .collection('courses')
        .find({ stateSlug, isActive: true })
        .project({
          _id: 0,
          stateSlug: 1,
          name: 1,
          shortName: 1,
          description: 1,
          price: 1,
          creditHours: 1,
          courseType: 1,
          hasPrintedTextbook: 1,
          printedTextbookPrice: 1,
          sortOrder: 1,
          longDescription: 1,
          overview: 1,
          courseTopics: 1,
          topics: 1,
          whatYoullLearn: 1,
          whatYouWillLearn: 1,
          learningOutcomes: 1,
          courseDetails: 1,
          details: 1,
          courseDetailBullets: 1,
          whoShouldTakeThisCourse: 1,
          whoShouldTake: 1,
          targetAudience: 1,
        })
        .sort({ sortOrder: 1, name: 1 })
        .toArray();

      return res.status(200).json({ state, courses });
    } catch (error) {
      return res.status(500).json({
        error: 'Database Error',
        message: error.message,
      });
    }
  });

  // Frontend also requests courses directly by state slug.
  app.get(`${prefix}/insurance/courses/:slug`, async (req, res) => {
    if (!webDb) {
      return res.status(503).json({
        error: 'Service Unavailable',
        message: 'Web database is not connected'
      });
    }

    const stateSlug = (req.params.slug || '').toLowerCase().trim();
    if (!stateSlug) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'State slug is required'
      });
    }

    try {
      const courses = await webDb
        .collection('courses')
        .find({ stateSlug, isActive: true })
        .project({
          _id: 0,
          stateSlug: 1,
          name: 1,
          shortName: 1,
          description: 1,
          price: 1,
          creditHours: 1,
          courseType: 1,
          hasPrintedTextbook: 1,
          printedTextbookPrice: 1,
          sortOrder: 1,
          longDescription: 1,
          overview: 1,
          courseTopics: 1,
          topics: 1,
          whatYoullLearn: 1,
          whatYouWillLearn: 1,
          learningOutcomes: 1,
          courseDetails: 1,
          details: 1,
          courseDetailBullets: 1,
          whoShouldTakeThisCourse: 1,
          whoShouldTake: 1,
          targetAudience: 1,
        })
        .sort({ sortOrder: 1, name: 1 })
        .toArray();

      return res.status(200).json({ stateSlug, courses });
    } catch (error) {
      return res.status(500).json({
        error: 'Database Error',
        message: error.message,
      });
    }
  });
}

for (const prefix of [...new Set([API_PREFIX, '/api'])]) {
  registerInsuranceRoutes(prefix);
}

// Auth routes
function registerAuthRoutes(prefix) {
  app.post(`${prefix}/auth/login`, (req, res) => {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Email and password are required'
      });
    }

    // Mock authentication - accept any valid email/password combination
    // In production, this would query the database and verify password hash
    if (email && password.length >= 6) {
      const mockToken = 'mock_jwt_token_' + Date.now();
      const mockUser = {
        id: '123456789',
        email: email,
        firstName: email.split('@')[0],
        lastName: 'User',
        createdAt: new Date().toISOString()
      };

      return res.status(200).json({
        message: 'Login successful',
        token: mockToken,
        user: mockUser
      });
    }

    // Invalid credentials
    res.status(401).json({
      error: 'Authentication Failed',
      message: 'Invalid email or password'
    });
  });

  app.post(`${prefix}/auth/register`, (req, res) => {
    const { firstName, lastName, email, password } = req.body;

    // Validation
    if (!firstName || !lastName || !email || !password) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'All fields are required'
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Password must be at least 6 characters'
      });
    }

    // Mock registration - in production, this would save to database
    const mockUserId = 'user_' + Date.now();

    return res.status(201).json({
      message: 'Account created successfully. Please verify your email.',
      userId: mockUserId,
      email: email
    });
  });

  app.post(`${prefix}/auth/logout`, (req, res) => {
    // Mock logout - in production, this would invalidate token
    res.status(200).json({
      message: 'Logout successful'
    });
  });

  app.post(`${prefix}/auth/verify-email`, (req, res) => {
    const { userId, code } = req.body;

    // Validation
    if (!userId || !code) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'userId and code are required'
      });
    }

    // Mock verification - accept any 6-digit code
    if (code.length === 6 || code === '000000') {
      return res.status(200).json({
        message: 'Email verified successfully',
        token: 'mock_jwt_token_' + Date.now(),
        user: {
          id: userId,
          email: 'user@example.com',
          firstName: 'User',
          lastName: 'Name',
          verified: true
        }
      });
    }

    res.status(400).json({
      error: 'Verification Failed',
      message: 'Invalid verification code'
    });
  });

  app.post(`${prefix}/auth/resend-code`, (req, res) => {
    const { userId, email } = req.body;

    // Validation
    if (!userId || !email) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'userId and email are required'
      });
    }

    // Mock resend - in production, this would send email with new code
    return res.status(200).json({
      message: 'Verification code sent to your email',
      email: email,
      expiresIn: 300 // 5 minutes
    });
  });

  app.post(`${prefix}/auth/forgot-password`, (req, res) => {
    const { email } = req.body;

    // Validation
    if (!email) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Email is required'
      });
    }

    // Mock password reset request
    return res.status(200).json({
      message: 'Password reset link sent to your email',
      email: email
    });
  });

  app.post(`${prefix}/auth/reset-password`, (req, res) => {
    const { email, code, newPassword } = req.body;

    // Validation
    if (!email || !code || !newPassword) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Email, code, and newPassword are required'
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Password must be at least 6 characters'
      });
    }

    // Mock password reset
    return res.status(200).json({
      message: 'Password reset successful',
      email: email
    });
  });
}

for (const prefix of [...new Set([API_PREFIX, '/api'])]) {
  registerAuthRoutes(prefix);
}

// Users routes
app.get(`${API_PREFIX}/users`, (req, res) => {
  res.status(501).json({
    error: 'Not Implemented',
    message: 'Get users endpoint not yet implemented'
  });
});

app.get(`${API_PREFIX}/users/:id`, (req, res) => {
  res.status(501).json({
    error: 'Not Implemented',
    message: 'Get user by ID endpoint not yet implemented'
  });
});

// Documents routes
app.get(`${API_PREFIX}/documents`, (req, res) => {
  res.status(501).json({
    error: 'Not Implemented',
    message: 'Get documents endpoint not yet implemented'
  });
});

// ============================================================================
// ERROR HANDLING
// ============================================================================

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `The endpoint ${req.method} ${req.url} does not exist`,
    timestamp: new Date().toISOString()
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);

  res.status(err.status || 500).json({
    error: err.name || 'Internal Server Error',
    message: err.message || 'An unexpected error occurred',
    timestamp: new Date().toISOString(),
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// ============================================================================
// SERVER STARTUP
// ============================================================================

async function startServer() {
  try {
    // Connect to databases first
    await connectToDatabase();

    // Start the server
    const server = app.listen(PORT, () => {
      console.log('\n✓ Server is running on http://localhost:' + PORT);
      console.log(`📚 API Documentation available at http://localhost:${PORT}/`);
      console.log(`🏥 Health check: http://localhost:${PORT}${API_PREFIX}/health`);
      console.log('\n');
    });

    // Graceful shutdown
    process.on('SIGINT', async () => {
      console.log('\n\n🛑 Shutting down gracefully...');

      server.close(async () => {
        if (adminClient) {
          await adminClient.close();
          console.log('✓ Admin database connection closed');
        }
        if (webClient) {
          await webClient.close();
          console.log('✓ Web database connection closed');
        }
        console.log('✓ Server stopped');
        process.exit(0);
      });

      // Force close after 10 seconds
      setTimeout(() => {
        console.error('✗ Forced shutdown');
        process.exit(1);
      }, 10000);
    });

  } catch (error) {
    console.error('✗ Failed to start server:', error);
    process.exit(1);
  }
}

// Start the server
startServer();




