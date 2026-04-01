import 'package:flutter/material.dart';
import 'add_address_screen.dart'; // Import the screen for adding new addresses

// A constant for the primary theme color to ensure consistency.
const Color _primaryColor = Color(0xFF00BFA5);

class ChangeAddressScreen extends StatefulWidget {
  final String currentAddress;
  const ChangeAddressScreen({super.key, required this.currentAddress});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  // A list of maps to store structured address data
  final List<Map<String, String>> _savedAddresses = [
    {
      'label': 'Work',
      'address': 'Jl. Jenderal Sudirman No.Kav. 52-53, Senayan, Jakarta Selatan',
    },
    {
      'label': 'Home',
      'address': 'Jl. Merdeka No. 12, Menteng, Jakarta Pusat',
    },
    {
      'label': 'Other',
      'address': 'Grand Indonesia, Jl. MH Thamrin No. 1, Jakarta Pusat',
    },
  ];

  late String _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.currentAddress;
  }

  // Method to navigate and add a new address
  void _navigateAndAddAddress() async {
    // Expect a Map with 'label' and 'address' keys
    final newAddressData = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const AddAddressScreen()),
    );

    if (newAddressData != null) {
      setState(() {
        // Add the new structured address to the list
        if (!_savedAddresses.any((addr) => addr['address'] == newAddressData['address'])) {
           _savedAddresses.add(newAddressData);
        }
        // Automatically select the newly added address
        _selectedAddress = newAddressData['address']!;
      });
    }
  }

  // Helper to get an icon based on the address label
  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      default:
        return Icons.location_on_rounded;
    }
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
        title: Text(
          'Change Address',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._savedAddresses.map((addressData) {
              return _buildAddressTile(addressData);
            }).toList(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _navigateAndAddAddress,
              icon: const Icon(Icons.add, color: _primaryColor),
              label: const Text('Add New Address',
                  style: TextStyle(color: _primaryColor)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildAddressTile(Map<String, String> addressData) {
    final String address = addressData['address']!;
    final String label = addressData['label']!;
    bool isSelected = _selectedAddress == address;

    return Card(
      color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? _primaryColor : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedAddress = address;
          });
        },
        leading: Radio<String>(
          value: address,
          groupValue: _selectedAddress,
          onChanged: (value) {
            setState(() {
              _selectedAddress = value!;
            });
          },
          activeColor: _primaryColor,
        ),
        title: Row(
          children: [
            Icon(_getIconForLabel(label), color: _primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(address, style: TextStyle(color: Colors.grey[600])),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)
        ]
      ),
      child: ElevatedButton(
        onPressed: () {
          // Pop the screen and return the newly selected address
          Navigator.of(context).pop(_selectedAddress);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Confirm Address', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

