import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('App router shell boots and shows Start screen placeholder',
      (tester) async {
    // Minimal router-driven app for widget testing.
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: Center(child: Text('START')),
          ),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (_, __) => const Scaffold(
            body: Center(child: Text('SIGN_IN')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    await tester.pumpAndSettle();
    expect(find.text('START'), findsOneWidget);
  });
}
