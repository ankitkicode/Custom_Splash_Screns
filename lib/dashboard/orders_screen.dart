import 'package:flutter/material.dart';
import 'order_details_screen.dart'; // Details screen ko import karein

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Sample list of all orders
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#G54H1',
      'status': 'Completed',
      'date': 'Aug 28, 2025',
      'items': [
        {'name': 'Caesar Salad', 'quantity': 1, 'image': '🥗'},
        {'name': 'Cheesecake', 'quantity': 2, 'image': '🍰'},
      ],
      'totalPrice': 37.50,
    },
    {
      'id': '#K89J2',
      'status': 'In Progress',
      'date': 'Aug 30, 2025',
      'items': [
        {'name': 'Pepperoni Pizza', 'quantity': 1, 'image': '🍕'},
      ],
      'totalPrice': 22.00,
    },
     {
      'id': '#L12M3',
      'status': 'In Progress',
      'date': 'Aug 30, 2025',
      'items': [
        {'name': 'Classic Burger', 'quantity': 2, 'image': '🍔'},
        {'name': 'Glazed Donuts', 'quantity': 4, 'image': '🍩'},
      ],
      'totalPrice': 52.00,
    },
    {
      'id': '#A45B6',
      'status': 'Cancelled',
      'date': 'Aug 29, 2025',
      'items': [
        {'name': 'Spaghetti', 'quantity': 1, 'image': '🥐'},
      ],
      'totalPrice': 19.00,
    },
    {
      'id': '#C78D9',
      'status': 'Completed',
      'date': 'Aug 25, 2025',
      'items': [
        {'name': 'Greek Salad', 'quantity': 1, 'image': '🥗'},
        {'name': 'Veggie Burger', 'quantity': 1, 'image': '🍔'},
      ],
      'totalPrice': 28.50,
    },
  ];

  // Helper function to get the color associated with a status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue.shade700;
      case 'Completed':
        return Colors.green.shade700;
      case 'Cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          // We don't need a back button here as it's part of the main navigation
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: const Color(0xFF00BFA5),
            labelColor: const Color(0xFF00BFA5),
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList('In Progress'),
            _buildOrdersList('Completed'),
            _buildOrdersList('Cancelled'),
          ],
        ),
      ),
    );
  }

  // Builds a list of orders based on the provided status
  Widget _buildOrdersList(String status) {
    final filteredOrders =
        _allOrders.where((order) => order['status'] == status).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'No $status orders found.',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // A reusable widget to display a single order card
  Widget _buildOrderCard(Map<String, dynamic> order) {
    // Card ko InkWell se wrap kiya gaya hai
    return InkWell(
      onTap: () {
        // Click karne par OrderDetailsScreen par navigate karein
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12), // Ripple effect ke liye
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order: ${order['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: _getStatusColor(order['status']),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Middle section for items
              Text(
                '${order['items'].length} Items',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ...List.generate(order['items'].length, (index) {
                final item = order['items'][index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Text(item['image'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('${item['quantity']}x ${item['name']}'),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              // Bottom row with Date and Total Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order['date'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  Text(
                    '\$${order['totalPrice'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA5),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

