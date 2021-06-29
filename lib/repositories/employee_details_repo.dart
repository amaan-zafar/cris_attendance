class Employee {
  String dateOfBirth;
  String email;
  int empID;
  String firstName;
  String gender;
  String lastName;

  Employee(
      {this.dateOfBirth,
      this.email,
      this.empID,
      this.firstName,
      this.gender,
      this.lastName});

  Employee.fromJson(Map<String, dynamic> json) {
    dateOfBirth = json['dateOfBirth'];
    email = json['email'];
    empID = json['empID'];
    firstName = json['firstName'];
    gender = json['gender'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateOfBirth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['lastName'] = this.lastName;
    return data;
  }
}
