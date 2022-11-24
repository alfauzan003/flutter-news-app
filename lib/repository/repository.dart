import 'dart:async';
import 'package:dio/dio.dart';
import '../model/article_response.dart';

class NewsRepository {
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "8a86af2e69f744bb944e6e15a31e92f7";
  // final String apiKey = "79d8d218f0f74cfa947f481fa20d9b1f";
  // final String apiKey = "5907e1d547e146f3a4fafc84a9d8faed";
  final Dio _dio = Dio();
  var getTopHeadlinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = "$mainUrl/everything";

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {"apiKey": apiKey, "country": "us"};
    try {
      Response response =
          await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> search(String value) async {
    var params = {
      "apiKey": apiKey,
      "q": value,
      "sortBy": "relevancy",
      "pageSize": "20",
      "searchIn": "title"
    };
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {
      "apiKey": apiKey,
      "country": "id",
      "pageSize": "100",
      "category": "general"
    };
    try {
      Response response =
          await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
}
