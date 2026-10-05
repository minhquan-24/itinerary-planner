import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_model.dart';

class TripService {
  // Android Emulator connects to localhost via 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:3000/api/trips';

  // Lấy chuyến đi đầu tiên / mặc định
  Future<Trip> fetchTripDetails([String tripId = 'trip-01']) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$tripId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        return Trip.fromJson(data);
      } else {
        throw Exception(
            'Lỗi kết nối server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối tới NestJS Backend ($baseUrl): $e');
    }
  }

  // Đổi trạng thái checkbox của hoạt động (Toggle isCompleted)
  Future<Trip> toggleActivityStatus(String tripId, String activityId) async {
    try {
      final response = await http
          .patch(Uri.parse('$baseUrl/$tripId/activities/$activityId/toggle'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        return Trip.fromJson(data);
      } else {
        throw Exception('Không thể cập nhật trạng thái hoạt động: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gửi yêu cầu cập nhật: $e');
    }
  }

  // Thêm hoạt động mới vào một ngày
  Future<Trip> addActivity({
    required String tripId,
    required int dayIndex,
    required String title,
    required String time,
    required String location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$tripId/days/$dayIndex/activities'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'time': time,
          'location': location,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        return Trip.fromJson(data);
      } else {
        throw Exception('Không thể thêm địa điểm/hoạt động mới');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi thêm hoạt động: $e');
    }
  }
}
