import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_login.dart';
import 'package:story_app/provider/login.dart';
import 'package:story_app/util/helper.dart';
import 'package:story_app/util/showToast.dart';
import 'package:story_app/widget/safe_area.dart';

import '../data/preferences/token.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onRegisterClicked;

  const LoginPage(
      {super.key,
      required this.onLoginSuccess,
      required this.onRegisterClicked});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScaffold(
      appBar: AppBar(title: const Text("Login")),
      body: ChangeNotifierProvider<LoginProvider>(
        create: (context) => LoginProvider(ApiService(), Token()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter your email!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter your password!';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Password"),
                    ),
                    const SizedBox(height: 8),
                    Consumer<LoginProvider>(
                      builder: (context, provider, _) {
                        _handleState(provider);

                        return ElevatedButton(
                          onPressed: () => {
                            if (_formKey.currentState?.validate() == true)
                              {
                                provider.login(
                                  LoginRequest(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                ),
                              }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (provider.loginState ==
                                  ResultState.loading) ...[
                                const SizedBox(
                                  width: 40 * 0.5,
                                  height: 40 * 0.5,
                                  child: CircularProgressIndicator(),
                                ),
                                const SizedBox(width: 8),
                              ],
                              const Text('Login')
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => widget.onRegisterClicked(),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleState(LoginProvider provider) {
    switch (provider.loginState) {
      case ResultState.hasData:
        showToast(provider.loginMessage);
        afterBuildWidgetCallback(widget.onLoginSuccess);
        break;
      case ResultState.noData:
      case ResultState.error:
        showToast(provider.loginMessage);
        break;
      default:
        break;
    }
  }
}
