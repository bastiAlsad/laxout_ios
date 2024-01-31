import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:new_projekt/heatmap/funktions.dart';

class HiveHeatmap {
  late DateTime startDate;

  final _hive = Hive.box("Heatmap");

  Map<DateTime, int> datasetsMap = {};

  Map<DateTime, int> getDatasets() {
    if (_hive.get("DATASETS") == null) {
      datasetsMap = {
        createDateTimeObject(todaysDateFormatted()).subtract(const Duration(days: 1)):
            0,
      };
      return datasetsMap;
    } else {
      Map<dynamic, dynamic> data = _hive.get("DATASETS");

      Map<DateTime, int> datasetsMap = data.map<DateTime, int>((key, value) {
        DateTime dateTime = key as DateTime;
        int intValue = value as int;
        return MapEntry(dateTime, intValue);
      }).cast<DateTime, int>();
      return datasetsMap;
    }
  }

  Map<DateTime, int> convertLinkedMapToMap(
      LinkedHashMap<dynamic, dynamic> linkedMap) {
    Map<DateTime, int> convertedMap =
        linkedMap.map<DateTime, int>((key, value) {
      DateTime dateTime = key as DateTime;
      int intValue = value as int;
      return MapEntry(dateTime, intValue);
    });
    return convertedMap;
  }

  DateTime everOpened() {
    if (_hive.get("STARTDATE") == null) {
      _hive.put("STARTDATE", todaysDateFormatted());
      return createDateTimeObject(todaysDateFormatted());
    } else {
      return createDateTimeObject(_hive.get("STARTDATE"));
    }
  }

  void updateDatasets(Map<DateTime, int> map) {
    _hive.put("DATASETS", map);
  }

  void updateToday(List<DateTime> list) {
    _hive.put(todaysDateFormatted(), list);
  }

  List<DateTime> getDaysList() {
    if (_hive.get("DAYS") == null) {
      return [];
    } else {
      List<dynamic> today = _hive.get("DAYS");
      List<DateTime> result = [];
      for (int i = 0; i < today.length; i++) {
        result.add(createDateTimeObject(convertDateTimeToString(today[i])));
      }
      return result;
    }
  }

  List<DateTime> getToday() {
    if (_hive.get(todaysDateFormatted()) == null) {
      return [];
    } else {
      List today = _hive.get(todaysDateFormatted());
      List<DateTime> result = [];
      for (int i = 0; i < today.length; i++) {
        result.add(createDateTimeObject(convertDateTimeToString(
            today[i]))); // DateTime in einen String umwandeln
      }
      return result;
    }
  }

  void saveToday(List<DateTime> list) {
    _hive.put('DAYS', list);
    _hive.put(todaysDateFormatted(), list);
  }

  void putDaysinMap(List<DateTime> list) {
    for (int i = 0; i < list.length; i++) {
      String key = convertDateTimeToString(list[i]);
      datasetsMap[createDateTimeObject(key)] = 1;
    }
    updateDatasets(datasetsMap);
  }
}
