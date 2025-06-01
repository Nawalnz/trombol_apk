import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
          'Terms and Conditions',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
1. Acceptance of Terms
Users must agree to the terms before using the app.

Use constitutes acceptance.

2. Eligibility
Specify minimum age (e.g., 18+).

User must provide accurate and up-to-date information.

3. Account Responsibility
Users are responsible for their login credentials.

You are not liable for unauthorized access due to user negligence.

You will:

- abide by Our values
- comply with all applicable laws
- cooperate with any anti-fraud/anti-money laundering checks we need to carry out
- not use the Platform to cause a nuisance or make fake Bookings
- use the Travel Experience and/or Platform for their intended purpose
- not cause any nuisance or damage, and not behave inappropriately to the Service Provider’s personnel (or anyone else, for that matter).

4. Booking Process
When you book an activity/accommodation/attraction, we provides and are responsible for the platform, but not the travel experience.

The payments will be confirmed once you have scan the qr code and we required you to confirm the process.

5. Cancellations and Refunds
If you cancel a reservation within any permitted cancellation period which may apply, we will refund you the exact same amount we initially charged you 

If you cancel a Booking or don’t show up, any cancellation/no-show fee or refund will depend on the Service Provider’s cancellation/no-show policy.

6. Modification of Bookings
Users can modify bookings.


7. Prohibited Activities
No fraudulent bookings, misrepresentation, illegal activity.

No abuse of promotional offers.

8. Limitation of Liability
1. Nothing in these Terms will limit our (or the Service Provider’s) liability (i) when we (or they) were negligent and this led to death or personal injury; (ii) in case of fraud or fraudulent misrepresentation; (iii) in respect of gross negligence or willful misconduct; or (iv) if such liability can otherwise not lawfully be limited or excluded.

2. If you are in breach of these Terms and/or the Service Provider’s terms, we won’t be liable for any costs you incur as a result.

3. We are not liable for:

any losses or damages which were not reasonably foreseeable when you made your Booking or otherwise entered into these Terms; or
any event which was reasonably beyond our control.

9. Termination of Use
If we caught any users abuse the terms, we may terminate the user’s access.
          ''',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
        ),
      ),
    );
  }
}