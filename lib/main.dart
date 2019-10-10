import 'package:flutter/material.dart';
import 'package:thesis_schedule/services/schedule_service.dart';
import 'package:thesis_schedule/models/thesis_schedule.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.amber,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePage> {
  List<ThesisSchedule> _schedules = [];
  String _query = "";
  bool _reversed = false;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _refreshSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Thesis Schedule Viewer"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_vert),
            onPressed: () {
              this.setState(() { _reversed = !_reversed; });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 12.0),
            child: TextField(
              onChanged: (text) => this.setState(() { _query = text.toLowerCase(); }),
              decoration: InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      )
                  ),
                  fillColor: Colors.white,
                  hintText: "Search",
                  contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    )
                  ),
              ),
            ),
          ),
          _loadingProgress(context, _isLoading),
          _errorView(context, _isError),
          Expanded(
            child: _scheduleList(context),
          ),
        ],
      ),
    );
  }
  
  Widget _loadingProgress(BuildContext context, bool active) {
    if(active) {
      return LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        value: null,
      );
    } else {
      return Container();
    }
  }

  Widget _errorView(BuildContext context, bool active) {
    if(active) {
      return Container(
        padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        child: Text(
          "Failed to fetch data from Bimay.\nPull to refresh to try again.",
          style: TextStyle(
            color: Color.fromARGB(255, 79, 0, 0),
          ),
        ),
        color: Color.fromARGB(255, 255, 186, 186),
      );
    } else {
      return Container();
    }
  }

  Widget _scheduleList(BuildContext context) {
    final theme = Theme.of(context);
    final rawSchedules = _reversed ? (_schedules ?? []).reversed : (_schedules ?? []);
    final schedules = rawSchedules
      .where((schedule) {
        final nameMatches = schedule.nmmhs.toLowerCase().trim().contains(_query);
        final nimMatches = schedule.getNim().toLowerCase().trim().contains(_query);
        final topicMatches = schedule.nmTopik.toLowerCase().trim().contains(_query);
        final titleMatches = schedule.judul.toLowerCase().trim().contains(_query);
        return nameMatches || nimMatches || topicMatches || titleMatches;
      })
      .toList();
    return RefreshIndicator(
      onRefresh: _refreshSchedules,
      child: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        schedules[index].nmmhs.trim(),
                        style: theme.textTheme.subhead,
                      ),
                      Text(
                        schedules[index].getNim().trim(),
                        style: theme.textTheme.body2,
                      ),
                      Text(
                        schedules[index].nmTopik.trim(),
                      ),
                      Text(
                        schedules[index].judul.trim(),
                        style: theme.textTheme.body1.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        schedules[index].kampus.trim(),
                        style: theme.textTheme.body2,
                      ),
                    ],
                  ),
                  flex: 1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      schedules[index].ruang.trim(),
                    ),
                    Text(
                      schedules[index].tanggal,
                    ),
                    Text(
                      "${schedules[index].getShortStartTime()} - ${schedules[index].getShortEndTime()}",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshSchedules() async {
    this.setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      final schedules = await ScheduleService.instance.getSchedules();
      this.setState(() {
        _schedules = schedules;
        _isLoading = false;
        _isError = false;
      });
    } catch (error) {
      this.setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }
}