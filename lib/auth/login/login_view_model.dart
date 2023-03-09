import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/providers/auth.dart';

import '../../routes/router.gr.dart';
import '../../utils/validation.dart';

final loginViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginViewModel(ref));

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this.ref);

  final Ref ref;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final emailFN = FocusNode();
  final passFN = FocusNode();
  bool _validate = false;
  bool _loading = false;
  String? _email, _password;

  bool get validate => _validate;
  bool get loading => _loading;
  String? get email => _email;
  String? get password => _password;

  AuthStateNotifier get _auth => ref.watch(authStateNotifierProvider.notifier);

  void login(BuildContext context) async {
    final form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      _validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      _loading = true;
      notifyListeners();
      try {
        await _auth
            .signIn(LoginBody(email: _email!, password: _password!))
            .whenComplete(
          () {
            if (_auth.isSignedIn) {
              context.router.replace(const TabScreenRoute());
            }
          },
        );
      } catch (e) {
        _loading = false;
        notifyListeners();
        print(e);
        // showInSnackBar('', context); //TODO: show handled error
      }
      _loading = false;
      notifyListeners();
    }
  }

  // void forgotPassword(BuildContext context) async {
  //   _loading = true;
  //   notifyListeners();
  //   final form = formKey.currentState!;
  //   form.save();
  //   print(Validations.validateEmail(_email));
  //   if (Validations.validateEmail(_email) != null) {
  //     showInSnackBar('Please input a valid email to reset your password.', context);
  //   } else {
  //     try {
  //       await _auth.forgotPassword(_email!);
  //       showInSnackBar('Please check your email for instructions to reset your password', context);
  //     } catch (e) {
  //       showInSnackBar('${e.toString()}', context);
  //     }
  //   }
  //   _loading = false;
  //   notifyListeners();
  // }

  void setEmail(val) {
    _email = val;
    notifyListeners();
  }

  void setPassword(val) {
    _password = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
