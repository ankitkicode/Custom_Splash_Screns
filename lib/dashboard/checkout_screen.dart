import 'package:demo_flutter_project/dashboard/change_payment_method.dart';
import 'package:demo_flutter_project/dashboard/order_placed_screen.dart';
import 'package:flutter/material.dart';
import 'change_address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPrice;

  const CheckoutScreen({super.key, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // State for address and payment method
  String _deliveryAddress = 'Jl. Jenderal Sudirman No.Kav. 52-53, Senayan, Jakarta Selatan';
  String _paymentMethod = 'Mastercard •••• •••• •••• 1234';

  // --- NAVIGATION LOGIC ---

  void _navigateAndChangeAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeAddressScreen(currentAddress: _deliveryAddress),
      ),
    );
    if (newAddress != null && newAddress is String) {
      setState(() {
        _deliveryAddress = newAddress;
      });
    }
  }

  void _navigateAndChangePaymentMethod() async {
    final newMethod = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePaymentMethodScreen(currentPaymentMethod: _paymentMethod),
      ),
    );
    if (newMethod != null && newMethod is String) {
      setState(() {
        _paymentMethod = newMethod;
      });
    }
  }

  // --- ORDER PLACEMENT LOGIC ---

  void _handleOrderPlacement() {
    // Navigate to the success screen, removing all previous routes from the stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessfulScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  void _showQrCodeDialog(BuildContext context, double totalPayable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Scan to Pay', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Use any UPI app to scan and complete your payment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.qr_code_scanner_rounded, size: 180, color: Colors.black87),
              const SizedBox(height: 20),
              Text(
                'Amount: \$${totalPayable.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
              ),
              child: const Text('Payment Done'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _handleOrderPlacement(); // Navigate to success screen
              },
            ),
          ],
        );
      },
    );
  }

  // --- UI HELPER ---

  IconData _getIconForPaymentMethod(String method) {
    if (method.toLowerCase().contains('cash')) return Icons.money_rounded;
    if (method.toLowerCase().contains('upi')) return Icons.qr_code_2_rounded;
    return Icons.credit_card_rounded;
  }

  // --- BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    const double deliveryFee = 2.00;
    final double totalPayable = widget.totalPrice + deliveryFee;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressCard(),
            const SizedBox(height: 16),
            _buildPaymentCard(),
            const SizedBox(height: 16),
            _buildOrderSummaryCard(widget.totalPrice, deliveryFee, totalPayable),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, totalPayable),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: _navigateAndChangeAddress,
                  child: const Text('Change', style: TextStyle(color: Color(0xFF00BFA5))),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Color(0xFF00BFA5)),
                const SizedBox(width: 12),
                Expanded(child: Text(_deliveryAddress, style: const TextStyle(fontSize: 14))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: _navigateAndChangePaymentMethod,
                  child: const Text('Change', style: TextStyle(color: Color(0xFF00BFA5))),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(_getIconForPaymentMethod(_paymentMethod), color: const Color(0xFF00BFA5)),
                const SizedBox(width: 12),
                Expanded(child: Text(_paymentMethod, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(double subtotal, double deliveryFee, double total) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(height: 24),
            _buildPriceRow('Subtotal', subtotal),
            _buildPriceRow('Delivery Fee', deliveryFee),
            const Divider(height: 24),
            _buildPriceRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double totalPayable) {
    bool isCash = _paymentMethod.toLowerCase().contains('cash');
    bool isUpi = _paymentMethod.toLowerCase().contains('upi');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10)],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Payable', style: TextStyle(color: Colors.grey[600])),
              Text(
                '\$${totalPayable.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (isUpi) {
                _showQrCodeDialog(context, totalPayable);
              } else {
                _handleOrderPlacement();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isCash ? 'Place Order' : (isUpi ? 'Show QR to Pay' : 'Confirm & Pay'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

