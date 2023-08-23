import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_register.dart';
import 'package:story_app/provider/register.dart';
import 'package:story_app/util/helper.dart';
import 'package:story_app/util/showToast.dart';
import 'package:story_app/widget/safe_area.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const RegisterPage({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
      appBar: AppBar(title: const Text("Register")),
      body: ChangeNotifierProvider<RegisterProvider>(
        create: (context) => RegisterProvider(ApiService()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter your name!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    Consumer<RegisterProvider>(
                      builder: (context, provider, _) {
                        _handleState(provider);

                        return ElevatedButton(
                          onPressed: () => {
                            if (_formKey.currentState?.validate() == true)
                              {
                                provider.register(
                                  RegisterRequest(
                                    name: _nameController.text,
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
                              if (provider.registerState ==
                                  ResultState.loading) ...[
                                const SizedBox(
                                  width: 40 * 0.5,
                                  height: 40 * 0.5,
                                  child: CircularProgressIndicator(),
                                ),
                                const SizedBox(width: 8),
                              ],
                              const Text('Register')
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleState(RegisterProvider provider) {
    switch (provider.registerState) {
      case ResultState.hasData:
        afterBuildWidgetCallback(() => widget.onRegisterSuccess());
        showToast(provider.registerMessage);
        break;
      case ResultState.noData:
      case ResultState.error:
        showToast(provider.registerMessage);
        break;
      default:
        break;
    }
  }
}
