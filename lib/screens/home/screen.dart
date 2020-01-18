import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'views/barrel.dart';

class HomeScreen extends StatefulWidget {
  final Key todosTabKey;
  final bool integrationTest;

  HomeScreen(
      {Key key = IntegrationTestKeys.homeScreen,
      this.todosTabKey,
      this.integrationTest})
      : super(key: key);
  
  @override 
  _HomeScreenState createState() => _HomeScreenState(todosTabKey, integrationTest);
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.repeats: RepeatsScreen(),
  };
  final Key todosTabKey;
  final bool integrationTest;
  BannerAd _bannerAd;
  bool _bannerShown = false;
  // this has to be a function so that it returns a different route each time
  // the lifecycle of a MaterialPageRoute requires that it not be reused.
  final List<MaterialPageRoute> Function() fabRoutes = () => [
        MaterialPageRoute(
          builder: (context) => RefuelingAddEditScreen(
            isEditing: false,
            onSave: (m, d, a, c, n) {
              BlocProvider.of<RefuelingsBloc>(context)
                  .add(AddRefueling(Refueling(
                mileage: m,
                date: d,
                amount: a,
                cost: c,
                carName: n,
              )));
            },
          ),
        ),
        MaterialPageRoute(
            builder: (context) => TodoAddEditScreen(
                  isEditing: false,
                  onSave: (n, d, m, r, c) {
                    BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
                        name: n,
                        dueDate: d,
                        dueMileage: m,
                        repeatName: r,
                        carName: c,
                        completed: false)));
                  },
                )),
        MaterialPageRoute(
            builder: (context) => RepeatAddEditScreen(
                  isEditing: false,
                  onSave: (n, i, c) {
                    BlocProvider.of<RepeatsBloc>(context).add(AddRepeat(
                        Repeat(name: n, mileageInterval: i, cars: c)));
                  },
                ))
      ];

  _HomeScreenState(
      this.todosTabKey,
      this.integrationTest);

  Widget get actionButton => (integrationTest ?? false)
      ? AutodoActionButton(miniButtonRoutes: fabRoutes, ticker: TestVSync())
      : AutodoActionButton(miniButtonRoutes: fabRoutes);

  @override
  initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    _bannerAd = AutodoBannerAd(
      // listener: (event) {
      //   if (event == MobileAdEvent.loaded) {
      //     setState(() {_bannerShown = true;});
      //   } else if (event == MobileAdEvent.failedToLoad) {
      //     setState(() {_bannerShown = false;});
      //   }
      // }
    )..load()..show();
    super.initState();
  }
  
  @override 
  dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  List<Widget> fakeBottomButtons = [Container(height: 50)];

  @override
  build(context) => BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) => Center(  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Scaffold(
              appBar: AppBar(
                title: Text(AutodoLocalizations.appTitle),
                actions: [ExtraActions()],
              ),
              drawer: NavDrawer(),
              body: views[activeTab],
              floatingActionButton: actionButton,
              bottomNavigationBar: TabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) =>
                    BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
                todosTabKey: todosTabKey,
                refuelingsTabKey: ValueKey('__refuelings_tab_button__'),
                repeatsTabKey: ValueKey('__repeats_tab_button__'),
              ))),
            Container(height: 50, color: Theme.of(context).cardColor),
            ])));
}
