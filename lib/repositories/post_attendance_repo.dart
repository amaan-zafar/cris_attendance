import 'package:cris_attendance/models/employee.dart';
import 'package:cris_attendance/network/api_base_helper.dart';

class PostAttendancerepo {
  final ApiProvider apiProvider;

  PostAttendancerepo(this.apiProvider);

  Future<Employee> postAttendance(
      {required empId,
      required int slot,
      required String imgBase64,
      required String date,
      required String time}) async {
    final response;
    try {
      response = await apiProvider.post('myresource/attendanceSlot$slot',
          {"id": empId, "date": date, "img3": imgBase64, "slot3": time});
    } catch (e) {
      throw Exception(e);
    }
    print('EmpDetailsRepo res is $response');
    return Employee.fromJson(response['bean'][0]);
  }

  // Future<Employee> postSlot2() async {
  //   final response;
  //   try {
  //     response = await apiProvider.post('myresource/attendanceSlot1', {
  //       "id": 15,
  //       "date": "2021-07-14Z",
  //       "img3": "adsfjahsdf",
  //       "slot3": "18:58:57"
  //     });
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  //   print('EmpDetailsRepo res is $response');
  //   return Employee.fromJson(response['bean'][0]);
  // }

  // Future<Employee> postSlot3() async {
  //   final response;
  //   try {
  //     response = await apiProvider.post('myresource/attendanceSlot1', {
  //       "id": 15,
  //       "date": "2021-07-14Z",
  //       "img3": "adsfjahsdf",
  //       "slot3": "18:58:57"
  //     });
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  //   print('EmpDetailsRepo res is $response');
  //   return Employee.fromJson(response['bean'][0]);
  // }
}
