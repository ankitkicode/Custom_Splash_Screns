import 'package:flutter/material.dart';
import 'checkout_screen.dart'; // Import the new checkout screen

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample data for cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'image': '🍰',
      'name': 'Cookies',
      'price': 12.00,
      'quantity': 1,
      'color': const Color(0xFFFFF0E5),
    },
    {
      'image': '🥐',
      'name': 'Spageti',
      'price': 16.00,
      'quantity': 1,
      'color': const Color(0xFFFFEAA7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate total price
    double totalPrice = _cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(
                      child: Text(
                      'Your cart is empty.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(_cartItems[index]);
                      },
                    ),
            ),
            if (_cartItems.isNotEmpty) ...[
              _buildPriceDetails(totalPrice),
              const SizedBox(height: 20),
              _buildCheckoutButton(totalPrice), // Pass total price to the button
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(item['image'], style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('\$${item['price'].toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey[800])),
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.grey[600],
                onPressed: () {
                  setState(() {
                    if (item['quantity'] > 1) {
                      item['quantity']--;
                    } else {
                      // Remove item if quantity is 1
                      _cartItems.remove(item);
                    }
                  });
                },
              ),
              Text(item['quantity'].toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF00BFA5),
                onPressed: () {
                  setState(() {
                    item['quantity']++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(double totalPrice) {
    const double deliveryFee = 2.00;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              Text('\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              Text('\$${deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('\$${(totalPrice + deliveryFee).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // Updated to accept totalPrice for navigation
  Widget _buildCheckoutButton(double totalPrice) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the CheckoutScreen, passing the total price
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(totalPrice: totalPrice),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00BFA5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Proceed to Checkout',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
