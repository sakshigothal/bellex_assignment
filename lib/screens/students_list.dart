import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/screens/add_student.dart';
import 'package:flutter_hive/student.dart';
import 'package:hive/hive.dart';

class StudentListScreen extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
  ];
  @override
  State<StatefulWidget> createState() {
    return StudentListScreenState();
  }
}

class StudentListScreenState extends State<StudentListScreen> {
  List<Student> listStudents = [];
  var getDate;
    int touchedIndex = -1;

  var getStName;
  var getEmail;
  var getMobile;
  Student? studentdata;

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerMobile = new TextEditingController();
  void getStudents() async {
    final box = await Hive.openBox<Student>('ExpenseData');
    setState(() {
      listStudents = box.values.toList();
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Flutter Hive Sample"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddOrUpdateStudent(false, -1, null)));
              })
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showBottomSheet();
            },
            backgroundColor: Colors.yellow.shade700,
            child: Icon(
              Icons.add,
              color: Colors.black,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: 200,
                  child:BarChart(
                    randomData()
                  )
                     
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: listStudents.length,
                      itemBuilder: (context, position) {
                        Student getStudent = listStudents[position];
                        // var name = getStudent.name;
                        var email = getStudent.amount;
                        var mobile = getStudent.date;
                        return Card(
                          elevation: 8,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Colors.deepPurple,
                                  ),
                                  child: Center(
                                    child: Text(
                                      mobile,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${getStudent.expense}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(email.substring(0, 11),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      final box =
                                          Hive.box<Student>('ExpenseData');
                                      box.deleteAt(position);
                                      setState(() =>
                                          {listStudents.removeAt(position)});
                                    })
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(25),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Expense:", style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                TextField(
                  controller: controllerName,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20),
                Text("Amount:", style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                TextField(
                  controller: controllerMobile,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                Text("Chooes Date:", style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                TextField(
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            getDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
  
                            setState(() {
                              controllerEmail.text = getDate.toString();
                            });
                          },
                          child: Icon(Icons.calendar_today)),
                    ),
                    controller: controllerEmail,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime),
                SizedBox(height: 30),
                MaterialButton(
                  color: Colors.deepOrange,
                  child: Text("Submit",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  onPressed: () async {
                    getStName = controllerName.text;
                    getEmail = controllerEmail.text;
                    getMobile = controllerMobile.text;
                    if (getStName.isNotEmpty &
                        getEmail.isNotEmpty &
                        getMobile.isNotEmpty) {
                      studentdata = new Student(
                          expense: getStName,
                          amount: getEmail,
                          date: getMobile);

                      // if (widget.isEdit) {
                      //   var box = await Hive.openBox<Student>('student');
                      //   box.putAt(widget.position, studentdata);
                      // }
                      // else
                      //  {
                      var box = await Hive.openBox<Student>('ExpenseData');
                      box.add(studentdata!);

                      // }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StudentListScreen()),
                          (r) => false);
                    }
                  },
                )
              ],
            ),
          );
        });
  }

 BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            // colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }


List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
          case 1:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}") , isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}"), isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}"), isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}"), isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}"), isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(int.parse("${studentdata?.amount}"),double.parse("${studentdata?.amount}"), isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });


    BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            margin: 16,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'S';
                case 1:
                  return 'S';
                case 2:
                  return 'M';
                case 3:
                  return 'T';
                case 4:
                  return 'W';
                case 5:
                  return 'T';
                case 6:
                  return 'F';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
          ),
          topTitles: SideTitles(
            showTitles: false,
          ),
          rightTitles: SideTitles(
            showTitles: false,
          )),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups:
       List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }
}
