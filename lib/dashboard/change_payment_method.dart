import 'package:flutter/material.dart';

// A constant for the primary theme color.
const Color _primaryColor = Color(0xFF00BFA5);

class ChangePaymentMethodScreen extends StatefulWidget {
  final String currentPaymentMethod;
  const ChangePaymentMethodScreen({super.key, required this.currentPaymentMethod});

  @override
  State<ChangePaymentMethodScreen> createState() => _ChangePaymentMethodScreenState();
}

class _ChangePaymentMethodScreenState extends State<ChangePaymentMethodScreen> {
  // Updated list to include UPI
  final List<Map<String, dynamic>> _savedMethods = [
    {'type': 'Card', 'details': 'Mastercard •••• •••• •••• 1234', 'icon': Icons.credit_card},
    {'type': 'Card', 'details': 'Visa •••• •••• •••• 5678', 'icon': Icons.credit_card_outlined},
    {'type': 'UPI', 'details': 'UPI / QR Code', 'icon': Icons.qr_code_scanner_rounded},
    {'type': 'Cash', 'details': 'Cash on Delivery', 'icon': Icons.money_rounded},
  ];

  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.currentPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment Methods', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._savedMethods.map((method) => _buildMethodTile(method)).toList(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () { /* Logic to add a new card */ },
              icon: const Icon(Icons.add, color: _primaryColor),
              label: const Text('Add New Card', style: TextStyle(color: _primaryColor)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildMethodTile(Map<String, dynamic> method) {
    final String details = method['details'];
    bool isSelected = _selectedMethod == details;

    return Card(
      color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? _primaryColor : Colors.grey.shade300, width: 1.5),
      ),
      elevation: 0,
      child: ListTile(
        onTap: () => setState(() => _selectedMethod = details),
        leading: Radio<String>(
          value: details,
          groupValue: _selectedMethod,
          onChanged: (value) => setState(() => _selectedMethod = value!),
          activeColor: _primaryColor,
        ),
        title: Row(
          children: [
            Icon(method['icon'], color: _primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(details, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(_selectedMethod),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Confirm', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

