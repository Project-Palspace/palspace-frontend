import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:tbd/auth/verification/verification_view_model.dart';
import 'package:tbd/components/verification_form_builder.dart';

import '../../providers/auth.dart';
import '../../utils/validation.dart';
import '../../widgets/indicators.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  const EmailVerificationView({@PathParam('code') this.code, super.key});

  final String? code;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationState();
}

class _EmailVerificationState extends ConsumerState<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    VerifyEmailViewModel viewModel = ref.watch(verifyEmailViewModelProvider);
    // var authState = ref.read(authStateNotifierProvider.notifier);
    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            // SizedBox(
            //   height: 170.0,
            //   width: MediaQuery.of(context).size.width,
            //   // child: Image.asset(
            //   //   'assets/images/login.png',
            //   // ),
            // ),

            const Icon(
              Ionicons.mail_outline,
              size: 170,
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                'Verify Email',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Center(
              child: Text(
                'Please verify your email address to complete your registration. Check your inbox for our email and click on the verification link provided',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25.0),
            buildForm(viewModel, context, widget.code),
          ],
        ),
      ),
    );
  }

  buildForm(
      VerifyEmailViewModel viewModel, BuildContext context, String? code) {
    TextEditingController _controller = TextEditingController();

    if (code != null) {
      _controller.text = code;
    }
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          VerificationFormBuilder(
            controller: _controller,
            enabled: !viewModel.loading,
            prefix: Ionicons.code, //TODO: replace me
            hintText: "Verification Code",
            textInputAction: TextInputAction.go,
            validateFunction: Validations.validateVerification,
            onSaved: (String val) {
              viewModel.setCode(val);
            },
            focusNode: viewModel.codeFN,
          ),
          const SizedBox(height: 25.0),
          SizedBox(
            height: 45.0,
            width: 180.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: Text(
                'verify'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => viewModel.verifyEmail(context),
            ),
          ),
        ],
      ),
    );
  }
}
