class AutoGenerate {
  AutoGenerate({
    required this.markers,
  });
  late final List<Markers> markers;
  
  AutoGenerate.fromJson(Map<String, dynamic> json){
    markers = List.from(json['markers']).map((e)=>Markers.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['markers'] = markers.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Markers {
  Markers({
    required this.no,
    required this.region,
    required this.address,
    required this.auxaddres,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.power,
    required this.service,
    
    
  });
  late final int no;
  late final String region;
  late final String address;
  late final String auxaddres;
  late final String latitude;
  late final String longitude;
  late final String type;
  late final String power;
  late final String service;
  
  Markers.fromJson(Map<String, dynamic> json){
    no = json['no'];
    region = json['region'];
    address = json['address'];
    auxaddres = json['auxaddres'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    type = json['type'];
    power = json['power'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['no'] = no;
    _data['region'] = region;
    _data['address'] = address;
    _data['auxaddres'] = auxaddres;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['type'] = type;
    _data['power'] = power;
    _data['service'] = service;
    return _data;
  }
}