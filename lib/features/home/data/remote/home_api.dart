// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class HomeApi {
  Dio dio;
  HomeApi({required this.dio});
  dynamic callDeepSeekApi(String appliancesDataJson) async {
    Response res = await dio.post("/analysis/", data: appliancesDataJson);
    return res;
  }
}
