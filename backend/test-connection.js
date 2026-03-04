require('dotenv').config();

const { MongoClient } = require('mongodb');

async function testConnection() {
  console.log('\n🔍 MongoDB Connection Diagnostic Tool\n');
  console.log('═'.repeat(60));

  const adminDbUri = process.env.ADMIN_DB_URI;
  const webDbUri = process.env.WEB_DB_URI;

  // Check if URIs are set
  console.log('\n1️⃣  Connection String Validation');
  console.log('─'.repeat(60));

  if (!adminDbUri) {
    console.error('❌ ADMIN_DB_URI is not set in .env');
    process.exit(1);
  }
  if (!webDbUri) {
    console.error('❌ WEB_DB_URI is not set in .env');
    process.exit(1);
  }

  console.log('✓ Admin DB URI found');
  console.log(`  → ${adminDbUri.substring(0, 50)}...`);
  console.log('✓ Web DB URI found');
  console.log(`  → ${webDbUri.substring(0, 50)}...`);

  // Test Admin Database Connection
  console.log('\n2️⃣  Testing Admin Database Connection');
  console.log('─'.repeat(60));

  let adminClient = null;
  try {
    const mongoOptions = {
      maxPoolSize: 10,
      minPoolSize: 2,
      serverSelectionTimeoutMS: parseInt(process.env.DB_SERVER_SELECTION_TIMEOUT || '10000'),
      connectTimeoutMS: parseInt(process.env.DB_CONNECTION_TIMEOUT || '20000'),
      family: 4, // Force IPv4
    };

    console.log(`Attempting to connect with timeout: ${mongoOptions.connectTimeoutMS}ms`);

    adminClient = new MongoClient(adminDbUri, mongoOptions);
    const startTime = Date.now();

    await adminClient.connect();

    const duration = Date.now() - startTime;
    console.log(`✅ Successfully connected to Admin Database (${duration}ms)`);

    // Try to ping the server
    const admin = adminClient.db().admin();
    const result = await admin.ping();
    console.log('✅ Server ping successful:', result);

    // Get server info
    const serverStatus = await admin.serverInfo();
    console.log('✅ Server version:', serverStatus.version);

    await adminClient.close();

  } catch (error) {
    console.error('❌ Failed to connect to Admin Database');
    console.error(`Error: ${error.message}`);
    console.error(`Code: ${error.code}`);
    console.error(`Type: ${error.name}`);

    if (error.message.includes('ECONNREFUSED')) {
      console.error('\n💡 Troubleshooting: ECONNREFUSED typically means:');
      console.error('   • Network connectivity issue');
      console.error('   • Firewall blocking the connection');
      console.error('   • IP not whitelisted in MongoDB Atlas');
    }

    if (adminClient) {
      try {
        await adminClient.close();
      } catch (e) {
        // Ignore close errors
      }
    }
  }

  // Test Web Database Connection
  console.log('\n3️⃣  Testing Web Database Connection');
  console.log('─'.repeat(60));

  let webClient = null;
  try {
    const mongoOptions = {
      maxPoolSize: 10,
      minPoolSize: 2,
      serverSelectionTimeoutMS: parseInt(process.env.DB_SERVER_SELECTION_TIMEOUT || '10000'),
      connectTimeoutMS: parseInt(process.env.DB_CONNECTION_TIMEOUT || '20000'),
      family: 4, // Force IPv4
    };

    console.log(`Attempting to connect with timeout: ${mongoOptions.connectTimeoutMS}ms`);

    webClient = new MongoClient(webDbUri, mongoOptions);
    const startTime = Date.now();

    await webClient.connect();

    const duration = Date.now() - startTime;
    console.log(`✅ Successfully connected to Web Database (${duration}ms)`);

    // Try to ping the server
    const admin = webClient.db().admin();
    const result = await admin.ping();
    console.log('✅ Server ping successful:', result);

    // Get server info
    const serverStatus = await admin.serverInfo();
    console.log('✅ Server version:', serverStatus.version);

    await webClient.close();

  } catch (error) {
    console.error('❌ Failed to connect to Web Database');
    console.error(`Error: ${error.message}`);
    console.error(`Code: ${error.code}`);
    console.error(`Type: ${error.name}`);

    if (error.message.includes('ECONNREFUSED')) {
      console.error('\n💡 Troubleshooting: ECONNREFUSED typically means:');
      console.error('   • Network connectivity issue');
      console.error('   • Firewall blocking the connection');
      console.error('   • IP not whitelisted in MongoDB Atlas');
    }

    if (webClient) {
      try {
        await webClient.close();
      } catch (e) {
        // Ignore close errors
      }
    }
  }

  console.log('\n═'.repeat(60));
  console.log('📋 Diagnostic Summary');
  console.log('─'.repeat(60));
  console.log('\nNext Steps if connection fails:');
  console.log('1. Check MongoDB Atlas dashboard to ensure cluster is running');
  console.log('2. Verify your IP is whitelisted (Network Access → IP Whitelist)');
  console.log('3. Confirm database credentials are correct');
  console.log('4. Check firewall/antivirus settings on your machine');
  console.log('5. Try connecting via MongoDB Compass with the same URI');
  console.log('\n');
}

testConnection().catch(console.error);



