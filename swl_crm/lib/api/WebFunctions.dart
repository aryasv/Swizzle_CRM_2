import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'AppSignatureAPI.dart';

const String baseURL =

// dev
"https://demoserver22.icwares.com/ayyoh/api/dev/";

// staging

// UAT

// live


const String appId = "3KiNjdFjTSe2i99xwMdoRKPdVUXHMSsL";
const String appSecret = "KNk6oLmFCvWeSd16JmoV8xcAHbq7JsZJ";
const String genericErrorMessage =
    "This one’s on us. Something went wrong on our side.";

class ApiResponse {
  final bool result;
  final Map<String, dynamic>? response;
  final String error;

  ApiResponse({required this.result, this.response, required this.error});
}

class DeviceInfo {
  final String platform;
  final String deviceId;
  final String model;
  final String buildVersion;
  final String deviceToken;

  DeviceInfo({
    this.platform = "",
    this.deviceId = "",
    this.model = "",
    this.buildVersion = "",
    this.deviceToken = "",
  });
}

class WebFunctions {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<String> accessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('accesstoken') ?? "";
    return stringValue;
  }

  Future<DeviceInfo> getId() async {
    if (kIsWeb) {
      return DeviceInfo(buildVersion: "1.0.0");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceToken = prefs.getString('devicetoken') ?? "";

    if (Platform.isIOS || Platform.isMacOS) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var deviceInfo = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return DeviceInfo(
        model: iosDeviceInfo.model,
        deviceId: iosDeviceInfo.identifierForVendor ?? "",
        platform: "i",
        buildVersion: packageInfo.version,
        deviceToken: deviceToken,
      );
    } else if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var deviceInfo = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      // log("androidDeviceInfo :  $androidDeviceInfo");
      return DeviceInfo(
        model: androidDeviceInfo.model,
        deviceId: androidDeviceInfo.id,
        platform: "a",
        buildVersion: packageInfo.version,
        deviceToken: deviceToken,
      );
    }
    return DeviceInfo(buildVersion: "1.0.0");
  }

  Future<String> getModel() async {
    if (kIsWeb) {
      return "";
    }
    if (Platform.isIOS) {
      var deviceInfo = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      var deviceInfo = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    }
    return "";
  }

  Future<ApiResponse> uploadWithProgress(
    String urlPath,
    File file,
    void Function(double) onProgress,
  ) async {
    final token = await accessToken();
    final info = await getId();

    final url = Uri.parse("$baseURL$urlPath");
    final appSignature = AppSignatureApi.getAppSignatureString(
      url.path,
      appId,
      appSecret,
      {},
    );

    final Map<String, String> headers = {
      "appid": appId,
      "appsignature": appSignature,
      "accesstoken": token,
    };

    final apiInfoDict = {
      "ip": "",
      "tokenstatus": "1",
      "accesstoken": token,
      "devicetoken": info.deviceToken,
      "devicekey": info.deviceId,
      "devicetype": info.model,
      "buildversion": info.buildVersion,
      "os": info.platform,
    };

    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields["apiInfo"] = jsonEncode(apiInfoDict);
    request.fields["parameters"] = jsonEncode({});

    final fileLength = await file.length();
    final stream = http.ByteStream(
      file.openRead()
        ..listen((chunk) {
          // update progress
          onProgress(chunk.length / fileLength);
        }),
    );

    final multipartFile = http.MultipartFile(
      "file",
      stream,
      fileLength,
      filename: file.path.split("/").last,
    );

    request.files.add(multipartFile);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    try {
      final res = jsonDecode(respStr);
      return ApiResponse(
        result: response.statusCode == 200,
        response: res,
        error: res["message"] ?? "",
      );
    } catch (_) {
      return ApiResponse(
        result: false,
        error: "Invalid server response",
        response: {"raw": respStr},
      );
    }
  }

  Future<ApiResponse> fileUpload(
    BuildContext context,
    String functionName,
    Map<String, dynamic> datadict,
    File file,
  ) async {
    final token = await accessToken();
    final info = await getId();

    if (await checkConnection()) {
      try {
        final url = Uri.parse("$baseURL$functionName");
        final appSignature = AppSignatureApi.getAppSignatureString(
          url.path,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "accesstoken": token,
        };

        final apiInfoDict = {
          "ip": "",
          "tokenstatus": "1",
          "accesstoken": token,
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };

        final request = http.MultipartRequest("POST", url);
        request.headers.addAll(header);

        // Required fields
        request.fields["apiInfo"] = jsonEncode(apiInfoDict);
        request.fields["parameters"] = jsonEncode(datadict);

        // Add folder_key only if present
        if (datadict.containsKey("folder_key")) {
          request.fields["folder_key"] = datadict["folder_key"].toString();
        }

        // Add file
        request.files.add(await http.MultipartFile.fromPath("file", file.path));

        final streamedResponse = await request.send();
        final respStr = await streamedResponse.stream.bytesToString();

        log("Upload raw response: $respStr");
        log("Upload status = ${streamedResponse.statusCode}");

        Map<String, dynamic>? res;
        String errorMsg = "";

        try {
          res = jsonDecode(respStr);
          debugPrint(
            "Upload parsed JSON response:\n${const JsonEncoder.withIndent("  ").convert(res)}",
          );
          errorMsg = res?["message"] ?? "";
        } catch (e) {
          errorMsg = "Non-JSON response received";
          res = {"raw": respStr};
        }

        return ApiResponse(
          result: streamedResponse.statusCode == 200,
          response: res,
          error: errorMsg,
        );
      } catch (e) {
        print("Upload error: $e");
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: genericErrorMessage);
    }
  }

  Future<ApiResponse> fileUpload2(
    BuildContext context,
    String functionName,
    Map<String, dynamic> datadict,
    File file, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final token = await accessToken();
    final info = await getId();

    if (await checkConnection()) {
      try {
        final url = Uri.parse("$baseURL$functionName");
        final appSignature = AppSignatureApi.getAppSignatureString(
          url.path,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "accesstoken": token,
        };

        final apiInfoDict = {
          "ip": "",
          "tokenstatus": "1",
          "accesstoken": token,
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };

        final total = await file.length();
        int sent = 0;

        // Stream with progress tracking
        final stream = http.ByteStream(
          file.openRead().map((chunk) {
            sent += chunk.length;
            if (onProgress != null) onProgress(sent, total);
            return chunk;
          }),
        );

        final multipartFile = http.MultipartFile(
          "file",
          stream,
          total,
          filename: file.path.split("/").last,
        );

        final request = http.MultipartRequest("POST", url);
        request.headers.addAll(header);
        request.fields["apiInfo"] = jsonEncode(apiInfoDict);
        request.fields["parameters"] = jsonEncode(datadict);
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final respStr = await streamedResponse.stream.bytesToString();

        log("Upload raw response: $respStr");
        log("Upload status = ${streamedResponse.statusCode}");

        Map<String, dynamic>? res;
        String errorMsg = "";

        try {
          res = jsonDecode(respStr);
          errorMsg = res?["message"] ?? "";
        } catch (_) {
          errorMsg = "Non-JSON response received";
          res = {"raw": respStr};
        }

        return ApiResponse(
          result: streamedResponse.statusCode == 200,
          response: res,
          error: errorMsg,
        );
      } catch (e) {
        print("Upload error: $e");
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: genericErrorMessage);
    }
  }

  Future<ApiResponse> imageUpload(
    BuildContext context,
    String functionName,
    Map<String, dynamic> datadict,
    File file,
  ) async {
    final token = await accessToken();
    final info = await getId();

    if (await checkConnection()) {
      try {
        final url = Uri.parse("$baseURL$functionName");

        final signUrl = "$baseURL$functionName";
        final appSignature = AppSignatureApi.getAppSignatureString(
          signUrl,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "accesstoken": token,
        };

        final ipAddress = "";

        final apiInfoDict = {
          "ip": ipAddress,
          "tokenstatus": "1",
          "accesstoken": token,
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };

        //  Create Multipart request
        final request = http.MultipartRequest("POST", url);
        request.headers.addAll(header);

        //  Send as string fields
        request.fields["apiInfo"] = jsonEncode(apiInfoDict);
        request.fields["parameters"] = jsonEncode(datadict);

        //  Add file
        request.files.add(
          await http.MultipartFile.fromPath(
            "file", //  must match backend
            file.path,
          ),
        );

        print("UploadAPI_in : fields = ${request.fields}");
        print("UploadAPI_in : headers = $header");
        print("UploadAPI_in : file = ${file.path}");

        final streamedResponse = await request.send();
        final respStr = await streamedResponse.stream.bytesToString();

        print("📡 Response status code: ${streamedResponse.statusCode}");
        print("📡 Raw backend response:\n$respStr");

        Map<String, dynamic>? res;

        try {
          res = jsonDecode(respStr);
        } catch (e) {
          print("❌ JSON Decode Error: $e");
          print("⚠️ Backend returned non-JSON response:");
          print(respStr);

          return ApiResponse(
            result: false,
            error:
                "Invalid server response — check backend logs or endpoint URL",
          );
        }

        return ApiResponse(
          result: streamedResponse.statusCode == 200,
          response: res,
          error: res != null && res.containsKey("message")
              ? res["message"].toString()
              : "Unknown server error — check backend response",
        );
      } catch (e) {
        print("Upload error: $e");
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: genericErrorMessage);
    }
  }

  Future<ApiResponse> callApiFunction(
    BuildContext context,
    String functionName,
    Map<String, dynamic> datadict, {
    UrlType type = UrlType.sucessd,
    File? file,
  }) async {
    final token = await accessToken();

    final info = await getId();
    if (await checkConnection()) {
      try {
        var url = Uri.parse("$baseURL$functionName");
        var startTime = DateTime.now(); // Record the start time
        var signUrl = "$baseURL$functionName";
        var appSignature = AppSignatureApi.getAppSignatureString(
          signUrl,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "accesstoken": token,
          "Content-Type": "application/json",
        };
        var ipAddress = "";
        final apiInfoDict = {
          "ip": ipAddress,
          "tokenstatus": "1",
          "accesstoken": token,
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };
        Map<String, Map<String, dynamic>> body = {
          "apiInfo": apiInfoDict,
          "parameters": datadict,
        };
        // ignore: avoid_print
        print(
          "\n BASEAPI_in : request = ${jsonEncode(body)}\n headerRequest = $header\n url = $url",
        );
        print(
            "🔑 Request Header Token: ${header['accesstoken']?.isNotEmpty == true ? '${header['accesstoken']!.substring(0, 10)}...' : 'EMPTY'}");
        print(
            "🔑 apiInfo.accesstoken: ${apiInfoDict['accesstoken']?.isNotEmpty == true ? '${apiInfoDict['accesstoken'].toString().substring(0, 10)}...' : 'EMPTY'}");

        var response = await http.post(
          url,
          headers: header,
          body: jsonEncode(body),
        );
        var endTime = DateTime.now(); // Record the end time
        // ignore: avoid_print
        print(
          "API_Response_Time: $url = ${endTime.difference(startTime).inMilliseconds} ms",
        );
        log("status = ${response.statusCode}");
        log(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        log("BASEAPI_s : ${jsonEncode(data)}");
        print("\n BASEAPI_s : ${jsonEncode(data)}");
        final int status = data["status"];
        final String msg = data["message"] ?? "";
        if (status == 1) {
          return ApiResponse(result: true, response: data, error: msg);
        } else if (status == 3) {
          // final t = data["data"];
          // final String header = t["headertext"] ?? "";
          // final String desc = t["headerdesc"] ?? "";
          // final String redirecturl = t["redirecturl"] ?? "";
          // final int isskipenabled = t["isskipenabled"] ?? 0;
          // Future.delayed(Duration(milliseconds: 1))((v) {
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => ForceUpdate(
          //               header: header,
          //               desc: desc,
          //               redirecturl: redirecturl,
          //               isskipenabled: isskipenabled.toString())),
          //       (route) => false);
          // });
          return ApiResponse(result: false, response: null, error: msg);
        } else if (status == -1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accesstoken', "");
          await prefs.setString('isLoggedIn', "0");

          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
          return ApiResponse(result: false, response: null, error: msg);
        } else {
          return ApiResponse(result: false, response: data, error: msg);
        }
      } catch (e) {
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: networkErrorMsg);
    }
  }

  var networkErrorMsg =
      "You are currently offline, please check your internet connection.";

  Future<bool> checkConnection() async {
    try {
      // final result = await InternetAddress.lookup('example.com');
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      if (error is SocketException) {
        if (error.osError?.message.contains('SSL') == true ||
            error.osError?.message.contains('TLS') == true) {
          // Specific ATS error related to SSL/TLS failure
          networkErrorMsg =
              "ATS Error: SSL/TLS handshake failed or insecure connection.";
          // print("ATS Error: SSL/TLS handshake failed or insecure connection.");
        } else {
          // General network error
          networkErrorMsg = "Network Error";
          // print("Network Error: ${error.message}");
        }
      } else {
        networkErrorMsg = "Unknown Error";
        // print("Unknown Error: $error");
      }
      return false;
    }
  }

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    if (await checkConnection()) {
      try {
        var url = Uri.parse("${baseURL}login");
        var startTime = DateTime.now();
        var signUrl = "${baseURL}login";

        final Map<String, dynamic> datadict = {
          "email": email,
          "password": password,
        };

        var appSignature = AppSignatureApi.getAppSignatureString(
          signUrl,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "Content-Type": "application/json",
        };

        final info = await getId();
        var ipAddress = "";

        final apiInfoDict = {
          "ip": ipAddress,
          "tokenstatus": "0",
          "accesstoken": "",
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };

        Map<String, Map<String, dynamic>> body = {
          "apiInfo": apiInfoDict,
          "parameters": datadict,
        };

        print(
          "\n LOGIN_API_in : request = ${jsonEncode(body)}\n headerRequest = $header\n url = $url",
        );

        var response = await http.post(
          url,
          headers: header,
          body: jsonEncode(body),
        );

        var endTime = DateTime.now();
        print(
          "API_Response_Time: $url = ${endTime.difference(startTime).inMilliseconds} ms",
        );

        log("status = ${response.statusCode}");
        log(response.body);

        final Map<String, dynamic> data = json.decode(response.body);
        log("LOGIN_API_s : ${jsonEncode(data)}");
        print("\n LOGIN_API_s : ${jsonEncode(data)}");

        final int status = data["status"];
        final String msg = data["message"] ?? "";

        if (status == 1) {
          // Store access token and account_id if login successful
          if (data["data"] != null && data["data"]["token"] != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final tokenToSave = data["data"]["token"].toString();
            await prefs.setString('accesstoken', tokenToSave);
            await prefs.setString('isLoggedIn', "1");

            // Store account_id from login response
            final accountId = data["data"]["account_id"]?.toString() ??
                data["data"]["accountId"]?.toString() ??
                '';
            if (accountId.isNotEmpty) {
              await prefs.setString('account_id', accountId);
              print(
                  "🔑 Login API - Account ID saved to SharedPreferences: $accountId");
            }

            print(
                "🔑 Login API - Token saved to SharedPreferences: ${tokenToSave.substring(0, 10)}...");
          }
          return ApiResponse(result: true, response: data, error: msg);
        } else {
          return ApiResponse(result: false, response: data, error: msg);
        }
      } catch (e) {
        log("Login error: $e");
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: networkErrorMsg);
    }
  }

  Future<ApiResponse> forgotPassword({
    required String email,
  }) async {
    if (await checkConnection()) {
      try {
        var url = Uri.parse("${baseURL}forgot-password");
        var startTime = DateTime.now();
        var signUrl = "${baseURL}forgot-password";

        final Map<String, dynamic> datadict = {
          "email": email,
        };

        var appSignature = AppSignatureApi.getAppSignatureString(
          signUrl,
          appId,
          appSecret,
          datadict,
        );

        final Map<String, String> header = {
          "appid": appId,
          "appsignature": appSignature,
          "Content-Type": "application/json",
        };

        final info = await getId();
        var ipAddress = "";

        final apiInfoDict = {
          "ip": ipAddress,
          "tokenstatus": "0",
          "accesstoken": "",
          "devicetoken": info.deviceToken,
          "devicekey": info.deviceId,
          "devicetype": info.model,
          "buildversion": info.buildVersion,
          "os": info.platform,
        };

        Map<String, Map<String, dynamic>> body = {
          "apiInfo": apiInfoDict,
          "parameters": datadict,
        };

        print(
          "\n FORGOT_PASSWORD_API_in : request = ${jsonEncode(body)}\n headerRequest = $header\n url = $url",
        );

        var response = await http.post(
          url,
          headers: header,
          body: jsonEncode(body),
        );

        var endTime = DateTime.now();
        print(
          "API_Response_Time: $url = ${endTime.difference(startTime).inMilliseconds} ms",
        );

        log("status = ${response.statusCode}");
        log(response.body);

        final Map<String, dynamic> data = json.decode(response.body);
        log("FORGOT_PASSWORD_API_s : ${jsonEncode(data)}");
        print("\n FORGOT_PASSWORD_API_s : ${jsonEncode(data)}");

        final int status = data["status"];
        final String msg = data["message"] ?? "";

        if (status == 1) {
          return ApiResponse(result: true, response: data, error: msg);
        } else {
          return ApiResponse(result: false, response: data, error: msg);
        }
      } catch (e) {
        log("Forgot password error: $e");
        return ApiResponse(result: false, error: genericErrorMessage);
      }
    } else {
      return ApiResponse(result: false, error: networkErrorMsg);
    }
  }

  Future<ApiResponse> products({
    required BuildContext context,
    required String status, // inactive / active
  }) async {
    final Map<String, dynamic> datadict = {
      "status": status,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Products API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Products API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Products API - Calling products endpoint with status: $status");

    return await callApiFunction(
      context,
      "products",
      datadict,
    );
  }

  Future<ApiResponse> createProduct({
    required BuildContext context,
    required String productName,
    required String productCode,
    required double productPrice,
    required String accountId,
  }) async {
    final Map<String, dynamic> datadict = {
      "product_name": productName,
      "product_code": productCode,
      "product_price": productPrice,
      "account_id": accountId,
      "status": "active",
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Create Product API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Create Product API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Create Product API - Creating product: $productName (Code: $productCode, Price: $productPrice, Account: $accountId)");

    return await callApiFunction(
      context,
      "product/create",
      datadict,
    );
  }

  Future<ApiResponse> updateProduct({
    required BuildContext context,
    required String productUuid,
    required String productName,
    required String productCode,
    required double productPrice,
    required String productId,
    required String accountId,
  }) async {
    final Map<String, dynamic> datadict = {
      "product_uuid": productUuid,
      "product_name": productName,
      "product_code": productCode,
      "product_price": productPrice,
      "product_id": productId,
      "account_id": accountId,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Update Product API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Update Product API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Update Product API - Updating product UUID: $productUuid (Name: $productName, Code: $productCode, Price: $productPrice, ID: $productId, Account: $accountId)");

    return await callApiFunction(
      context,
      "product/$productUuid/update",
      datadict,
    );
  }

  Future<ApiResponse> deleteProduct({
    required BuildContext context,
    required String productUuid,
    required String productId,
    required String accountId,
    String action = "deactivate",
  }) async {
    final Map<String, dynamic> datadict = {
      "account_id": int.tryParse(accountId) ?? 1,
      "product_id": int.tryParse(productId) ?? 0,
      "action": action,
    };

    final token = await accessToken();
    if (token.isEmpty) {
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    return await callApiFunction(
      context,
      "product/$productUuid/delete",
      datadict,
    );
  }


  Future<ApiResponse> contacts({
    required BuildContext context,
    required String status, // inactive / active
    required int page,
  }) async {
    final Map<String, dynamic> datadict = {
      "status": status,
      "page": page,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Contacts API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Contacts API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Contacts API - Calling contacts endpoint with status: $status, page: $page");

    return await callApiFunction(
      context,
      "contacts",
      datadict,
    );
  }

  Future<ApiResponse> contactDetails({
    required BuildContext context,
    required String clientUuid,
    required int clientId,
  }) async {
    final Map<String, dynamic> data = {
      "client_id": clientId,
    };

    return await callApiFunction(
      context,
      "contact/$clientUuid/view",
      data,
    );
  }


  Future<ApiResponse> createContact({
    required BuildContext context,
    required String clientName,
    String? clientEmail,
    String? clientPhone,
    int? companyId,
  }) async {
    final Map<String, dynamic> datadict = {
      "client_name": clientName,
    };

    // Add optional fields only if they have values
    if (clientEmail != null && clientEmail.isNotEmpty) {
      datadict["client_email"] = clientEmail;
    }
    if (clientPhone != null && clientPhone.isNotEmpty) {
      datadict["client_phone"] = clientPhone;
    }
    if (companyId != null) {
      datadict["company_id"] = companyId;
    }

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Create Contact API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Create Contact API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Create Contact API - Creating contact: $clientName (Email: $clientEmail, Phone: $clientPhone, Company ID: $companyId)");

    return await callApiFunction(
      context,
      "contact/create",
      datadict,
    );
  }

  Future<ApiResponse> getContactFormSchema({
    required BuildContext context,
  }) async {
    final Map<String, dynamic> datadict = {};

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Contact Form Schema API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Contact Form Schema API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Contact Form Schema API - Fetching contact form schema");

    return await callApiFunction(
      context,
      "contact/create",
      datadict,
    );
  }

  Future<ApiResponse> storeContact({
    required BuildContext context,
    required Map<String, dynamic> contactData,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Store Contact API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Store Contact API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Store Contact API - Saving contact with data: $contactData");

    return await callApiFunction(
      context,
      "contact/store",
      contactData,
    );
  }

  Future<ApiResponse> updateContact({
    required BuildContext context,
    required String clientUuid,
    required Map<String, dynamic> contactData,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Update Contact API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Update Contact API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Update Contact API - Updating contact $clientUuid with data: $contactData");

    return await callApiFunction(
      context,
      "contact/$clientUuid/update",
      contactData,
    );
  }

  Future<ApiResponse> deleteContact({
    required BuildContext context,
    required String clientUuid,
    required int clientId,
    String action = "deactivate",
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Delete Contact API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Delete Contact API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    final Map<String, dynamic> datadict = {
      "client_id": clientId,
      "action": action,
    };

    print(
        "✅ Delete Contact API - Deactivating contact $clientUuid (ID: $clientId) with action: $action");

    return await callApiFunction(
      context,
      "contact/$clientUuid/delete",
      datadict,
    );
  }

  Future<ApiResponse> editContact({
    required BuildContext context,
    required String clientUuid,
    required int clientId,
    required int accountId,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Edit Contact API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Edit Contact API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    final Map<String, dynamic> datadict = {
      "client_id": clientId,
      "account_id": accountId,
    };

    print(
        "✅ Edit Contact API - Fetching contact details for $clientUuid (ID: $clientId, Account: $accountId)");

    return await callApiFunction(
      context,
      "contact/$clientUuid/edit",
      datadict,
    );
  }

  Future<ApiResponse> companies({
    required BuildContext context,
    required String status, // inactive / active
    required int page,
  }) async {
    final Map<String, dynamic> datadict = {
      "status": status,
      "page": page,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Companies API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Companies API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Companies API - Calling companies endpoint with status: $status, page: $page");

    return await callApiFunction(
      context,
      "companies",
      datadict,
    );
  }

  Future<ApiResponse> companyDetails({
    required BuildContext context,
    required String companyUuid,
    required int companyId,
  }) async {
    final Map<String, dynamic> data = {
      "company_id": companyId,
    };

    return await callApiFunction(
      context,
      "company/$companyUuid/view",
      data,
    );
  }


  Future<ApiResponse> getCompanyFormSchema({
    required BuildContext context,
  }) async {
    final Map<String, dynamic> datadict = {};

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Company Form Schema API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Company Form Schema API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Company Form Schema API - Fetching company form schema");

    return await callApiFunction(
      context,
      "company/create",
      datadict,
    );
  }

  Future<ApiResponse> storeCompany({
    required BuildContext context,
    required Map<String, dynamic> companyData,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Store Company API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Store Company API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Store Company API - Saving company with data: $companyData");

    return await callApiFunction(
      context,
      "company/store",
      companyData,
    );
  }

  Future<ApiResponse> updateCompany({
    required BuildContext context,
    required String companyUuid,
    required Map<String, dynamic> companyData,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Update Company API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Update Company API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Update Company API - Updating company $companyUuid with data: $companyData");

    return await callApiFunction(
      context,
      "company/$companyUuid/update",
      companyData,
    );
  }

  Future<ApiResponse> editCompany({
    required BuildContext context,
    required String companyUuid,
    required int companyId,
    required int accountId,
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Edit Company API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Edit Company API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    final Map<String, dynamic> datadict = {
      "company_id": companyId,
      "account_id": accountId,
    };

    print(
        "✅ Edit Company API - Fetching company details for $companyUuid (ID: $companyId, Account: $accountId)");

    return await callApiFunction(
      context,
      "company/$companyUuid/edit",
      datadict,
    );
  }

  Future<ApiResponse> deleteCompany({
    required BuildContext context,
    required String companyUuid,
    required int companyId,
    String action = "deactivate",
  }) async {
    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Delete Company API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Delete Company API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    final Map<String, dynamic> datadict = {
      "company_id": companyId,
      "action": action,
    };

    print(
        "✅ Delete Company API - Deactivating company $companyUuid (ID: $companyId) with action: $action");

    return await callApiFunction(
      context,
      "company/$companyUuid/delete",
      datadict,
    );
  }

  Future<ApiResponse> tasks({
    required BuildContext context,
    required String status, // active / inactive
    String scope = "all",
    List<dynamic> assignedUsers = const [],
    required int page,
  }) async {
    final Map<String, dynamic> datadict = {
      "status": status,
      "scope": scope,
      "assigned_users": assignedUsers,
      "page": page,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Tasks API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Tasks API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print(
        "✅ Tasks API - Calling tasks endpoint with status: $status, scope: $scope, page: $page");

    return await callApiFunction(
      context,
      "tasks",
      datadict,
    );
  }

  Future<ApiResponse> taskDetails({
    required BuildContext context,
    required String taskUuid,
    required int taskId,
  }) async {
    final Map<String, dynamic> data = {
      "task_id": taskId,
    };

    return await callApiFunction(
      context,
      "task/$taskUuid/view",
      data,
    );
  }


  Future<ApiResponse> storeTask({
    required BuildContext context,
    required String name,
    int? assignedUserId,
    String? dueDate,
    int recurring = 0,
    String? repeatsEvery,
    String? repeatUntil,
    int hasReminder = 0,
    int? reminderOnId,
    String? reminderAt,
    int? relatedToModuleId,
    int? relatedToRecordId,
    String? description,
    int isHighPriority = 0,
  }) async {
    final Map<String, dynamic> datadict = {
      "name": name,
      "assigned_user_id": assignedUserId ?? 1, // Defaulting to 1 if null
      "due_date": dueDate,
      "recurring": recurring,
      "repeats_every": repeatsEvery,
      "repeat_until": repeatUntil,
      "has_reminder": hasReminder,
      "reminder_on_id": reminderOnId,
      "reminder_at": reminderAt,
      "related_to_module_id": relatedToModuleId,
      "related_to_record_id": relatedToRecordId,
      "description": description,
      "is_high_priority": isHighPriority,
    };

    // Remove null values to keep request clean (optional, but good practice)
    datadict.removeWhere((key, value) => value == null);

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Store Task API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Store Task API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Store Task API - Creating task: $name");

    return await callApiFunction(
      context,
      "task/store",
      datadict,
    );
  }

  Future<ApiResponse> editTask({
    required BuildContext context,
    required String taskUuid,
    required int taskId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('account_id') ?? "1";

    final Map<String, dynamic> datadict = {
      "task_id": taskId,
      "account_id": accountId,
    };

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Edit Task API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Edit Task API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Edit Task API - Fetching details for task UUID: $taskUuid (ID: $taskId)");

    return await callApiFunction(
      context,
      "task/$taskUuid/edit",
      datadict,
    );
  }

  Future<ApiResponse> updateTask({
    required BuildContext context,
    required String taskUuid,
    required int taskId,
    required String name,
    int? assignedUserId,
    String? dueDate,
    int recurring = 0,
    String? repeatsEvery,
    String? repeatUntil,
    int hasReminder = 0,
    int? reminderOnId,
    String? reminderAt,
    int? relatedToModuleId,
    int? relatedToRecordId,
    String? description,
    int isHighPriority = 0,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('account_id') ?? "1";

    final Map<String, dynamic> datadict = {
      "task_id": taskId,
      "account_id": accountId,
      "name": name,
      "assigned_user_id": assignedUserId ?? 1,
      "due_date": dueDate,
      "recurring": recurring,
      "repeats_every": repeatsEvery,
      "repeat_until": repeatUntil,
      "has_reminder": hasReminder,
      "reminder_on_id": reminderOnId,
      "reminder_at": reminderAt,
      "related_to_module_id": relatedToModuleId,
      "related_to_record_id": relatedToRecordId,
      "description": description,
      "is_high_priority": isHighPriority,
    };

    datadict.removeWhere((key, value) => value == null);

    final token = await accessToken();
    if (token.isEmpty) {
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Update Task API - Updating task: $taskUuid (ID: $taskId, Account: $accountId)");

    return await callApiFunction(
      context,
      "task/$taskUuid/update",
      datadict,
    );
  }

  Future<ApiResponse> deleteTask({
    required BuildContext context,
    required String taskUuid,
    required int taskId,
    String action = "deactivate",
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('account_id') ?? "1";

    final Map<String, dynamic> datadict = {
      "task_id": taskId,
      "account_id": accountId,
      "action": action,
    };

    final token = await accessToken();
    if (token.isEmpty) {
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Delete Task API - Action: $action on task: $taskUuid (ID: $taskId)");

    return await callApiFunction(
      context,
      "task/$taskUuid/delete",
      datadict,
    );
  }

  Future<ApiResponse> dashboard({
    required BuildContext context,
  }) async {
    final Map<String, dynamic> datadict = {};

    // Debug: Verify token is available
    final token = await accessToken();
    print(
        "🔑 Dashboard API - Token from SharedPreferences: ${token.isNotEmpty ? '${token.substring(0, 10)}...' : 'EMPTY'}");

    if (token.isEmpty) {
      print(
          "❌ Dashboard API - No access token found! User may not be logged in.");
      return ApiResponse(
        result: false,
        error: "Authentication required. Please log in again.",
      );
    }

    print("✅ Dashboard API - Calling dashboard endpoint");

    return await callApiFunction(
      context,
      "dashboard",
      datadict,
    );
  }
}

enum UrlType { swizzle, sucessd }
