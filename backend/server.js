require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { MongoClient } = require('mongodb');
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;
const API_PREFIX = process.env.API_PREFIX || '/api/v1';

// ============================================================================
// EMAIL SERVICE SETUP
// ============================================================================

// Create email transporter - using IP to bypass DNS issues
const emailTransporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST_IP || '172.253.118.108', // Use IP instead of hostname
  port: parseInt(process.env.EMAIL_PORT || '587'),
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  },
  tls: {
    rejectUnauthorized: false,
    ciphers: 'SSLv3'
  },
  connectionTimeout: 10000,
  socketTimeout: 10000
});

// Verify email configuration on startup
emailTransporter.verify(function(error, success) {
  if (error) {
    console.log('✗ Email configuration error:', error.message);
    // Try alternative: use gmail hostname as fallback
    console.log('↻ Attempting fallback to hostname...');
  } else {
    console.log('✓ Email server is ready to send messages');
  }
});

// Generate verification code
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// Generate unique student ID
function generateStudentId() {
  // Format: STU-YYYYMMDD-XXXXX
  const now = new Date();
  const date = now.getFullYear().toString() +
               String(now.getMonth() + 1).padStart(2, '0') +
               String(now.getDate()).padStart(2, '0');
  const random = Math.floor(Math.random() * 100000).toString().padStart(5, '0');
  return `STU-${date}-${random}`;
}

// Send verification email with retry
async function sendVerificationEmail(email, code, firstName) {
  const mailOptions = {
    from: `"Relstone" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: 'Relstone - Email Verification Code',
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px;">
        <h2 style="color: #1A3A5C;">Welcome to Relstone, ${firstName}!</h2>
        <p>Thank you for registering. Please verify your email using the code below:</p>
        <div style="background-color: #f0f0f0; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
          <h1 style="color: #2E7EBE; letter-spacing: 5px; margin: 0;">${code}</h1>
        </div>
        <p>This code will expire in 24 hours.</p>
        <p>If you didn't register for Relstone, please ignore this email.</p>
        <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;">
        <p style="color: #666; font-size: 12px;">© 2026 Relstone. All rights reserved.</p>
      </div>
    `
  };

  const maxRetries = 3;
  let lastError = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      console.log(`→ Attempt ${attempt}/${maxRetries}: Sending email to ${email}...`);
      const info = await emailTransporter.sendMail(mailOptions);
      console.log(`✓ Email sent successfully! Message ID: ${info.messageId}`);
      return true;
    } catch (error) {
      lastError = error;
      console.error(`✗ Attempt ${attempt} failed:`, error.message);
      if (attempt < maxRetries) {
        // Wait before retrying
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    }
  }

  console.error(`✗ Failed to send email after ${maxRetries} attempts:`, lastError.message);
  return false;
}

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

function connectToDatabase() {
  console.log('\n📡 Connecting to databases...');

  // Connect to Admin Database (async, non-blocking)
  if (!adminClient && adminDbUri) {
    (async () => {
      try {
        adminClient = new MongoClient(adminDbUri, mongoOptions);
        await adminClient.connect();
        adminDb = adminClient.db();
        console.log('✓ Connected to MongoDB Admin Database');
      } catch (error) {
        console.error('✗ Admin Database connection error:', error.message);
        adminClient = null;
      }
    })();
  }

  // Connect to Web Database (async, non-blocking)
  if (!webClient && webDbUri) {
    (async () => {
      try {
        webClient = new MongoClient(webDbUri, mongoOptions);
        await webClient.connect();
        webDb = webClient.db();
        console.log('✓ Connected to MongoDB Web Database');
      } catch (error) {
        console.error('✗ Web Database connection error:', error.message);
        webClient = null;
      }
    })();
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
  const adminConnected = adminClient && adminClient.topology && adminClient.topology.isConnected();
  const webConnected = webClient && webClient.topology && webClient.topology.isConnected();

  res.json({
    message: 'Backend Health Check',
    status: adminConnected && webConnected ? 'healthy' : 'degraded',
    timestamp: new Date().toISOString(),
    databases: {
      admin: {
        connected: adminConnected || false
      },
      web: {
        connected: webConnected || false
      }
    }
  });
});

// ============================================================================
// ROUTES - PLACEHOLDER API ROUTES
// ============================================================================

