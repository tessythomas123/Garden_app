import 'package:flutter/material.dart';
import 'package:garden/services/auth.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  
  final AuthServices _auth = AuthServices();
  String error = "";
  String email = "";
  String password = "";

  void initState() {
    super.initState();
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return
        //loading? Loading():
        Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'example@gmail.com',
                      labelText: 'Username',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    validator: (value) {
                      if (!validateEmail(value)) {
                        return 'not a valid username';
                      } else {
                        return null;
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 130, top: 40.0),
                child: new RaisedButton(
                    child: const Text(
                      "Login",
                    ),
                    textColor: Colors.white,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    disabledColor: Colors.grey[500],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email, password);

                        if (result == null) {
                          setState(() {
                            error = 'Could not sign in with those credentials';
                            loading = false;
                          });
                        }
                      }
                    }),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
