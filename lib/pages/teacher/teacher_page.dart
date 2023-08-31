import 'package:face_net_authentication/base/base_statefull.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/pages/class/class_page.dart';
import 'package:face_net_authentication/pages/login/login_page.dart';
import 'package:face_net_authentication/pages/teacher/create_class.dart';
import 'package:face_net_authentication/pages/teacher/teacher_controller.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:face_net_authentication/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TeacherHomePage extends BaseStatefulWidget {
  TeacherHomePage({super.key});

  static const String NAME = "/teacher_home";

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  ScreenRouter _screenRouter = locator<ScreenRouter>();
  TeacherController _teacherController = locator<TeacherController>();

  List<Widget>? _list;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _list = await getData();
    setState(() {
      _list = _list;
    });
  }

  @override
  void dispose() {
    _teacherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Obx(() {
      if (!_teacherController.loading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container();
    });
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text('Home Page'),
          actions: [
            IconButton(
              onPressed: () {
                _screenRouter.goToAndRemoveCurrent(LoginPage.NAME);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: buildBody(),
        floatingActionButton: MyFloatingActionButtonMenu(
          refresh: () async {
            _loadData();
          },
          addClass: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateClass()));
            await _loadData();
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // reload button
          Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(0), // Set the desired height to 0
                child: AppBar(
                  // Add any other AppBar properties as needed
                  backgroundColor:
                      Colors.white, // Customize the AppBar appearance
                ),
              ),
              body: SafeArea(
                child: _list == null || _list!.length == 0
                    ? Container()
                    : ListView(
                        children: _list!,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> getData() async {
    List<Class>? classes = await _teacherController.getClasses();
    if (classes == null) {
      return RxList<Widget>();
    }

    return classes
        .map((e) {
          return ClassCard(
            data: e,
            onPress: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClassPage(
                    data: e,
                  ),
                ),
              );
            },
          );
        })
        .toList()
        .obs;
  }
}

class MyFloatingActionButtonMenu extends StatefulWidget {
  MyFloatingActionButtonMenu({
    super.key,
    this.refresh,
    this.addClass,
  });

  final Future<void> Function()? refresh;
  final Future<void> Function()? addClass;

  @override
  State<MyFloatingActionButtonMenu> createState() =>
      _MyFloatingActionButtonMenuState();
}

class _MyFloatingActionButtonMenuState
    extends State<MyFloatingActionButtonMenu> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Implement the logic to show the menu options here
        // You can use a PopupMenuButton or any custom menu widget
        // For simplicity, we'll use a PopupMenuButton here.
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
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reload'),
            onTap: () {
              // Handle the Settings option
              widget.refresh!();
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Class'),
            onTap: () async {
              // Handle the Help option
              await widget.addClass!();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
