import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../model/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      /// transform allows you transform how your container
                      /// presented like rotate/scale/move
                      /// this argument wil configure
                      /// Matrix4 is provided by material.dart which is describe
                      /// the transformation of container like scaling/rotate/offset
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                      /// .. syntax return what the previous return (?)
                      /// itu ngubah agar bisa ikut ngereturn sesuai method sebelumnya
                      /// Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0), itu sama kayak
                      /// objek = Matrix4.rotationZ(-8 * pi / 180)
                      /// objek.translate(-10.0)
                        ..translate(-10.0), 
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          // color: Theme.of(context).accentTextTheme.title.color,
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

/// SingleTickerProviderStateMixin for 
class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  // this helps us to control animation
  AnimationController _controller;
  // Animation is a generic type, so you should specific it which to animated
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      /// vsync is an argument where we give the animation controller
      /// a pointer at the object, the widget in the end which it should watch
      /// and only when that widget is really visible on the screen, the animation should play
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    /// Tween gives you an object which in the end know how to animate between
    /// two values
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
      /// animate object describe how to animate it
    )
      .animate(
        CurvedAnimation(
          parent: _controller, // which it should be controlled
          curve: Curves.fastOutSlowIn // define how the duration time here is basically split
        )
      );
    
    _opacityAnimation = Tween<double>(
      begin: 0.0 ,
      end: 1
    )
      .animate(
        CurvedAnimation(
          parent: _controller, 
          curve: Curves.easeIn
        )
      );
    /// add listener to call setState
    /// whenever it updates and it should update whenever it redraws the screen
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // clear controller when screen removed
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // title: Text('An error occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
      // Log user in
      await Provider.of<AuthProvider>(context, listen: false)
        .signIn(_authData['email'], _authData['password']);
      } 
        else {
          // Sign user up
          try {
            await Provider.of<AuthProvider>(context, listen: false)
              .signUp(_authData['email'], _authData['password']);
          }
            catch(error) {
              throw (error);
            }
        }
      // Navigator.of(context)
      //           .pushReplacementNamed(ProductsOverviewScreen.routeName);
    }
      // specify the class error by using 'on'
      on HttpException catch(error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'Email already exist';
        }
        else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          errorMessage = 'Too many authentication attempt!';
        }
        else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Email not found!';
        }
        else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Password is wrong!';
        }
        _showMessageDialog(errorMessage);
      }
        // specify on which error is not handled by HTTPException
        catch(error) {
          // i.e: lost connection
          const errorMessage = 'We cant authenticate you. Please try again later';
          _showMessageDialog(errorMessage);
        }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    /// we have to make sure when we're on signup mode,
    /// we increase the height
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      /// forward() will start the animation
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      /// using AnimationBuilder
      // child: AnimatedBuilder(
      //   // what animation?
      //   animation: _heightAnimation, 
      //   // what to be re rendered
      //   builder: (ctx, ch) =>  Container(
      //     // height: _authMode == AuthMode.Signup ? 320 : 260,
      //     height: _heightAnimation.value.height, // this changes over time as soon as we start the animation
      //     constraints:
      //         // BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
      //         BoxConstraints(minHeight: _heightAnimation.value.height),
      //     width: deviceSize.width * 0.75,
      //     padding: EdgeInsets.all(16.0),
      //     child:ch
      //   ),
      //   /// use of child argument make this only re render form, not
      //   /// entirely widget
      //   child: Form(
      //     key: _formKey,
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: <Widget>[
      //           TextFormField(
      //             decoration: InputDecoration(labelText: 'E-Mail'),
      //             keyboardType: TextInputType.emailAddress,
      //             validator: (value) {
      //               if (value.isEmpty || !value.contains('@')) {
      //                 return 'Invalid email!';
      //               }
      //             },
      //             onSaved: (value) {
      //               _authData['email'] = value;
      //             },
      //           ),
      //           TextFormField(
      //             decoration: InputDecoration(labelText: 'Password'),
      //             obscureText: true,
      //             controller: _passwordController,
      //             validator: (value) {
      //               if (value.isEmpty || value.length < 5) {
      //                 return 'Password is too short!';
      //               }
      //             },
      //             onSaved: (value) {
      //               _authData['password'] = value;
      //             },
      //           ),
      //           if (_authMode == AuthMode.Signup)
      //             TextFormField(
      //               enabled: _authMode == AuthMode.Signup,
      //               decoration: InputDecoration(labelText: 'Confirm Password'),
      //               obscureText: true,
      //               validator: _authMode == AuthMode.Signup
      //                   ? (value) {
      //                       if (value != _passwordController.text) {
      //                         return 'Passwords do not match!';
      //                       }
      //                     }
      //                   : null,
      //             ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           if (_isLoading)
      //             CircularProgressIndicator()
      //           else
      //             RaisedButton(
      //               child:
      //                   Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
      //               onPressed: _submit,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(30),
      //               ),
      //               padding:
      //                   EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      //               color: Theme.of(context).primaryColor,
      //               textColor: Theme.of(context).primaryTextTheme.button.color,
      //             ),
      //           FlatButton(
      //             child: Text(
      //                 '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
      //             onPressed: _switchAuthMode,
      //             padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
      //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //             textColor: Theme.of(context).primaryColor,
      //           ),  
      //         ],
      //       ),
      //     ),
      //   ),
      // )

      /// using AnimatedContainer
      /// AnimatedContainer doesn't need controller
      /// AnimatedContainer doesn't need _heightAnimation.value.height
      /// so it more code efficient
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: _heightAnimation.value.height, // this changes over time as soon as we start the animation
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
            // BoxConstraints(minHeight: _heightAnimation.value.height),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        /// use of child argument make this only re render form, not
        /// entirely widget
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    // minHeight depend on authMode
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                              : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),  
              ],
            ),
          ),
        ),
      )
    );
  }
}
