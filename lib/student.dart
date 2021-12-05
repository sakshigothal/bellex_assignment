

import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1,adapterName: "StudentAdapter")
class Student{
  @HiveField(0)
  String expense;

  @HiveField(1)
  String amount;

  @HiveField(2)
  String date;

  Student({required this.expense,required this.amount,required this.date});
}