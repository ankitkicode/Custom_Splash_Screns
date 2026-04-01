import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingOrderScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const TrackingOrderScreen({super.key, required this.order});

  @override
  State<TrackingOrderScreen> createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  // --- Map State ---
  final Completer<GoogleMapController> _mapController = Completer();
  Timer? _locationTimer;

  // --- Locations (Hardcoded for Demo) ---
  // Using locations in Jakarta to match app context
  static const LatLng _restaurantLocation = LatLng(-6.2244, 106.8096);
  static const LatLng _destinationLocation = LatLng(-6.2088, 106.8456);
  LatLng _driverLocation = _restaurantLocation;

  // --- Map Markers & Polylines ---
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  // --- Tracking Timeline State ---
  int _currentStep = 0; // Start at 'Confirmed'
  final List<String> _stepTimes = ['1:15 PM', '', '', ''];

  @override
  void initState() {
    super.initState();
    _startOrderSimulation();
  }
  
  @override
  void dispose() {
    // Cancel the timer when the widget is removed to prevent memory leaks
    _locationTimer?.cancel();
    super.dispose();
  }

  // --- SIMULATION LOGIC ---
  void _startOrderSimulation() {
    // A timer to simulate the driver's movement and update the timeline
    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
         // Update tracking timeline step
        if (_currentStep < 3) {
          _currentStep++;
          _stepTimes[_currentStep] = _getCurrentTime();
        }

        // --- Simulate driver's movement (linear interpolation for demo) ---
        double progress = (timer.tick / 15).clamp(0.0, 1.0); // Simulates a 45-second trip
        _driverLocation = LatLng(
          _restaurantLocation.latitude + (_destinationLocation.latitude - _restaurantLocation.latitude) * progress,
          _restaurantLocation.longitude + (_destinationLocation.longitude - _restaurantLocation.longitude) * progress,
        );
        
        // Update map markers and draw the route
        _updateMapElements();

        // Stop the timer when the driver reaches the destination
        if (progress >= 1.0) {
          timer.cancel();
        }
      });
    });
  }

  // Updates the markers and polylines on the map
  void _updateMapElements() {
     _markers.clear();
    // Restaurant Marker
    _markers.add(Marker(
      markerId: const MarkerId('restaurant'),
      position: _restaurantLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Restaurant'),
    ));
    // Driver Marker
    _markers.add(Marker(
      markerId: const MarkerId('driver'),
      position: _driverLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'Driver'),
    ));

    // Draw the polyline from restaurant to the driver's current position
    _polylines.add(Polyline(
      polylineId: const PolylineId('route'),
      points: [_restaurantLocation, _driverLocation],
      color: const Color(0xFF00BFA5),
      width: 5,
    ));
  }
  
  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }


  // --- UI BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    _updateMapElements(); // Initial setup

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Track Order',
          style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _restaurantLocation,
                  zoom: 14,
                ),
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDeliveryDriverCard(),
                  const SizedBox(height: 16),
                  _buildTrackingTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDriverCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFF00BFA5),
              child: Icon(Icons.delivery_dining_outlined, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'Your Delivery Driver',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call_outlined),
              color: const Color(0xFF00BFA5),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }

  // This card contains the custom timeline for tracking
  Widget _buildTrackingTimeline() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            _buildTimelineStep(
              icon: Icons.check_circle,
              title: 'Order Confirmed',
              subtitle: 'Your order has been confirmed',
              time: _stepTimes[0],
              isCompleted: _currentStep >= 0,
              isFirst: true,
            ),
            _buildTimelineStep(
              icon: Icons.sync,
              title: 'Processing',
              subtitle: 'Your order is being prepared',
              time: _stepTimes[1],
              isCompleted: _currentStep >= 1,
            ),
            _buildTimelineStep(
              icon: Icons.delivery_dining,
              title: 'On The Way',
              subtitle: 'Our delivery partner is on the way',
              time: _stepTimes[2],
              isCompleted: _currentStep >= 2,
            ),
            _buildTimelineStep(
              icon: Icons.home_filled,
              title: 'Delivered',
              subtitle: 'Your order has been delivered',
              time: _stepTimes[3],
              isCompleted: _currentStep >= 3,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  // A custom widget to build each step of the timeline
  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final activeColor = const Color(0xFF00BFA5);
    final inactiveColor = Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? activeColor : inactiveColor,
              ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: isCompleted ? activeColor : inactiveColor, width: 2),
                shape: BoxShape.circle,
                color: isCompleted ? activeColor : Colors.white,
              ),
              child: Icon(icon, color: isCompleted ? Colors.white : inactiveColor, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? activeColor : inactiveColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.grey[700] : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.grey[700] : Colors.grey,
          ),
        ),
      ],
    );
  }
}

