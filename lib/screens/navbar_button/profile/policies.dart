import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
1. Data Collection
Personal data such as name, email, and phone number will be collected.


2. Use of Data
User data is used for booking confirmations, personalization, and marketing.


3. Data Sharing
User's personal data is not shared with any service providers or partners.


4. Cookies and Tracking
Our app does not use cookies or analytics tools.

5. Data Security
Only admins are able to view user's data.


6. User Rights
Users unfortunately does not have the right to access, correct, delete their data.


7. Children’s Privacy
This app doesn’t knowingly collect data from minors (if applicable).

          ''',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
        ),
      ),
    );
  }
}