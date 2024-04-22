import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtuNavigation/models/place_item.dart';
import 'package:dtuNavigation/models/place_search.dart';
import 'package:dtuNavigation/services/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  //Variables
  Position? currentLocation;
  late List<PlaceSearch> searchResults;
  late StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  late String placeType;
  late String placeSelected;
  late List<Placeitem> placeResults;
  List<Marker> markers = [];
  List<Marker> dtuMarkers = [];
  late List<Placeitem> restaurantsInfo;

  ApplicationBloc() {
    setCurrentLocation();
  }

  Future<Position> setCurrentLocation() async {
    Position currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
    return currentLocation;
  }
}
