// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'hive_communication.dart';

class LaxoutBackend {
  String serverAddress = "http://192.168.178.41:8000";
  final HiveDatabase _hiveDatabase = HiveDatabase();

  Future<bool> authenticateUser(String uid) async {
    const String apiUrl =
        'https://dashboardlaxout.eu.pythonanywhere.com/autorise_user';

    final Map<String, String> data = {"user_uid": uid};

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? token = responseData['token'];
      if (token != null) {
        _hiveDatabase.putTokenInHive(token);
        _hiveDatabase.putUserUidinHive(uid);
        return true;
      } else {
        return false;
      }
      // Verwenden Sie das Token für zukünftige Anfragen
    } else {
      return false;
    }
  }

  Future<String?> getLaxoutCoinsAmount() async {
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/coinsget_laxout";
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token',
        'User-Uid': '${Uri.encodeFull(userUid)}',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      String laxocoins = decodedData['laxcoins_amount'];
      return laxocoins;
    } else {
      return null;
    }
  }

  String decodeSpecialCharacters(String text) {
    List<int> bytes = utf8.encode(text);
    String decodedText = latin1.decode(bytes);
    return decodedText;
  }

  Future<List<LaxoutExercise>> returnLaxoutExercises() async {
    String token = _hiveDatabase.getToken();
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/uebungen_laxout";  
    String userUid = _hiveDatabase.getUserUid();
    List<LaxoutExercise> finalList = [];

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> exercisesJson = jsonDecode(response.body);
      
        for (int i = 0; i < exercisesJson.length; i++) {
          finalList.add(LaxoutExercise(
              execution: exercisesJson[i]['execution'],
              name: exercisesJson[i]['name'],
              dauer: exercisesJson[i]['dauer'],
              videoPath: exercisesJson[i]['onlineVideoPath'],
              looping: exercisesJson[i]['looping'],
              added: exercisesJson[i]['added'],
              instruction: exercisesJson[i]['instruction'],
              timer: exercisesJson[i]['timer'],
              required: exercisesJson[i]['required'],
              imagePath: exercisesJson[i]['imagePath'],
              id: exercisesJson[i]['id']));
           
             
              
        }
      
        return finalList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<LaxoutExercise>> returnLaxoutExercisesTest() async {
    String token = _hiveDatabase.getToken();
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/uebungen_laxout";  
    String userUid = _hiveDatabase.getUserUid();
    List<LaxoutExercise> finalList = [];

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> exercisesJson = jsonDecode(response.body);
        
        for (int i = 0; i < exercisesJson.length; i++) {
          finalList.add(LaxoutExercise(
              execution: exercisesJson[i]['execution'],
              name: exercisesJson[i]['name'],
              dauer: exercisesJson[i]['dauer'],
              videoPath: exercisesJson[i]['onlineVideoPath'],
              looping: exercisesJson[i]['looping'],
              added: exercisesJson[i]['added'],
              instruction: exercisesJson[i]['instruction'],
              timer: exercisesJson[i]['timer'],
              required: exercisesJson[i]['required'],
              imagePath: exercisesJson[i]['imagePath'],
              id: exercisesJson[i]['appId']));
              
             
              
        }
        
        return finalList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  Future<bool> postLeistungsIndex(int amount) async {
    final Map<String, int> data = {"index": amount};
    String userUid = _hiveDatabase.getUserUid();
    String token = _hiveDatabase.getToken();
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/indexpost_laxout";

    final http.Response response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postPainLevel(int painLevel) async {
    String apiUrl = "https://dashboardlaxout.eu.pythonanywhere.com/painsadd";
    String userUid = _hiveDatabase.getUserUid();
    String token = _hiveDatabase.getToken();

    Map<String, dynamic> data = {'pain_level': painLevel};

    final http.Response response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}'
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Coupon>> returnCoupons() async {
    String apiUrl = "https://dashboardlaxout.eu.pythonanywhere.com/couponsget";
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    final http.Response response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'token $token',
      'User-Uid': '${Uri.encodeFull(userUid)}'
    });
    List<Coupon> toReturn = [];
    if (response.statusCode == 200) {
      List<dynamic> decodedBody = jsonDecode(response.body);
      for (int i = 0; i < decodedBody.length; i++) {
        Coupon coupon = Coupon(
            id: decodedBody[i]['id'],
            couponName: decodedBody[i]['coupon_name'],
            couponText: decodedBody[i]['coupon_text'],
            couponImageUrl: decodedBody[i]['coupon_image_url'],
            couponPrice: decodedBody[i]['coupon_price'],
            couponOffer: decodedBody[i]['coupon_offer'],
            rabatCode: decodedBody[i]['rabbat_code']);
        toReturn.add(coupon);
      }
      return toReturn;
    }
    if (response.statusCode == 204) {
      toReturn.add(Coupon(
          couponName: "Test",
          couponText: "Test",
          couponImageUrl: "TEst",
          couponPrice: 40,
          couponOffer: "Cool",
          rabatCode: "askfas98f97",
          id: 0));
      return toReturn;
    } else {
      return [];
    }
  }

  Future<bool> buyCoupon(int couponId) async {
    String apiUrl = "https://dashboardlaxout.eu.pythonanywhere.com/couponbuy";
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    Map<String, dynamic> data = {'coupon_id': couponId};
    final http.Response response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}'
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 406) {
      return false;
    }
    return false;
  }

  Future<bool> deleteCoupon(int couponId) async {
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/coupondeleteuser";
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    Map<String, dynamic> data = {'coupon_id': couponId};
    final http.Response response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
          'User-Uid': '${Uri.encodeFull(userUid)}'
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 406) {
      return false;
    }
    return false;
  }

  Future<List<Coupon>> returnCouponsForSpecificUSer() async {
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/coupongetuser";
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    final http.Response response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'token $token',
      'User-Uid': '${Uri.encodeFull(userUid)}'
    });
    List<Coupon> toReturn = [];
    if (response.statusCode == 200) {
      List<dynamic> decodedBody = jsonDecode(response.body);
      for (int i = 0; i < decodedBody.length; i++) {
        Coupon coupon = Coupon(
            id: decodedBody[i]['id'],
            couponName: decodedBody[i]['coupon_name'],
            couponText: decodedBody[i]['coupon_text'],
            couponImageUrl: decodedBody[i]['coupon_image_url'],
            couponPrice: decodedBody[i]['coupon_price'],
            couponOffer: decodedBody[i]['coupon_offer'],
            rabatCode: decodedBody[i]['rabbat_code']);
        toReturn.add(coupon);
      }
      return toReturn;
    } else {
      return [];
    }
  }

  Future<bool> finishExercise(int exerciseId) async {
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/exercisefinish";
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();

    Map<String, dynamic> data = {
      "exercise_id": exerciseId,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token',
        'User-Uid': '${Uri.encodeFull(userUid)}'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return true;
    }
    if (response.statusCode == 403) {
      return false;
    }
    return false;
  }

  Future<bool> skipExercise(int exerciseId) async {
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/exerciseskip"; //https://dashboardlaxout.eu.pythonanywhere.com/
    String userUid = _hiveDatabase.getUserUid();
    String token = _hiveDatabase.getToken();
    Map<String, dynamic> data = {"exercise_id": exerciseId};

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token',
        'User-Uid': '${Uri.encodeFull(userUid)}'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 403) {
      return false;
    }
    return false;
  }

  Future<bool> finishWorkout(int workoutId) async {
    String apiUrl =
        "https://dashboardlaxout.eu.pythonanywhere.com/workoutfinish";
    String userUid = _hiveDatabase.getUserUid();
    String token = _hiveDatabase.getToken();
    Map<String, dynamic> data = {"workout_id": workoutId};

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token',
        'User-Uid': '${Uri.encodeFull(userUid)}'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 403) {
      return false;
    }
    return false;
  }
