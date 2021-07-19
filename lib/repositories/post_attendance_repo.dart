import 'package:cris_attendance/models/post_attendance.dart';
import 'package:cris_attendance/network/api_base_helper.dart';
import 'package:http/http.dart';

class PostAttendancerepo {
  final ApiProvider apiProvider;

  PostAttendancerepo(this.apiProvider);

  Future<Response> postAttendance(
      PostAttendanceModel postAttendanceModel) async {
    final response;
    try {
      response = await apiProvider.post(
          'myresource/attendanceSlot${postAttendanceModel.slot}',
          postAttendanceModel.toJson());
    } catch (e) {
      throw Exception(e);
    }
    print('PostAttendanceRepo res is $response');
    return response;
  }
}
