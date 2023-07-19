import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:users/global/map_key.dart';

import 'directions_model.dart';

class DirectionsRepo {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio _dio;

  DirectionsRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        "origin": '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination}',
        'key': mapKey,
      },
    );

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
