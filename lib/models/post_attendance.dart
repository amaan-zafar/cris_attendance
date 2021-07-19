class PostAttendanceModel {
  int empId;
  int slot;
  String date;
  String base64;
  String time;

  PostAttendanceModel(
      {required this.empId,
      required this.slot,
      required this.date,
      required this.base64,
      required this.time});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.empId;
    data['date'] = this.date;
    data['img$slot'] = this.base64;
    data['slot$slot'] = this.time;
    return data;
  }
}
