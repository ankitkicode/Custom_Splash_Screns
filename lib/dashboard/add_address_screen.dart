import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// A constant for the primary theme color to ensure consistency.
const Color _primaryColor = Color(0xFF00BFA5);

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  // --- STATE VARIABLES ---
  static const LatLng _initialPosition = LatLng(-6.2088, 106.8456); // Jakarta
  GoogleMapController? _mapController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers and state
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _addressLabel = 'Home'; // To store the selected address type
  bool _isLoading = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  Future<void> _getAddressForLatLng(LatLng position) async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          );

      if (placemarks.isNotEmpty) {
        final Placemark p = placemarks.first;
        _streetController.text = p.street ?? '';
        _cityController.text =
            '${p.subLocality ?? ''}${p.subLocality != null ? ", " : ""}${p.locality ?? ''}';
        _postalCodeController.text = p.postalCode ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not fetch address. Please try again.')),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _goToCurrentUserLocation() async {
    // ... (Permission handling logic remains the same)
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16.0,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location.')),
      );
    }
    setState(() => _isLoading = false);
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      // Return a Map with more structured data
      final result = {
        'label': _addressLabel,
        'address':
            '${_streetController.text}, ${_cityController.text}, ${_postalCodeController.text}',
      };
      Navigator.of(context).pop(result);
    }
  }

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Add New Address',
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildMapView(),
          Expanded(child: _buildAddressForm()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentUserLocation,
        backgroundColor: Colors.white,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location, color: _primaryColor),
      ),
    );
  }

  Widget _buildMapView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: _initialPosition, zoom: 14.0),
            onMapCreated: (controller) {
              _mapController = controller;
              _getAddressForLatLng(_initialPosition); // Get address for initial pos
            },
            onCameraIdle: () async {
              if (_mapController != null) {
                LatLngBounds visibleRegion =
                    await _mapController!.getVisibleRegion();
                LatLng center = LatLng(
                    (visibleRegion.northeast.latitude +
                            visibleRegion.southwest.latitude) /
                        2,
                    (visibleRegion.northeast.longitude +
                            visibleRegion.southwest.longitude) /
                        2);
                _getAddressForLatLng(center);
              }
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
          ),
          const Center(
              child: Icon(Icons.location_pin,
                  size: 50, color: _primaryColor)),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading) const LinearProgressIndicator(color: _primaryColor),
            const SizedBox(height: 8),
            // Address Label Chips
            const Text('Label As',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildLabelChips(),
            const SizedBox(height: 24),
            // Form Fields
            _buildTextFormField(_streetController, 'Street Address'),
            const SizedBox(height: 16),
            _buildTextFormField(_cityController, 'City / Region'),
            const SizedBox(height: 16),
            _buildTextFormField(_postalCodeController, 'Postal Code',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextFormField(_detailsController, 'Apt / Suite / Floor (Optional)',
                isRequired: false),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                child:
                    const Text('Save Address', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelChips() {
    return Wrap(
      spacing: 8.0,
      children: ['Home', 'Work', 'Other'].map((label) {
        bool isSelected = _addressLabel == label;
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _addressLabel = label);
            }
          },
          selectedColor: _primaryColor,
          labelStyle:
              TextStyle(color: isSelected ? Colors.white : Colors.black87),
          backgroundColor: Colors.grey[200],
          side: BorderSide(color: Colors.grey.shade300),
        );
      }).toList(),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: isRequired
          ? (value) =>
              value!.isEmpty ? 'Please enter a ${label.toLowerCase()}' : null
          : null,
    );
  }
}

