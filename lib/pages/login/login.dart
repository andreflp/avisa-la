import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:projeto_integ/pages/map.dart';
import 'package:projeto_integ/services/auth.dart';
import 'package:projeto_integ/utils/utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

  final AuthService auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;

  Login({this.auth, this.loginCallback, this.logoutCallback});
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _name;
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  String _userId = "";
  VoidCallback logoutCallback;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF41A4F1),
                      Color(0xFF278DE0),
                      Color(0xFF118AE5),
                    ],
                    stops: [0.3, 0.6, 0.8],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: _isLoginForm ? 150.0 : 100,
                          child: Image.asset(
                            "images/logo.png",
                          ),
                        ),
                        Offstage(
                          offstage: _isLoginForm,
                          child: _nameTextField(),
                        ),
                        Offstage(
                          offstage: _isLoginForm,
                          child: SizedBox(
                            height: 14.0,
                          ),
                        ),
                        _emailTextField(),
                        SizedBox(
                          height: 5.0,
                        ),
                        _passwordTextField(),
                        _loginBtn(context),
                        _signUpBtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            attribute: "_name",
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: loginFieldDecoration("Digite seu nome", Icons.person),
            onSaved: (value) => _name = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            attribute: "_email",
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: loginFieldDecoration("Digite seu e-mail", Icons.email),
            validators: [
              FormBuilderValidators.required(errorText: 'Informe um email'),
              FormBuilderValidators.email(errorText: 'Informe um email válido')
            ],
            onSaved: (value) => _email = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            attribute: "_password",
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
            ),
            obscureText: true,
            decoration: loginFieldDecoration("Digite sua senha", Icons.lock),
            validators: [
              FormBuilderValidators.required(errorText: 'Informe uma senha'),
              FormBuilderValidators.minLength(6,
                  errorText: 'Deve conter no mínimo 6 caracteres')
            ],
            onSaved: (value) => _password = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _loginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => validateAndSubmit(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: Text(
          _isLoginForm ? 'Login' : 'Registrar-se',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _signUpBtn() {
    return GestureDetector(
      onTap: toggleFormMode,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _isLoginForm ? 'Registrar-se' : 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void validateAndSubmit(BuildContext context) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          Navigator.pushNamed(context, '/map',
              arguments: Maps(auth: widget.auth));
        } else {
          userId = await widget.auth.signUp(_name, _email, _password);
          Navigator.pushNamed(context, '/map',
              arguments: Maps(
                auth: widget.auth,
              ));
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print(e.code);
        if (e.code.toString() == 'ERROR_WRONG_PASSWORD') {
          _showDialog('Senha incorreta.');
        } else if (e.code.toString() == 'ERROR_USER_NOT_FOUND') {
          _showDialog('Usuário não encontrado.');
        }
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void _showDialog(String msg) {
    var snackbar = new SnackBar(
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
      content: Text(
        msg,
        style: TextStyle(color: Color(0xFF527DAA), fontSize: 15.0),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      behavior: SnackBarBehavior.floating,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
