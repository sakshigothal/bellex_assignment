import 'package:flutter/material.dart';
import 'package:flutter_hive/screens/students_list.dart';
import 'package:flutter_hive/student.dart';
import 'package:hive/hive.dart';

class AddOrUpdateStudent extends StatefulWidget {
  bool isEdit;
  int position = -1;
  Student? studentModel = null;

  AddOrUpdateStudent(this.isEdit, this.position, this.studentModel);

  @override
  State<StatefulWidget> createState() {
    return AddOrUpdateStudentState();
  }
}

class AddOrUpdateStudentState extends State<AddOrUpdateStudent> {
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerMobile = new TextEditingController();
  var getDate;
  var date = "";

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      controllerName.text = widget.studentModel!.expense;
      getDate = widget.studentModel!.amount;
      controllerMobile.text = widget.studentModel!.date;
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Add/Update Student Data")),
          body: SingleChildScrollView(
            child: Container(
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
                  SizedBox(height: 60),
                  Text("Amount:", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 20),
                  TextField(
                    controller: controllerMobile,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                      onTap: () async {
                        getDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        
                        setState(() {
                          // getDate = date.toString();
                          date=getDate;
                        });
                      },
                      child:
                          Text("Chooes Date:", style: TextStyle(fontSize: 18))),
                  SizedBox(width: 20),
                  Text(date),
                  // TextField(
                  //     decoration: InputDecoration(
                  //       suffixIcon: GestureDetector(
                  //           onTap: () async {
                  //             getDate = await showDatePicker(
                  //                 context: context,
                  //                 initialDate: DateTime.now(),
                  //                 firstDate: DateTime(2020),
                  //                 lastDate: DateTime(2030));

                  //             setState(() {
                  //               controllerEmail.text = getDate.toString();
                  //             });
                  //           },
                  //           child: Icon(Icons.calendar_today)),
                  //     ),
                  //     controller: controllerEmail,
                  //     textInputAction: TextInputAction.next,
                  //     keyboardType: TextInputType.datetime),

                  SizedBox(height: 100),
                  MaterialButton(
                    color: Colors.deepOrange,
                    child: Text("Submit",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () async {
                      var getStName = controllerName.text;
                      var getEmail = getDate;
                      var getMobile = controllerMobile.text;
                      if (getStName.isNotEmpty &
                          getEmail.isNotEmpty &
                          getMobile.isNotEmpty) {
                        Student studentdata = new Student(
                            expense: getStName,
                            amount: getEmail,
                            date: getMobile);

                        if (widget.isEdit) {
                          var box = await Hive.openBox<Student>('ExpenseData');
                          box.putAt(widget.position, studentdata);
                        } else {
                          var box = await Hive.openBox<Student>('ExpenseData');
                          box.add(studentdata);
                        }
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
            ),
          )),
    );
  }
}
