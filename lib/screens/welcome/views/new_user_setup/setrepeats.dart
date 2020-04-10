import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../blocs/blocs.dart';
import '../../../../generated/localization.dart';
import '../../../../integ_test_keys.dart';
import '../../../../models/models.dart';
import '../../../../routes.dart';
import '../../../../theme.dart';
import '../../../../units/units.dart';
import '../../../../util.dart';
import '../../../../widgets/widgets.dart';
import 'base.dart';
import 'new_user_screen_page.dart';

const int cardAppearDuration = 200; // in ms

class _OilInterval extends StatelessWidget {
  const _OilInterval(this.todo, this.node, this.nextNode);

  final FocusNode node, nextNode;

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.setOilInterval,
      maxLines: 1,
      autofocus: false,
      initialValue: distance.format(
        todo.mileageRepeatInterval,
        textField: true,
      ),
      decoration: defaultInputDecoration('(${distance.unitString(context)})',
          'Oil Change Interval (${distance.unitString(context)})'),
      validator: intValidator,
      onSaved: (val) => BlocProvider.of<TodosBloc>(context).add(UpdateTodo(
          todo.copyWith(
              mileageRepeatInterval:
                  distance.unitToInternal(double.parse(val.trim()))))),
      focusNode: node,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _TireRotationInterval extends StatelessWidget {
  const _TireRotationInterval(this.todo, this.node);

  final FocusNode node;

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.setTireRotationInterval,
      maxLines: 1,
      autofocus: false,
      initialValue:
          distance.format(todo.mileageRepeatInterval, textField: true),
      decoration: defaultInputDecoration('(${distance.unitString(context)})',
          'Tire Rotation Interval (${distance.unitString(context)})'), // Todo: Translate
      validator: intValidator,
      onSaved: (val) => BlocProvider.of<TodosBloc>(context).add(UpdateTodo(
          todo.copyWith(
              mileageRepeatInterval:
                  distance.unitToInternal(double.parse(val.trim()))))),
      focusNode: node,
      textInputAction: TextInputAction.done,
    );
  }
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        height: 110,
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Before you get started,\n let\'s get some info about your car.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(230),
                ),
              ),
            ),
            Text(
              'How often do you want to do these tasks?',
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        )),
      );
}

class _Card extends StatelessWidget {
  const _Card(this.oilTodo, this.tireRotationTodo, this.oilNode,
      this.tireRotationNode, this.onNext);

  final Todo oilTodo, tireRotationTodo;

  final FocusNode oilNode, tireRotationNode;

  final Function onNext;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _OilInterval(oilTodo, oilNode, tireRotationNode),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _TireRotationInterval(tireRotationTodo, tireRotationNode),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, AutodoRoutes.home),
                  ),
                  FlatButton(
                    key: IntegrationTestKeys.setRepeatsNext,
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      JsonIntl.of(context).get(IntlKeys.next),
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () async => await onNext(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class SetRepeatsScreen extends StatefulWidget {
  const SetRepeatsScreen(this.repeatKey, this.page);

  final GlobalKey<FormState> repeatKey;

  final NewUserScreenPage page;

  @override
  SetRepeatsScreenState createState() =>
      SetRepeatsScreenState(page == NewUserScreenPage.REPEATS);
}

class SetRepeatsScreenState extends State<SetRepeatsScreen>
    with SingleTickerProviderStateMixin {
  SetRepeatsScreenState(this.pageWillBeVisible);

  bool pageWillBeVisible;

  AnimationController openCtrl;

  Animation<double> openCurve;

  FocusNode _oilNode, _tiresNode;

  @override
  void initState() {
    openCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
    openCurve = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: openCtrl, curve: Curves.easeOutCubic));
    _oilNode = FocusNode();
    _tiresNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (widget.repeatKey.currentState.validate()) {
      widget.repeatKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      await Navigator.popAndPushNamed(context, AutodoRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    return BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
      if (!(state is TodosLoaded) || (state as TodosLoaded).todos.isEmpty) {
        return LoadingIndicator();
      }
      final oilTodo = (state as TodosLoaded).todos.firstWhere(
          (val) => val.name == JsonIntl.of(context).get(IntlKeys.oil));
      final tireRotationTodo = (state as TodosLoaded).todos.firstWhere(
          (val) => val.name == JsonIntl.of(context).get(IntlKeys.tireRotation));
      return Form(
          key: widget.repeatKey,
          child: AccountSetupScreen(
              header: _HeaderText(),
              panel: _Card(
                  oilTodo, tireRotationTodo, _oilNode, _tiresNode, _next)));
    });
  }
}
