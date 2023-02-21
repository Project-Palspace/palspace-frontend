import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/register.dart';

import '../../providers/auth.dart';
import '../../routes/router.gr.dart';

final registerViewModelProvider =
    ChangeNotifierProvider<RegisterViewModel>((ref) => RegisterViewModel(ref));

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel(this.ref);

  final Ref ref;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _loading = false;
  String? username, email, country, password, cPassword;
  FocusNode usernameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();

  AuthStateNotifier get _auth => ref.read(authStateNotifierProvider.notifier);
  bool get loading => _loading;
  bool get validate => _validate;

  Future<void> register(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      _validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      if (password == cPassword) {
        _loading = true;
        notifyListeners();

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
                .signUp(RegisterBody(
                    username: username!, email: email!, password: password!))
                .whenComplete(
              () {
                if (_auth.isSignedIn) {
                  context.router.replace(
                      const TabScreenRoute()); //TODO: show verification screen
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
      } else {
        showInSnackBar('The passwords does not match', context);
      }
    }
  }

  void setEmail(String? val) {
    email = val;
    notifyListeners();
  }

  void setPassword(String? val) {
    password = val;
    notifyListeners();
  }

  void setName(String? val) {
    username = val;
    notifyListeners();
  }

  void setConfirmPass(String? val) {
    cPassword = val;
    notifyListeners();
  }

  void setCountry(String? val) {
    country = val;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
