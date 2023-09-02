import 'package:face_net_authentication/base/base_statefull.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/models/member.dart';
import 'package:face_net_authentication/models/report.dart';
import 'package:face_net_authentication/pages/class/class_controller.dart';
import 'package:face_net_authentication/pages/face/face_view.dart';
import 'package:face_net_authentication/state/user.dart';
import 'package:face_net_authentication/widgets/member_card.dart';
import 'package:face_net_authentication/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ClassPage extends BaseStatefulWidget {
  ClassPage({
    super.key,
    this.data,
  });

  Class? data;

  static const String NAME = "/class";

  set setData(Class? data) {
    this.data = data;
  }

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  ClassController _controller = locator<ClassController>();

  List<Widget>? _list;

  Future<void> _loadData() async {
    _list = await getData();
    await load();
    setState(() {
      _list = _list;
    });
  }

  bool showRp = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> load() async {
    Class? newData = await _controller.getClass(widget.data!.id);
    if (newData == null) {
      return;
    }
    setState(() {
      widget.setData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String status = '';
    if (widget.data!.attendances!.length > 0) {
      if (widget.data!.attendances!.last.status == 'open') {
        status = ' - Checking';
      } else {
        status = '';
      }
    } else {
      status = '';
    }

    return MaterialApp(
      title: 'Class Page',
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
          title: Text(widget.data!.name + status),
        ),
        body: buildBody(),
        floatingActionButton: MyFloatingActionButtonMenu(
          refresh: () async {
            await _loadData();
          },
          addStudent: (context) async {
            List<String> data = await _showInputDialog(context);
            if (data[0] == '' || data[1] == '') {
              return;
            }
            await _controller.addStudent(data[1], data[0], widget.data!.id);
          },
          createAttendance: status == ''
              ? () async {
                  await _controller.classHttp.createAttendance(widget.data!.id);
                  await load();
                }
              : null,
          closeAttendance: () async {
            await _controller.classHttp.closeAttendance(
                widget.data!.id, widget.data!.attendances!.last.id);
            await load();
          },
          getReports: () async {
            setState(() {
              showRp = !showRp;
            });
          },
          checkin: () async {
            final result = await checkin();
            if (result) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Success'),
                        content: Text('Checkin success'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      ));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Checkin failed'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      ));
            }
          },
          showRp: showRp,
        ),
      ),
    );
  }

  Future<Widget> buildReport() async {
    List<Widget>? _list2;
    List<Report>? reports = await _controller.getReports(widget.data!.id);

    _list2 = reports
        .map((e) {
          return ReportCard(
            rp: e,
          );
        })
        .toList()
        .obs;
    return SafeArea(
      child: ListView(
        children: _list2,
      ),
    );
  }

  Future<Widget> buildMember() async {
    List<Widget>? _list2;
    List<Member>? members = await _controller.getStudents(widget.data!.id);

    _list2 = members
        .map((e) {
          return MemberCard(
            member: e,
            showDelete:
                (_controller.userState.currentMember!.role == 'Teacher'),
          );
        })
        .toList()
        .obs;
    return SafeArea(
      child: _list2 == null || _list2!.length == 0
          ? Container()
          : ListView(
              children: _list2!,
            ),
    );
  }

  Widget buildBody() {
    if (this.showRp) {
      return FutureBuilder(
        future: buildReport(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data as Widget;
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
    return FutureBuilder(
      future: buildMember(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<String>> _showInputDialog(BuildContext context) async {
    String name = '';
    String email = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Student Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(labelText: 'Email*'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Do something with userInput1 and userInput2
                if (email == '') {
                  return;
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );

    return [name, email];
  }

  Future<List<Widget>> getData() async {
    List<Member>? members = await _controller.getStudents(widget.data!.id);
    if (members == null) {
      return RxList<Widget>();
    }

    return members
        .map((e) {
          return MemberCard(
            member: e,
            showDelete: false,
          );
        })
        .toList()
        .obs;
  }

  Future<bool> showConfirmDialog(BuildContext context) async {
    bool isDelete = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to delete this student?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                isDelete = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return isDelete;
  }

  Future<bool> checkin() async {
    final List modelData = await _controller.screenRouter.goToSubview(
      FaceDetectorView(),
    );
    if (modelData.length == 0) {
      return false;
    }
    final result = await _controller.memberHttp.checkin(
      widget.data!.id,
      _controller.userState.currentMember!.email,
      modelData,
    );
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}

class MyFloatingActionButtonMenu extends StatefulWidget {
  MyFloatingActionButtonMenu({
    super.key,
    this.addStudent,
    this.createAttendance,
    this.closeAttendance,
    this.getReports,
    this.refresh,
    this.showRp = false,
    this.checkin,
  });

  final Future<void> Function(BuildContext context)? addStudent;
  final Future<void> Function()? createAttendance;
  final Future<void> Function()? closeAttendance;
  final Future<void> Function()? getReports;
  final Future<void> Function()? refresh;
  final Future<void> Function()? checkin;
  bool showRp = false;

  @override
  State<MyFloatingActionButtonMenu> createState() =>
      _MyFloatingActionButtonMenuState();
}

class _MyFloatingActionButtonMenuState
    extends State<MyFloatingActionButtonMenu> {
  UserState _userState = locator<UserState>();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showMenu(context);
      },
      child: Icon(Icons.menu),
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry>[
        if (_userState.currentMember!.role == 'Teacher')
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Student'),
              onTap: () async {
                // Handle the Settings option
                Navigator.pop(context);
                await widget.addStudent!(context);
                await widget.refresh!();
              },
            ),
          ),
        if (widget.createAttendance != null)
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Required Attendance'),
              onTap: () async {
                // Handle the Help option
                Navigator.pop(context);
                await widget.createAttendance!();
              },
            ),
          ),
        if (widget.createAttendance == null)
          if (_userState.currentMember!.role == 'Teacher')
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.done_all_outlined),
                title: Text('Close Attendance'),
                onTap: () async {
                  // Handle the Help option
                  Navigator.pop(context);
                  await widget.closeAttendance!();
                },
              ),
            ),
        if (!widget.showRp)
          if (_userState.currentMember!.role == 'Teacher')
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.list),
                title: Text('Reports'),
                onTap: () async {
                  // Handle the Help option
                  Navigator.pop(context);
                  await widget.getReports!();
                },
              ),
            ),
        if (widget.showRp)
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text('Members'),
              onTap: () async {
                // Handle the Help option
                Navigator.pop(context);
                await widget.getReports!();
              },
            ),
          ),
        if (_userState.currentMember!.role == 'Student')
          if (widget.createAttendance == null)
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Checking'),
                onTap: () async {
                  // Handle the Help option
                  Navigator.pop(context);
                  await widget.checkin!();
                },
              ),
            ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reload'),
            onTap: () async {
              // Handle the Help option
              Navigator.pop(context);
              await widget.refresh!();
            },
          ),
        ),
      ],
    );
  }
}
