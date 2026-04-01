import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notification data for a modern look
    final List<Map<String, dynamic>> notifications = [
      {
        'icon': Icons.local_shipping,
        'color': Colors.green,
        'title': 'Your order has been shipped!',
        'subtitle': 'Your Cookies order is on its way to you.',
        'time': '10 min ago'
      },
      {
        'icon': Icons.check_circle,
        'color': Colors.blueAccent,
        'title': 'Order Delivered Successfully',
        'subtitle': 'Your Spageti order has been delivered.',
        'time': '1 day ago'
      },
      {
        'icon': Icons.local_offer,
        'color': Colors.orangeAccent,
        'title': 'Don\'t Miss This Special Offer!',
        'subtitle': 'Get 20% off on your next Pizza order. Code: YUM20',
        'time': '2 days ago'
      },
      {
        'icon': Icons.payment,
        'color': Colors.redAccent,
        'title': 'Payment Failed',
        'subtitle': 'Your payment for the Big Bu order failed. Please try again.',
        'time': '3 days ago'
      },
       {
        'icon': Icons.rate_review,
        'color': Colors.purpleAccent,
        'title': 'Rate Your Last Order',
        'subtitle': 'How was the Spageti? Let us know!',
        'time': '3 days ago'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 1.0,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              leading: CircleAvatar(
                backgroundColor: notification['color'].withOpacity(0.1),
                child: Icon(notification['icon'], color: notification['color']),
              ),
              title: Text(notification['title'], style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.black , fontSize: 14)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(notification['subtitle'] , style: const TextStyle(color: Colors.grey , fontSize: 12)),
              ),
              trailing: Text(notification['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }
}
