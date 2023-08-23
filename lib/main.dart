import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/routes/router_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate _myRouterDelegate;

  @override
  void initState() {
    super.initState();
    _myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageManager>(
          create: (context) => PageManager(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'StoryApp',
          home: Router(
            routerDelegate: _myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      },
    );
  }
}
