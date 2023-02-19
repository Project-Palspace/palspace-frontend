import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/models/register.dart';
import 'package:tbd/models/renew.dart';
import 'package:tbd/providers/api_client.dart';
import 'package:tbd/providers/app.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/routes/router.gr.dart';

import '../main.dart';
import '../repository/token_repository.dart';

class DebugPage extends ConsumerStatefulWidget {
  const DebugPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DebugPageState();
}

class _DebugPageState extends ConsumerState<DebugPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider.notifier);
    final isSignedIn = ref.watch(authStateNotifierProvider).isSignedIn;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Debug Page',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 124),
        children: [
          Text(
            "Did Auth Init: ${authState.initialized}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Is Signed In: $isSignedIn",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          ElevatedButton(
            onPressed: () => authState.signUp(
              const RegisterBody(
                  username: 'aeversil',
                  email: 'dunccan.jorit@gmail.com',
                  password: 'admin123'),
            ),
            child: const Text('Test Register'),
          ),
          ElevatedButton(
            onPressed: () => authState.signIn(
              const LoginBody(
                email: 'dunccan.jorit@gmail.com',
                password: 'admin123',
              ),
            ),
            child: const Text('Test Login'),
          ),
          ElevatedButton(
            onPressed: () => authState.logout(userInitiated: true),
            child: const Text('Logout'),
          ),

          ElevatedButton(
            onPressed: () => context.router.navigate(const Auth()),
            child: const Text('Navigate'),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     apiClient
          //         .renew(
          //           const RenewBody(
          //               renewToken:
          //                   'pJAIQSmhtnMm2bUC5sYsZZa5P8dKgJyMRO47QPGiqDaYyUq7bAkhlujpWykdzKviNBakIZjNZcJRdS76oNNlI46XfoI1pSacJYHzI4tQTfcdEvx41jpZSLMH6aDgc8zL'),
          //         )
          //         .then((value) => log(value.toString()));
          //   },
          //   child: const Text('Test Renew Token'),
          // ),
        ],
      ),
    );
  }
}