// Auth routes
app.post(`${API_PREFIX}/auth/login`, async (req, res) => {
  const { email, password } = req.body;

  // Validation
  if (!email || !password) {
    return res.status(400).json({
      error: 'Validation Error',
      message: 'Email and password are required'
    });
  }

  try {
    // Check if database is connected
    if (!webDb) {
      return res.status(500).json({
        error: 'Database Error',
        message: 'Database not available'
      });
    }

    const usersCollection = webDb.collection('users');

    // Find user by email
    const user = await usersCollection.findOne({ email: email.toLowerCase() });

    if (!user) {
      return res.status(401).json({
        error: 'Authentication Failed',
        message: 'Invalid email or password'
      });
    }

    // Check if email is verified
    if (!user.isVerified) {
      // In development, log warning but allow login
      console.log('⚠ User login without verification:', user.email);
      // In production, uncomment the lines below:
      // return res.status(403).json({
      //   error: 'Email Not Verified',
      //   message: 'Please verify your email before logging in',
      //   needsVerification: true,
      //   userId: user._id.toString()
      // });
    }

    // Verify password with bcrypt
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({
        error: 'Authentication Failed',
        message: 'Invalid email or password'
      });
    }

    // Login successful
    const mockToken = 'mock_jwt_token_' + Date.now();
    const userData = {
      id: user._id.toString(),
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role || 'user', // Support both old and new schema
      isVerified: user.isVerified,
      createdAt: user.createdAt
    };

    console.log('✓ User logged in:', user.email);

    return res.status(200).json({
      message: 'Login successful',
      token: mockToken,
      user: userData
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      error: 'Server Error',
      message: 'Login failed. Please try again.'
    });
  }
});

app.post(`${API_PREFIX}/auth/register`, async (req, res) => {
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

  try {
    // Check if database is connected
    if (!webDb) {
      return res.status(500).json({
        error: 'Database Error',
        message: 'Database not available'
      });
    }

    // Check if user already exists
    const usersCollection = webDb.collection('users');
    const existingUser = await usersCollection.findOne({ email: email.toLowerCase() });

    if (existingUser) {
      return res.status(400).json({
        error: 'Registration Error',
        message: 'Email already registered'
      });
    }

    // Generate verification code
    const verificationCode = generateVerificationCode();

    // Hash password with bcrypt
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create user document - EXACT SAME SCHEMA AS LANZ
    const newUser = {
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.toLowerCase().trim(),
      password: hashedPassword,
      isVerified: false,
      role: 'student',
      adminStudentId: null, // Same as Lanz
      createdAt: new Date(),
      updatedAt: new Date()
    };

    // Save to database
    const result = await usersCollection.insertOne(newUser);
    const userId = result.insertedId.toString();

    // Send verification email and wait for it
    console.log('→ Sending verification email to:', email);
    const emailSent = await sendVerificationEmail(email, verificationCode, firstName);

    if (emailSent) {
      console.log('✓ User registered and email sent:', email);
    } else {
      console.log('⚠ User registered but email failed:', email);
    }

    // Return success (even if email fails, user is still registered)
    return res.status(201).json({
      message: emailSent
        ? 'Account created successfully. Please check your email for verification code.'
        : 'Account created successfully. Email sending failed - please contact support.',
      userId: userId,
      email: email,
      emailSent: emailSent
      // verificationCode removed - only sent via email now
    });
  } catch (error) {
    console.error('Registration error:', error);
    return res.status(500).json({
      error: 'Server Error',
      message: 'Failed to register. Please try again.'
    });
  }
});

app.post(`${API_PREFIX}/auth/logout`, (req, res) => {
  // Mock logout - in production, this would invalidate token
  res.status(200).json({
    message: 'Logout successful'
  });
});

