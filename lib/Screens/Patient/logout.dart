import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // تعيين خلفية شفافة
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // User clicked on "Logout"
                    Navigator.of(context)
                        .pop(true); // Return true to indicate logout
                  },
                  child: Text('Logout'),
                ),
                TextButton(
                  onPressed: () {
                    // User clicked on "Cancel"
                    Navigator.of(context)
                        .pop(false); // Return false to indicate cancel
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
