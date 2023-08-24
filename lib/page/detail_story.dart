import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_detail.dart';
import 'package:story_app/widget/card_detail.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryPage extends StatefulWidget {
  final String storyId;
  final VoidCallback onCloseDetailPage;

  const DetailStoryPage({
    super.key,
    required this.storyId,
    required this.onCloseDetailPage,
  });

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<DetailStoryProvider>(
          create: (context) =>
              DetailStoryProvider(ApiService(), widget.storyId),
          builder: (context, child) => Consumer<DetailStoryProvider>(
            builder: (context, provider, _) {
              switch (provider.state) {
                case ResultState.loading:
                  return const Center(child: CircularProgressIndicator());
                case ResultState.hasData:
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        DetailStory(story: provider.story),
                        if (provider.story.lat != null &&
                            provider.story.lon != null)
                          _buildMap(provider.story)
                      ],
                    ),
                  );

                case ResultState.error:
                case ResultState.noData:
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(provider.message),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () =>
                              {provider.getDetailStory(widget.storyId)},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('Refresh')],
                          ),
                        ),
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.onCloseDetailPage();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _buildMap(Story story) {
    final location = LatLng(story.lat!, story.lon!);

    Future<void> onMapCreated(GoogleMapController controller) async {
      final info = await geo.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      final place = info[0];
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      setState(() {
        placemark = place;
      });

      final marker = Marker(
        markerId: MarkerId(story.id!),
        position: location,
        infoWindow: InfoWindow(
          title: street,
          snippet: address,
        ),
      );
      markers.add(marker);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          child: const Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (placemark != null) Placemark(placemark: placemark!),
        Container(
          height: 320,
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GoogleMap(
            onMapCreated: onMapCreated,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: markers.toSet(),
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 18,
            ),
          ),
        )
      ],
    );
  }
}

class Placemark extends StatelessWidget {
  final geo.Placemark placemark;

  const Placemark({super.key, required this.placemark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(placemark.street!),
                const SizedBox(height: 10),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
