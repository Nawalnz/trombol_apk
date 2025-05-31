import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Recommended Place',
      'desc': 'Just for you',
      'time': '1 day ago',
    },
    {
      'title': 'Your Booking Success',
      'desc': 'You have been accepted as...',
      'time': '1 day ago',
    },
    {
      'title': 'Get Unlimited Traveling',
      'desc': 'Received summer special promotion...',
      'time': '2 days ago',
    },
  ];

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: textTheme.titleLarge?.copyWith (color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (Theme.of(context).brightness == Brightness.light)
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.notifications, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'] ?? '',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['desc'] ?? '',
                        style: textTheme.bodyMedium?.copyWith(color: textTheme.bodyMedium?.color?.withAlpha(178)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['time'] ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // TODO: Open notification detail
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: colorScheme.surface,
    );
  }
}