app.post(`${API_PREFIX}/auth/verify-email`, async (req, res) => {
  const { userId, code, email } = req.body;

  // Validation - accept either userId or email
  if ((!userId && !email) || !code) {
    return res.status(400).json({
      error: 'Validation Error',
      message: 'userId (or email) and code are required'
    });
  }

  try {
    // Check if database is connected
    if (!webDb) {
      return res.status(500).json({
        error: 'Database Error',
        message: 'Database not available'
      });
    }

    const usersCollection = webDb.collection('users');

    // Find user by userId or email
    const { ObjectId } = require('mongodb');
    let query = {};

    if (userId && ObjectId.isValid(userId)) {
      query = { _id: new ObjectId(userId) };
    } else if (email) {
      query = { email: email.toLowerCase() };
    } else {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Invalid userId or email'
      });
    }

    const user = await usersCollection.findOne(query);

    if (!user) {
      return res.status(404).json({
        error: 'User Not Found',
        message: 'User does not exist'
      });
    }

    // Check if already verified
    if (user.isVerified) {
      return res.status(400).json({
        error: 'Already Verified',
        message: 'Email already verified. Please login.'
      });
    }

    // Check if code matches
    if (user.verificationCode !== code) {
      return res.status(400).json({
        error: 'Verification Failed',
        message: 'Invalid verification code'
      });
    }

    // Check if code expired
    if (user.verificationCodeExpires && new Date() > new Date(user.verificationCodeExpires)) {
      return res.status(400).json({
        error: 'Code Expired',
        message: 'Verification code has expired. Please request a new one.'
      });
    }

    // Update user as verified
    await usersCollection.updateOne(
      { _id: user._id },
      {
        $set: {
          isVerified: true,
          updatedAt: new Date()
        },
        $unset: {
          verificationCode: "",
          verificationCodeExpires: ""
        }
      }
    );

    console.log('✓ User verified:', user.email);

    // Return success with token
    return res.status(200).json({
      message: 'Email verified successfully',
      token: 'mock_jwt_token_' + Date.now(),
      user: {
        id: user._id.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        isVerified: true
      }
    });
  } catch (error) {
    console.error('Verification error:', error);
    return res.status(500).json({
      error: 'Server Error',
      message: 'Verification failed. Please try again.'
    });
  }
});

app.post(`${API_PREFIX}/auth/resend-code`, (req, res) => {
  const { userId, email } = req.body;

  // Validation - accept either userId or email
  if (!userId && !email) {
    return res.status(400).json({
      error: 'Validation Error',
      message: 'userId or email is required'
    });
  }

  // Mock resend - in production, this would send email with new code
  return res.status(200).json({
    message: 'Verification code sent to your email',
    email: email || 'user@example.com',
    expiresIn: 300 // 5 minutes
  });
});

