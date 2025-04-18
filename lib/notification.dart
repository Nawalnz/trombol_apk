import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Recommended place',
      'desc': 'Just for you',
      'time': '1 day ago',
    },
    {
      'title': 'Your Booking Success',
      'desc': 'You have been accepted as...',
      'time': '1 day ago',
    },
    {
      'title': 'Get an unlimited traveling',
      'desc': 'Received summer special pr...',
      'time': '2 day ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
            ),
            title: Text(notif['title']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['desc']!),
                Text(notif['time']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text("View"),
            ),
          );
        },
      ),
    );
  }
}
