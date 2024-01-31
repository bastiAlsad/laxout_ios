import 'dart:convert';
import 'dart:io';

class NewBackend {
  String address = "http://localhost:8080";

  HttpClient client = HttpClient();

  Future<String?> createNewUser(String partnerCode) async {
    final request = await client.getUrl(
      Uri.parse('$address/user/create?partnerCode=$partnerCode'),
    );

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await response.transform(const Utf8Decoder()).join();
      final jsonResponse = responseBody.toString();

      return jsonResponse;
    } else {
      return null;
    }
  }

  Future<bool> doesUserExist(String userId) async {
    final request = await client.getUrl(
      Uri.parse('$address/user'),
    );

    request.headers
        .add("Authorization", "Basic ${base64.encode("$userId:".codeUnits)}");

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  Future<Partner?> getPartnerFromUser(String userId) async {
    final client = HttpClient();
    final request = await client.getUrl(
      Uri.parse('$address/partner'),
    );

    request.headers
        .add("Authorization", "Basic ${base64.encode("$userId:".codeUnits)}");

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await response.transform(const Utf8Decoder()).join();
      final jsonResponse = json.decode(responseBody);

      return getPartnerFromJson(jsonResponse);
    } else {
      return null;
    }
  }
}

class Partner {
  int id;

  Partner(this.id);
}

Partner getPartnerFromJson(dynamic json) {
  Partner partner = Partner(json["id"]);

  return partner;
}
