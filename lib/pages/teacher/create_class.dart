import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/pages/class/class_page.dart';
import 'package:face_net_authentication/pages/teacher/teacher_controller.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:flutter/material.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  TextEditingController _controllerClassName = TextEditingController();
  TextEditingController _controllerClassDesc = TextEditingController();

  TeacherController _controller = locator<TeacherController>();
  ScreenRouter _screenRouter = locator<ScreenRouter>();

  Future<Class?> _addClass() async {
    // Add class logic here
    print('Class Name: ${_controllerClassName.text}');
    print('Class Description: ${_controllerClassDesc.text}');
    try {
      Class? newClass = await _controller.createClass(
        _controllerClassName.text,
        _controllerClassDesc.text,
      );
      return newClass;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Create Class'),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    // setState(() {
                    // _controllerClassName.text = value;
                    // });
                  },
                  textDirection: TextDirection.ltr,
                  controller: _controllerClassName,
                  decoration: InputDecoration(labelText: 'Class Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    // setState(() {
                    //   _controllerClassDesc.text = value;
                    // });
                  },
                  textDirection: TextDirection.ltr,
                  controller: _controllerClassDesc,
                  decoration: InputDecoration(labelText: 'Class Description'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    _controller.loadData(context);
                    Class? newClass = await _addClass();
                    Navigator.pop(context);
                    if (newClass != null) {
                      _screenRouter.goToAndRemoveCurrent(
                        ClassPage.NAME,
                        arguments: newClass!,
                      );
                    } else {
                      print('Error creating class');
                      _controller.showErrorDialog(
                        context,
                        'Error creating class',
                      );
                    }
                  },
                  child: Text('Add Class'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
