import 'package:dio/dio.dart';

import '../model/data_model.dart';

class DataRepository {
  final Dio _dio = Dio();

  Future<List<DataModel>> fetchData() async {
    const endpoint = "https://api.thecatapi.com/v1/images/search?limit=80&mime_types=&order=Random&size=small&page=3&sub_id=demo-ce06ee";
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => DataModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
