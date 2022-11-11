import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String apiKey = "AIzaSyCWzID_gJhk6KVT6xjs79zirn7QJGXpG-A";

Future<Position> getCurrentLocation() async {
  // Position position = await GeolocatorPlatform.instance
  //     .getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high,));
  Position position = await Geolocator.getCurrentPosition();
  return position;
}

Future<ReverseGeoCodingModel> reverseGeoCoding(double lat, double long) async {
  var response = await http.get(Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey"));
  print(response.body);
  return reverseGeoCodingModelFromJson(response.body);
}

class ReverseGeoCodingModel {
  ReverseGeoCodingModel({
    this.plusCode,
    required this.results,
    this.status,
  });

  PlusCode? plusCode;
  late List<Result> results;
  String? status;

  factory ReverseGeoCodingModel.fromJson(Map<String, dynamic> json) =>
      ReverseGeoCodingModel(
        plusCode: PlusCode.fromJson(json["plus_code"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode?.toJson(),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String? compoundCode;
  String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  Result({
    required this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.plusCode,
    required this.types,
  });

  late List<AddressComponent> addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  PlusCode? plusCode;
  late List<String> types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
        "plus_code": plusCode == null ? null : plusCode?.toJson(),
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    required this.types,
  });

  String? longName;
  String? shortName;
  late List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  Location? location;
  LocationType? locationType;
  Viewport? viewport;
  Viewport? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: locationTypeValues.map[json["location_type"]],
        viewport: Viewport.fromJson(json["viewport"]),
        bounds:
            json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationTypeValues.reverse?[locationType],
        "viewport": viewport?.toJson(),
        "bounds": bounds == null ? null : bounds?.toJson(),
      };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

enum LocationType { GEOMETRIC_CENTER, ROOFTOP, APPROXIMATE }

final locationTypeValues = EnumValues({
  "APPROXIMATE": LocationType.APPROXIMATE,
  "GEOMETRIC_CENTER": LocationType.GEOMETRIC_CENTER,
  "ROOFTOP": LocationType.ROOFTOP
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

ReverseGeoCodingModel reverseGeoCodingModelFromJson(String str) =>
    ReverseGeoCodingModel.fromJson(json.decode(str));

String reverseGeoCodingModelToJson(ReverseGeoCodingModel data) =>
    json.encode(data.toJson());
