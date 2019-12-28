import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';
import 'package:autodo/localization.dart';
import '../../widgets/barrel.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;
  FocusNode _emailNode, _passwordNode;

  @override
  void initState() {
    _emailNode = FocusNode()..requestFocus();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  build(context) => BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupError) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AutodoLocalizations.loginFailure,
                      ),
                      Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          } else if (state is SignupLoading) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AutodoLocalizations.loggingInEllipsis),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          } else if (state is SignupSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            Navigator.pushNamed(context, AutodoRoutes.home);
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) => Form(
                key: _formKey,
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: ListView(
                      children: <Widget>[
                        EmailForm(
                            onSaved: (val) => _email = val,
                            node: _emailNode,
                            nextNode: _passwordNode,
                            login: false),
                        PasswordForm(
                          onSaved: (val) => _password = val,
                          node: _passwordNode,
                          login: false,
                        ),
                        (state is SignupError)
                            ? ErrorMessage(state.errorMsg)
                            : Container(),
                        LegalNotice(),
                        SignupSubmitButton(onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            BlocProvider.of<SignupBloc>(context).add(
                                SignupWithCredentialsPressed(
                                    email: _email, password: _password));
                            Navigator.pushNamed(context, AutodoRoutes.home);
                          }
                        }),
                        PasswordResetButton(),
                        SignupToLoginButton(),
                      ],
                    )))),
      );
}
