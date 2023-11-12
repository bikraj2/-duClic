import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sikshya/core/extenions/context_extensions.dart';
import 'package:sikshya/core/services/injection_container.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20).copyWith(top: context.topPadding + 20),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    sl<FirebaseAuth>().signOut();
                    context.pushReplacement('/signIn');
                  },
                  child: Text("Log out")),
            )
          ],
        ),
      ),
    );
  }
}
