import 'package:flutter/material.dart';
import 'package:GDSC_Task/UserModel.dart';
import 'sharedPref.dart';

class AddPasswordPage extends StatefulWidget {
  String website;
  String userName;
  String password;
  int updateUserAtIndex = -1;

  AddPasswordPage(
      this.website, this.userName, this.password, this.updateUserAtIndex,
      {super.key});

  @override
  _AddPasswordState createState() =>
      _AddPasswordState(website, userName, password, updateUserAtIndex);
}

class _AddPasswordState extends State<AddPasswordPage> {
  SharedPref sharedPref = SharedPref();
  late UserModel oldUser;
  String website = "";
  String userName = "";
  String password = "";
  int updateUserAtIndex = -1; // this for updating user information

  late TextEditingController _websiteController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;

  _AddPasswordState(
      this.website, this.userName, this.password, this.updateUserAtIndex);

  @override
  void initState() {
    super.initState();
    oldUser =
        UserModel(website: website, userName: userName, password: password);
    _websiteController = TextEditingController(text: website);
    _userNameController = TextEditingController(text: userName);
    _passwordController = TextEditingController(text: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Password Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 15),
              child: TextField(
                controller: _websiteController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Website',
                    hintText: 'Website'),
                onChanged: (value) {
                  setState(() {
                    website = value;
                  });
                },
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 15),
              child: TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Username'),
                onChanged: (value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passwordController,
                obscureText: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'password'),
                onChanged: (value) {
                  setState(() {
                    this.password = value;
                  });
                },
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  // logic to add pasword
                  UserModel userSave = UserModel(
                      website: website, userName: userName, password: password);

                  try {
                    if (updateUserAtIndex != -1) {
                      Future<bool> isSaved = sharedPref.updateUsertoUserList(
                          updateUserAtIndex, userSave);
                      isSaved.then((value) async {
                        print(
                            "********************************user is updated  successfully");
                        Navigator.pop(context, userSave);
                      });
                    } else {
                      Future<bool> isSaved =
                      sharedPref.saveUsertoUserList(userSave);
                      isSaved.then((value) async {
                        print(
                            "********************************user is saved successfully");
                        Navigator.pop(context, userSave);
                      });
                    }
                  } catch (e, s) {
                    print(s);
                  }
                },
                child: const Text(
                  'Add Password',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 130,
            // ),
            // Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
