import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordControler = TextEditingController();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    _opacityAnimation?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  bool _isLogin() {
    return _authMode == AuthMode.login;
  }

  /*bool _isSignUp() {
    return _authMode == AuthMode.signUp;
  }*/

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Ocorreu um erro'),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'),
              )
            ],
          );
        });
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        await auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthExceptions catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 310 : 400,
          width: deviceSize.width * 0.75,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    final storedEmail = email ?? '';
                    if (storedEmail.trim().isEmpty ||
                        !storedEmail.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _authData['email'] = email ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  controller: _passwordControler,
                  validator: (password) {
                    final storedPassword = password ?? '';
                    if (storedPassword.isEmpty || storedPassword.length < 6) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _authData['password'] = password ?? '';
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _isLogin() ? 0 : 100,
                      maxHeight: _isLogin() ? 0 : 100),
                  duration: Duration(milliseconds: 200),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (passwordConfirmed) {
                              final password = passwordConfirmed ?? '';
                              if (password != _passwordControler.text) {
                                return 'Senhas informadas não conferem';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(_authMode == AuthMode.login
                            ? 'ENTRAR'
                            : 'REGISTRAR'),
                      ),
                Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_isLogin()
                        ? 'Deseja se Registrar?'
                        : 'Já possui conta?'))
              ],
            ),
          ),
        ));
  }
}
