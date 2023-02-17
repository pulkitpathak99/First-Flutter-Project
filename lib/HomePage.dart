import 'package:flutter/material.dart';
import 'package:GDSC_Task/AddPassword.dart';
import 'package:GDSC_Task/UserModel.dart';

import 'sharedPref.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModel> userArrayList = <UserModel>[];
  SharedPref sharedPref = SharedPref();

  _HomePageState() {
    loadSharedPrefs();
  }

  String getUserString(int index) {
    if (userArrayList.length == 0) {
      return "";
    }
    return '\n\nWebsite: ${userArrayList[index].website} '
        '\nUsername: ${userArrayList[index].userName} '
        '\nPassword: ${userArrayList[index].password}';
  }

  loadSharedPrefs() async {
    try {
      Future<List<UserModel>> userList = sharedPref.getUserList();
      userList.then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Loaded!"), duration: Duration(milliseconds: 500)));
        setState(() {
          this.userArrayList = value;
          // userList.add(user);
        });
      });
      // UserModel user = UserModel.fromJson(await sharedPref.read("user"));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Saved Passwords'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: userArrayList.length,
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              child: Card(
                elevation: 9,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                      left: 20.0, right: 16, top: 0, bottom: 15),
                  dense: false,
                  // leading: FlutterLogo(),
                  title: Text(
                    getUserString(index),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Update Details'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        )
                      ];
                    },
                    onSelected: (String value) => actionPopUpItemSelected(
                        context, value, userArrayList[index], index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPasswordPage("", "", "", -1)))
              .then((_) {
            // This method gets callback after your SecondScreen is popped from the stack or finished.
            loadSharedPrefs();
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void actionPopUpItemSelected(
      BuildContext context, String value, UserModel user, int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    String message;
    if (value == 'edit') {
      message = 'You selected edit for ${user.userName}';
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPasswordPage(
                      user.website, user.userName, user.password, index)))
          .then((_) {
        // This method gets callback after your SecondScreen is popped from the stack or finished.
        loadSharedPrefs();
      });
    } else if (value == 'delete') {
      Future<UserModel> deletedUser = sharedPref.deleteUserFromUserList(index);
      deletedUser.then((value) async {
        setState(() {
          message = 'You selected delete for ${value.userName}';
          final snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          loadSharedPrefs();
        });

        print(
            "************************  user ${value.userName}' is deleted  successfully  ********");
      });
    } else {
      message = 'Not implemented';
    }
  }
}
