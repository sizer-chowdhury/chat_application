import 'package:chat_app/core/navigation/routes/routes_name.dart';
import 'package:chat_app/core/theme/light_mode.dart';
import 'package:chat_app/core/theme/theme_provider.dart';
import 'package:chat_app/core/utils/google_sign_in.dart';
import 'package:chat_app/core/utils/user_data.dart';
import 'package:chat_app/core/widgets/text_field.dart';
import 'package:chat_app/feature/logIn/presentation/riverpod/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool isButtonEnable = false;
  bool? enableCheckbox = false;
  bool darkMode = false;

  ({
    bool email,
    bool password,
  }) enableButtonNotifier = (email: false, password: false);

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });

    _emailController.addListener(
      () => updateEnableButtonNotifier(),
    );

    _passwordController.addListener(
      () => updateEnableButtonNotifier(),
    );
  }

  void updateEnableButtonNotifier() {
    setState(() {
      enableButtonNotifier = (
        email: _emailController.value.text.isNotEmpty,
        password: _passwordController.value.text.isNotEmpty,
      );

      isButtonEnable =
          enableButtonNotifier.email && enableButtonNotifier.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final ThemeData themeData =
        ref.read(themeModeProvider.notifier).getThemeData(themeMode);
    final state = ref.watch(loginControllerProvider);
    ref.listen(loginControllerProvider, (_, next) {
      if (next.value?.$1 == null && next.value?.$2 == null) {
        const CircularProgressIndicator();
      } else if (next.value?.$1 != null && next.value?.$2 == null) {
        context.go(RoutesName.home);
      } else if (next.value?.$1 == null && next.value?.$2 != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error!'),
              content: Text('${next.value?.$2}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: !(themeData == lightMode)
                  ? Icon(Icons.light_mode, color: Colors.white)
                  : Icon(Icons.dark_mode, color: Colors.black),
              onPressed: () {
                setState(() {
                  darkMode = !darkMode;
                });
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),
              Text(
                "Welcome to our community",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextfield(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Email must be an email';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 25),
              MyTextfield(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 34, right: 24),
                child: Row(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 10,
                          width: 10,
                          child: Checkbox(
                            value: enableCheckbox,
                            onChanged: (newValue) {
                              setState(() {
                                enableCheckbox = newValue;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            fillColor: (enableCheckbox!)
                                ? WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.primary,
                                  )
                                : WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                  ),
                            side: (enableCheckbox!)
                                ? BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    width: 2,
                                  )
                                : BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Remember Me',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push(RoutesName.forgetPassword);
                      },
                      child: Text(
                        'Forget Password?',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: (isButtonEnable)
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(loginControllerProvider.notifier).login(
                                  UserData(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white10,
                        )
                      : Text(
                          'LogIn',
                          style: !isButtonEnable
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.titleSmall,
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(RoutesName.signup);
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
