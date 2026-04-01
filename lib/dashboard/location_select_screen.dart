import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedPosition;
  String _currentAddress = "Loading...";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _goToCurrentUserLocation(); // App start → current location
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Get address from LatLng ---
  Future<void> _getAddressForLatLng(LatLng position) async {
    setState(() {
      _isLoading = true;
      _currentAddress = "Loading...";
    });
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
      } else {
        _currentAddress = "No address found for this location.";
      }
    } catch (e) {
      _currentAddress = "Could not get address. Please try again.";
    }
    setState(() {
      _isLoading = false;
    });
  }

  // --- Search and go to location ---
  Future<void> _searchAndGoToLocation() async {
    final String searchText = _searchController.text;
    if (searchText.isEmpty) return;

    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() => _isLoading = true);

    try {
      List<Location> locations = await locationFromAddress(searchText);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        final LatLng newLatLng =
            LatLng(location.latitude, location.longitude);

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLatLng, 15.0),
        );

        setState(() {
          _selectedPosition = newLatLng;
        });

        // update address also
        await _getAddressForLatLng(newLatLng);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Location not found. Try being more specific.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Error searching for location. Please check your connection.")),
      );
    }
    setState(() => _isLoading = false);
  }

  // --- Go to user's current location ---
  Future<void> _goToCurrentUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // ✅ पहले last known location लो (fast fix)
    Position? position = await Geolocator.getLastKnownPosition();

    // ✅ अगर null है या पुरानी है तो high accuracy से लो
    position ??= await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng userLatLng = LatLng(position.latitude, position.longitude);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(userLatLng, 16.0),
    );

    setState(() {
      _selectedPosition = userLatLng;
    });

    await _getAddressForLatLng(userLatLng);
    setState(() => _isLoading = false);
  }

  // --- Get the map's center ---
  Future<LatLng> _getCenter() async {
    final GoogleMapController controller = _mapController!;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    return LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
  }

  // --- UI BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(20.5937, 78.9629), zoom: 5.0), // India default
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraIdle: () async {
              if (_mapController != null) {
                LatLng center = await _getCenter();
                setState(() {
                  _selectedPosition = center;
                });
                _getAddressForLatLng(center);
              }
            },
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          const Center(
            child: Icon(Icons.location_pin,
                size: 50, color: Color(0xFF00BFA5)),
          ),
          _buildTopBar(),
          _buildBottomSheet(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentUserLocation,
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Color(0xFF00BFA5)),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _searchAndGoToLocation(),
                    decoration: InputDecoration(
                      hintText: 'Search for a place...',
                      border: InputBorder.none,
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => _searchController.clear(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('SELECT DELIVERY LOCATION',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF00BFA5)),
                const SizedBox(width: 8),
                Expanded(
                  child: _isLoading
                      ? const LinearProgressIndicator()
                      : Text(_currentAddress,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final result = {
                          'latlng': _selectedPosition,
                          'address': _currentAddress
                        };
                        Navigator.of(context).pop(result);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text('Confirm Location',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
