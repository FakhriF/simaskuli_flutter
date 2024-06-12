import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simaskuli/controller/buildings_controller.dart';
import 'package:simaskuli/models/course_building.dart';

class MapsPage extends StatefulWidget {
  final int courseId;
  const MapsPage({super.key, required this.courseId});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late LatLng loc = LatLng(-6.972804652872605, 107.63214673535177);
  late double lat = -6.972804652872605;
  late double long = 107.63214673535177;
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _loadBuildingData();
    loc = LatLng(lat as double, long as double); //perbaikiiii
  }

  Future<void> _loadBuildingData() async {
    try {
      final List<CourseBuilding> buildings = await BuildingsController().getCourseBuilding(widget.courseId);
      setState(() {
        if (buildings.isNotEmpty) {
          // Take the first building from the list
          loc = LatLng(buildings[0].latitude, buildings[0].longitude);
        } else {
          // Set default location if there are no buildings
          loc = const LatLng(-6.972804652872605, 107.63214673535177);
        }
      });
    } catch (e) {
      print('Failed to load building data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Building Maps'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(initialCenter: loc),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: loc,
                width: 80,
                height: 80,
                child: Icon(
                  Icons.location_on,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