Future<String?> returnInstruction() async {
  String apiUrl = 'https://dashboardlaxout.eu.pythonanywhere.com/instructionget/';
  String token = _hiveDatabase.getToken();
  String userUid = _hiveDatabase.getUserUid();

  final http.Response response = await http.get(Uri.parse(apiUrl), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'token $token',
    'User-Uid': '${Uri.encodeFull(userUid)}'
  });

  if (response.statusCode == 200) {
    // Dekodieren Sie die Antwort mit UTF-8
   // Verwenden Sie utf8.decode für die korrekte Kodierung
    String decodedResponse = utf8.decode(response.bodyBytes);
    Map<String, dynamic> decodedData = jsonDecode(decodedResponse);
    String instruction = decodedData['instruction'];
    return instruction;
  }

  return null;
}

   Future<int?> returnProgressWeek() async {
    String apiUrl = 'https://dashboardlaxout.eu.pythonanywhere.com/progressweekget/';
    String token = _hiveDatabase.getToken();
    String userUid = _hiveDatabase.getUserUid();
    final http.Response response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'token $token',
      'User-Uid': '${Uri.encodeFull(userUid)}'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      int week = decodedData['week'];
      return week;
    }
    print("ERROR");
    return null;
  }
}

class LaxoutUser {
  String userUid;
  String laxoutUserName;
  int laxoutCredits;
  String note;
  DateTime creationDate;
  List<LaxoutExercise> exercises;
  String createdBy;

  LaxoutUser({
    required this.userUid,
    required this.laxoutUserName,
    required this.laxoutCredits,
    required this.note,
    required this.creationDate,
    required this.exercises,
    required this.createdBy,
  });
}

class LaxoutExercise {
  int id;
  String execution;
  String name;
  int dauer;
  String videoPath;
  bool looping;
  bool added;
  String instruction;
  bool timer;
  String required;
  String imagePath;

  LaxoutExercise({
    required this.id,
    required this.execution,
    required this.name,
    required this.dauer,
    required this.videoPath,
    required this.looping,
    required this.added,
    required this.instruction,
    required this.timer,
    required this.required,
    required this.imagePath,
  });
}

class Coupon {
  int id;
  String couponName;
  String couponText;
  String couponImageUrl;
  int couponPrice;
  String couponOffer;
  String rabatCode;
  Coupon({
    required this.id,
    required this.couponName,
    required this.couponText,
    required this.couponImageUrl,
    required this.couponPrice,
    required this.couponOffer,
    required this.rabatCode,
  });
}
