import 'dart:convert';

import 'package:crypto/crypto.dart';

class AppSignatureApi {
  static String getAppSignatureString(
    String url,
    String appId,
    String appSecret,
    Map<String, dynamic> params,
  ) {
    String updatedurl = "$url?appId=$appId";
    String paramsStr = getJsonObjectSort(params);
    String paramsUrl = paramsAttacher(paramsStr);
    updatedurl += paramsUrl;
    String genString = getHmacHash(updatedurl, appSecret);
    return genString;
  }

  static String getJsonObjectSort(Map<String, dynamic> params) {
    Map<String, dynamic> myDict = {};
    params.forEach((key, value) {
      if (value is Map || value is List) {
        myDict[key] = jsonEncode(value);
      } else {
        myDict[key] = value.toString();
      }
    });

    Map<String, dynamic> sorted = Map.fromEntries(
      myDict.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    Map<String, dynamic> sortedJsonObject = {};
    sorted.forEach((key, value) {
      if (value.toString().contains('{')) {
        sortedJsonObject[key] = jsonDecode(value);
      } else {
        sortedJsonObject[key] = value;
      }
    });
    return jsonEncode(sortedJsonObject);
  }

  static String paramsAttacher(String params) {
    String attachedParams = "";
    jsonDecode(params).forEach((key, value) {
      attachedParams += "&$key=${value.toString()}";
    });
    return attachedParams;
  }

  static String getHmacHash(String dataToHash, String secretKey) {
    var hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
    var hash = hmacSha256.convert(utf8.encode(dataToHash));
    return hash.toString();
  }
}
