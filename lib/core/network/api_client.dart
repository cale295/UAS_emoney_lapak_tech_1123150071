import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiClient {
    late final Dio _dio;

    ApiClient({String? token}) {
        _dio = Dio(BaseOptions(
            baseUrl: AppConstants.baseUrl,
            connectTimeout: Duration(seconds: AppConstants.connectTimeout),
            receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                if (token != null) 'Authorization': 'Bearer $token',
            },
        ));

        debugPrint('[ApiClient] baseUrl = ${AppConstants.baseUrl}');
    }
}