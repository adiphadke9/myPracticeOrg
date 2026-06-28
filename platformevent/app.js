const jsforce = require('jsforce');
const express = require('express');

const app = express();
const port = 3000;

// OAuth2 configuration
const oauth2 = new jsforce.OAuth2({
  loginUrl: 'https://login.salesforce.com', // use test.salesforce.com for sandbox
  clientId: 'SF_clientID',
  clientSecret: 'SF_client secret',
  redirectUri: 'http://localhost:3000/oauth2/callback'
});

// Step 1: Redirect user to Salesforce login
app.get('/oauth2/auth', (req, res) => {
  const authUrl = oauth2.getAuthorizationUrl();
  console.log('Redirecting to:', authUrl);
  res.redirect(authUrl);
});

// Step 2: Callback after login
app.get('/oauth2/callback', async (req, res) => {
  try {
    const code = req.query.code;

    if (!code) {
      return res.status(400).send('❌ No authorization code received');
    }

    console.log('✅ Received Auth Code:', code);

    const conn = new jsforce.Connection({ oauth2 });

    // Exchange code for token
    const userInfo = await conn.authorize(code);

    console.log('✅ Access Token:', conn.accessToken);
    console.log('✅ Refresh Token:', conn.refreshToken);
    console.log('✅ Instance URL:', conn.instanceUrl);
    console.log('✅ User ID:', userInfo.id);
    console.log('✅ Org ID:', userInfo.organizationId);

    const eventName = '/event/SAP_Account__e';
    const subscription = conn.streaming.topic(eventName).subscribe(function(payload){
        console.log('Received message:\n',JSON.stringify(payload,null,2));
    });
    res.send('✅ Authorization successful! You can close this page.');

    const dataCaptureName = '/data/ContactChangeEvent';
        const subscriptionCDCContact = conn.streaming.topic(dataCaptureName).subscribe(function(payload){
        console.log('CDC Received message:\n',JSON.stringify(payload,null,2));
    });

  } catch (err) {
    console.error('❌ Auth Error:', err);

    res.status(500).send(
      '❌ Authentication failed: ' + err.message
    );
  }
});

// Start server
app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
  console.log(`👉 Open http://localhost:${port}/oauth2/auth to start login`);
});