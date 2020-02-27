import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:json_intl/json_intl.dart';

class UpgradeDialog extends AlertDialog {
  UpgradeDialog({Key key, @required context, @required trialUser})
      : super(
            key: key,
            title: Text(JsonIntl.of(context).get(IntlKeys.upgradePaidVersion),
                style: Theme.of(context).primaryTextTheme.subtitle),
            content: trialUser
                ? Text(
                    JsonIntl.of(context).get(IntlKeys.upgradePaidVersionTrial),
                    style: Theme.of(context).primaryTextTheme.body1)
                : Text(
                    JsonIntl.of(context).get(IntlKeys.upgradePaidVersionDesc),
                    style: Theme.of(context).primaryTextTheme.body1),
            actions: trialUser
                ? [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            JsonIntl.of(context)
                                .get(IntlKeys.back)
                                .toUpperCase(),
                            style: Theme.of(context).primaryTextTheme.button))
                  ]
                : [
                    FlatButton(
                        onPressed: () {
                          BlocProvider.of<PaidVersionBloc>(context)
                              .add(PaidVersionUpgrade());
                        },
                        child: Text(
                            JsonIntl.of(context)
                                .get(IntlKeys.purchase)
                                .toUpperCase(),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .button
                                .copyWith(
                                    color: Theme.of(context).primaryColor))),
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            JsonIntl.of(context)
                                .get(IntlKeys.back)
                                .toUpperCase(),
                            style: Theme.of(context).primaryTextTheme.button))
                  ]);
}
