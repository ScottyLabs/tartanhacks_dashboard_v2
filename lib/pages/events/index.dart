import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/event.dart';
import 'package:thdapp/pages/events/edit.dart';
import 'new.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom_widgets.dart';
import 'package:share/share.dart';

class EventsHomeScreen extends StatefulWidget {
  @override
  _EventsHomeScreenState createState() => new _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
  SharedPreferences prefs;

  bool isAdmin = false;

  bool isSponsor = false;
  List eventData = [1, 2, 3, 4, 5];

  bool viewPast = false;
  int selectedIndex = 1;

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAdmin = prefs.getBool("admin");
    isSponsor = prefs.getString("company") != null;
    setState(() {});
  }

  Widget eventName(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          text: '${data.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'TerminalGrotesque'),
        )));
  }

  // description for the event
  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: RichText(
                text: TextSpan(
              text: '\n${data.description}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ))));
  }

  String formatDate(String unixDate) {
    var date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  Widget eventTime(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${getTime(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TerminalGrotesque'),
          ),
          Text(
            '${formatDate(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.5,
                fontFamily: 'TerminalGrotesque'),
          ),
        ]);
  }

  // hyperlinked button for the event
  Widget zoomLink(data) {
    if (data.access_code == 2) {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/hopinLogo.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else if (data.access_code == 1) {
      return IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 25,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/discordLogoWhite.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    }
  }

  Widget shareLink(data) {
    return IconButton(
      icon: Icon(
        Icons.share,
        color: Colors.white,
        size: 25,
      ),
      tooltip: 'Share Link!',
      color: Color.fromARGB(255, 37, 130, 242),
      onPressed: () {
        String text = 'Join ${data.name} at ' + '${data.zoom_link}';
        final RenderBox box = context.findRenderObject();
        Share.share(text,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Scaffold(
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TopBar(
                  isSponsor: isSponsor,
                ),
                Stack(
                  children: [
                    Column(children: [
                      SizedBox(height: screenHeight * 0.05),
                      CustomPaint(
                          size: Size(screenWidth, screenHeight * 0.75),
                          painter: CurvedTop(
                              color1: Theme.of(context).colorScheme.primary,
                              color2: Theme.of(context).colorScheme.secondaryVariant)),
                    ]),
                    //create new event button
                    Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SolidButton(
                        text: viewPast ? "View Upcoming Events" : "View Past Events",
                        onPressed: () {
                          setState(() {
                            viewPast = !viewPast;
                          });
                        },
                      ),
                      SizedBox(height: 5),
                      if (isAdmin)
                        GradBox(
                          width: screenWidth * 0.9,
                          height: 60,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditEventPage(null, editable: isAdmin,)),
                            );
                          },
                          child: Text(
                            "CREATE NEW EVENT",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(25, 10, 25, 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
                            child: FutureBuilder(
                              future: getEvents(),
                              builder: (context, eventsSnapshot) {
                                if (eventsSnapshot.data == null ||
                                    eventsSnapshot.hasData == null) {
                                  return ListView.builder(
                                    itemCount: 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Center(child: CircularProgressIndicator());
                                    },
                                  );
                                }
                                return ListView.builder(
                                  itemCount: (eventsSnapshot.data[viewPast?1:0]).length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return EventsCard(
                                        (eventsSnapshot.data[viewPast?1:0])[index], isAdmin);
                                  },
                                );
                              },
                            ),
                          ))
                    ]),
                  ],
                )
              ],
            )
        )
    );
  }
}

class PlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: GradBox(
            width: 100,
            height: 200,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            "Loading",
                            style: Theme.of(context).textTheme.headline2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ]),
              ],
            )));
  }
}

class EventsCard extends StatelessWidget {
  final Event event;
  final bool isAdmin;

  EventsCard(this.event, this.isAdmin);

  String formatDate(String unixDate) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(unixDate));
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(unixDate));
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  void confirmDialog(BuildContext context) {
    bool confirmed = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: new Text("Confirmation",
              style: Theme.of(context).textTheme.headline1),
          content: new Text("Are you sure you want to delete this event?",
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text(
                "Cancel",
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(
                "OK",
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                confirmed = true;
                deleteEvent(event.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsHomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _launchLink(BuildContext context) async {
    String url = event.platformUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialog(context, "Error", 'Could not launch event url.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: GradBox(
            width: 100,
            height: 250,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: Theme.of(context).textTheme.headline2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth*0.5,
                      height: 160,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event.description,
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (event.platform == 'IN_PERSON')
                              Text(
                                "IN PERSON: " + event.location,
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.ellipsis,
                              )
                            else
                                Text(
                                  "${event.platform}:",
                                  style: Theme.of(context).textTheme.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            if(event.platformUrl!="")
                              SolidButton(
                                    child: Icon(Icons.link,
                                        color:
                                        Theme.of(context).colorScheme.onPrimary,
                                        size: 35),
                                    onPressed: () {
                                      _launchLink(context);
                                    },
                              ),
                            if (isAdmin)
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SolidButton(
                                      text: "Edit",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEventPage(this.event, editable: isAdmin,)),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SolidButton(
                                      text: "Delete",
                                      color: Theme.of(context).colorScheme.secondary,
                                      onPressed: () => confirmDialog(context),
                                    ),
                                  ])
                            else
                              SolidButton(
                                text: "View Details",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditEventPage(this.event, editable: isAdmin,)),
                                  );
                                },
                              ),
                          ]),
                    ),
                    SizedBox(width: 5),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: screenWidth * 0.265,
                              height: 160,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Text(
                                      this.getTime((event.startTime).toString()) +
                                          "\n" +
                                          this.formatDate(
                                              (event.startTime).toString()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      textAlign: TextAlign.center)))
                        ]
                    )
                  ],
                )
              ],
            )
        )
    );
  }
}
