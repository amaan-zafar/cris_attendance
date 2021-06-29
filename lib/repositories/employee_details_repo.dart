import 'package:cris_attendance/models/employee.dart';
import 'package:cris_attendance/network/api_base_helper.dart';

class EmployeeDetailsRepository {
  final ApiProvider apiProvider;

  EmployeeDetailsRepository(this.apiProvider);

  Future<Employee> fetchEmpDetails() async {
    final response = await apiProvider.get('myresource');
    print('EmpDetailsRepo res is $response');
    return Employee.fromJson(response['bean'][0]);
  }
}