app.post(`${API_PREFIX}/auth/forgot-password`, (req, res) => {
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

app.post(`${API_PREFIX}/auth/reset-password`, (req, res) => {
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
// CFP PACKAGES
// ============================================================================

// Get CFP packages
app.get(`${API_PREFIX}/cfp/packages`, async (req, res) => {
  try {
    if (!webDb) {
      return res.status(503).json({
        success: false,
        error: 'Service Unavailable',
        message: 'Database connection not available'
      });
    }

    const packages = await webDb
      .collection('packages')
      .find({ stateSlug: 'cfp-renewal' })
      .toArray();

    res.status(200).json({
      success: true,
      data: packages,
      count: packages.length
    });
  } catch (error) {
    console.error('Error fetching CFP packages:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch CFP packages',
      message: error.message
    });
  }
});

// Get all CFP renewal data (state, courses, packages)
app.get(`${API_PREFIX}/cfp/renewal`, async (req, res) => {
  try {
    if (!webDb) {
      return res.status(503).json({
        success: false,
        error: 'Service Unavailable',
        message: 'Database connection not available'
      });
    }

    // Fetch all CFP courses (both individual courses and packages)
    const allCFPCourses = await webDb
      .collection('courses')
      .find({ stateSlug: 'cfp-renewal' })
      .toArray();

    // Fetch CFP packages from packages collection (if stored separately)
    const packagesFromCollection = await webDb
      .collection('packages')
      .find({ stateSlug: 'cfp-renewal' })
      .toArray();

    // Separate into individual courses and packages
    // Packages typically have: coursesIncluded (array), totalHours, badge
    // Individual courses have: creditHours, courseType, itemNumber
    const isPackage = (item) => {
      const courseType = (item.courseType || '').toString().toLowerCase();
      return item.type === 'package' ||
        courseType === 'package' ||
        courseType === 'bundle' ||
        (item.coursesIncluded && Array.isArray(item.coursesIncluded)) ||
        item.totalHours ||
        item.badge;
    };

    const packagesFromCourses = allCFPCourses.filter(isPackage);
    const courseCandidates = allCFPCourses.filter(item => !isPackage(item));
    const courses = courseCandidates.filter(item => item.creditHours || item.hours);

    // Merge package sources (de-dupe by _id string)
    const packageMap = new Map();
    for (const pkg of [...packagesFromCourses, ...packagesFromCollection]) {
      const key = pkg?._id ? pkg._id.toString() : JSON.stringify(pkg);
      if (!packageMap.has(key)) {
        packageMap.set(key, pkg);
      }
    }
    const packages = Array.from(packageMap.values());

    console.log(`CFP Renewal: Found ${courses.length} courses and ${packages.length} packages from ${allCFPCourses.length} courses + ${packagesFromCollection.length} packages`);

    res.status(200).json({
      success: true,
      data: {
        state: null, // No separate state collection, using null for now
        courses: courses || [],
        packages: packages || [],
      }
    });
  } catch (error) {
    console.error('Error fetching CFP renewal data:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch CFP renewal data',
      message: error.message
    });
  }
});
// ============================================================================
// CONTACT FORM
// ============================================================================

// Submit contact form
app.post(`${API_PREFIX}/contact`, async (req, res) => {
  try {
    const { name, email, subject, message } = req.body;

    // Validate required fields
    if (!name || !email || !subject || !message) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'All fields are required (name, email, subject, message)'
      });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Invalid email format'
      });
    }

    // Check if database is connected
    if (!webDb) {
      console.error('✗ Database not connected');
      return res.status(503).json({
        error: 'Service Unavailable',
        message: 'Database connection not available. Please try again later.'
      });
    }

    // Create contact message document
    const contactMessage = {
      name: name.trim(),
      email: email.trim().toLowerCase(),
      subject: subject.trim(),
      message: message.trim(),
      status: 'new',
      submittedAt: new Date()
    };

    // Insert into database
    const result = await webDb.collection('contactmessages').insertOne(contactMessage);

    console.log(`✓ Contact message received from ${email}`);

    // Send email notification to admin
    try {
      const adminEmail = 'johanesangeless.rels@gmail.com';

      const mailOptions = {
        from: `"Relstone Contact Form" <${process.env.EMAIL_USER}>`,
        to: adminEmail,
        subject: `New Contact Message: ${subject}`,
        html: `
          <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px;">
            <h2 style="color: #1A3A5C; border-bottom: 2px solid #2E7EBE; padding-bottom: 10px;">
              New Contact Form Submission
            </h2>

            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0;">
              <p style="margin: 5px 0;"><strong style="color: #1A3A5C;">Name:</strong> ${name}</p>
              <p style="margin: 5px 0;"><strong style="color: #1A3A5C;">Email:</strong> <a href="mailto:${email}" style="color: #2E7EBE;">${email}</a></p>
              <p style="margin: 5px 0;"><strong style="color: #1A3A5C;">Subject:</strong> ${subject}</p>
              <p style="margin: 5px 0;"><strong style="color: #1A3A5C;">Submitted:</strong> ${new Date().toLocaleString('en-US', { timeZone: 'America/Los_Angeles' })} PST</p>
            </div>

            <div style="background-color: white; padding: 15px; border: 1px solid #e0e5eb; border-radius: 8px; margin: 20px 0;">
              <h3 style="color: #1A3A5C; margin-top: 0;">Message:</h3>
              <p style="color: #1C2B3A; line-height: 1.6; white-space: pre-wrap;">${message}</p>
            </div>

            <div style="margin-top: 20px; padding: 15px; background-color: #e8f4fd; border-left: 4px solid #2E7EBE; border-radius: 4px;">
              <p style="margin: 0; color: #1A3A5C; font-size: 14px;">
                <strong>Quick Reply:</strong> Click on the email address above to reply directly to the sender.
              </p>
            </div>

            <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;">
            <p style="color: #666; font-size: 12px; margin: 0;">
              This message was sent from the Relstone Contact Form
            </p>
          </div>
        `
      };

      await emailTransporter.sendMail(mailOptions);
      console.log(`✓ Notification email sent to ${adminEmail}`);
    } catch (emailError) {
      console.error('✗ Failed to send notification email:', emailError.message);
      // Don't fail the request if email fails, just log it
    }

    res.status(201).json({
      message: 'Contact message received successfully',
      id: result.insertedId
    });

  } catch (error) {
    console.error('✗ Contact form error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to submit contact message. Please try again later.'
    });
  }
});

// Get all contact messages (admin)
app.get(`${API_PREFIX}/contact`, async (req, res) => {
  try {
    if (!webDb) {
      return res.status(503).json({
        error: 'Service Unavailable',
        message: 'Database connection not available'
      });
    }

    const messages = await webDb.collection('contactmessages')
      .find()
      .sort({ submittedAt: -1 })
      .toArray();

    res.status(200).json({
      messages,
      count: messages.length
    });

  } catch (error) {
    console.error('✗ Error fetching contact messages:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to fetch contact messages'
    });
  }
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

function startServer() {
  try {
    // Connect to databases in background (non-blocking)
    connectToDatabase();

    // Start the server immediately
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

