import 'dart:convert';

class DeviceData {
  final String deviceName;
  final int dataCount;
  final List<DataEntry> data;

  DeviceData({
    required this.deviceName,
    required this.dataCount,
    required this.data,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      deviceName: json['deviceName'],
      dataCount: json['dataCount'],
      data: (json['data'] as List)
          .map((e) => DataEntry.fromMap(e))
          .toList(),
    );
  }
}

class DataEntry {
  final double? temp;
  final double? hum;
  final int? pulse;
  final int? gas;

  DataEntry({
    this.temp,
    this.hum,
    this.pulse,
    this.gas,
  });

  factory DataEntry.fromMap(Map<String, dynamic> map) {
    return DataEntry(
      temp: (map['temp'] != null) ? (map['temp'] as num).toDouble() : null,
      hum: (map['hum'] != null) ? (map['hum'] as num).toDouble() : null,
      pulse: map['pulse'] != null ? map['pulse'] as int : null,
      gas: map['gas'] != null ? map['gas'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'hum': hum,
      'pulse': pulse,
      'gas': gas,
    };
  }

  factory DataEntry.fromJson(String source) =>
      DataEntry.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class Device {
  final String? id;
  final String name;
  final String wifi;
  final String pass;
  final List<DataEntry> data;

  Device({
    this.id,
    required this.name,
    required this.wifi,
    required this.pass,
    required this.data,
  });

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['_id'],
      name: map['name'] ?? '',
      wifi: map['wifi'] ?? '',
      pass: map['pass'] ?? '',
      data: map['data'] != null
          ? List<DataEntry>.from(
          (map['data'] as List).map((x) => DataEntry.fromMap(Map<String, dynamic>.from(x))))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'wifi': wifi,
      'pass': pass,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
