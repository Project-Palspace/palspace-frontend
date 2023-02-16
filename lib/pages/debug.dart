import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/models/register.dart';
import 'package:tbd/models/renew.dart';
import 'package:tbd/providers/api_client.dart';

class DebugPage extends ConsumerStatefulWidget {
  const DebugPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DebugPageState();
}

class _DebugPageState extends ConsumerState<DebugPage> {
  @override
  Widget build(BuildContext context) {
    final apiClient = ref.read(apiClientProvider);

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
          ElevatedButton(
            onPressed: () {
              apiClient
                  .register(
                    const RegisterBody(
                      username: 'aeversil5',
                      email: 'dunccan.jorit5@gmail.com',
                      password: 'admin123',
                    ),
                  )
                  .then((value) => log(value.toString()));
            },
            child: const Text('Test Register'),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     apiClient
          //         .login(
          //           const LoginBody(
          //             email: 'dunccan.jorit2@gmail.com',
          //             password: 'admin123',
          //           ),
          //         )
          //         .then((value) => log(value.toString()));
          //   },
          //   child: const Text('Test Login'),
          // ),
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