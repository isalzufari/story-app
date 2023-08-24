import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/util/show_toast.dart';

import '../routes/location_manager.dart';

class AddLocationPage extends StatefulWidget {
  final VoidCallback onSuccessAddLocation;

  const AddLocationPage({super.key, required this.onSuccessAddLocation});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Location")),
        floatingActionButton:
            _selectedLocation != null ? _selectFloatingButton(context) : null,
        body: FutureBuilder(
          future: _getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: snapshot.data!, zoom: 18),
                onMapCreated: _onMapCreated,
                onTap: _onMapTap,
                markers: _markers,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _selectFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<LocationPageManager>().returnData(_selectedLocation!);
        widget.onSuccessAddLocation();
      },
      child: const Icon(Icons.check),
    );
  }

  Future<LatLng> _getCurrentLocation() async {
    final location = Location();
    LocationData locationData;
    try {
      locationData = await location.getLocation();
      return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      showToast('Error: $e');
      return const LatLng(0, 0);
    }
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _markers.clear(); // Clear existing markers
      _markers.add(Marker(
        markerId: const MarkerId('selectedLocation'),
        position: latLng,
      ));
    });
  }
}
