class Employee {
  String firstName;
  String lastName;
  int empID;
  String email;
  String dateOfBirth;
  String gender;

  Employee({
    required this.firstName,
    required this.lastName,
    required this.empID,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        dateOfBirth: json['dateOfBirth'],
        email: json['email'],
        empID: json['empID'],
        firstName: json['firstName'],
        gender: json['gender'],
        lastName: json['lastName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['empID'] = this.empID;
    data['email'] = this.email;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    return data;
  }
}
