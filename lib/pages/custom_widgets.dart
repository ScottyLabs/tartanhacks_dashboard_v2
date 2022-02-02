import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:thdapp/pages/teams_list.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'dart:math';
import 'home.dart';
import 'login.dart';
import 'leaderboard.dart';
import 'project_submission.dart';
import 'sponsors.dart';
import 'bookmarks.dart';
import 'events/index.dart';
import 'profile_page.dart';
import 'checkin.dart';

import 'teams_list.dart';

import 'view_team.dart';
import '../theme_changer.dart';


InputDecoration FormFieldStyle(BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
  );
}
Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
class CurvedTop extends CustomPainter {
  Color color1;
  Color color2;
  bool reverse;
  CurvedTop({this.color1, this.color2, this.reverse = false});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color1
      ..strokeWidth = 15
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[color1, color2],
      ).createShader(!reverse ? Rect.fromLTRB(0, 0, size.width, size.height) : Rect.fromLTRB(size.width, size.height, 0, 0));
    var path = Path();
    double curveHeight = size.height * (0.3);
    path.moveTo(0, curveHeight);
    path.cubicTo(.03*size.width, .17*curveHeight, .97*size.width, .83*curveHeight, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class CurvedBottom extends CustomPainter {
  Color color1;
  Color color2;
  CurvedBottom({this.color1, this.color2});
  @override
  void paint(Canvas canvas, Size size) {
    Color blend = Color.alphaBlend(color2, color1);
    var paint = Paint()
      ..color = color1
      ..strokeWidth = 15
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[color1, color2],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    var path = Path();
    double curveOffset = size.height * (3/5);
    double curveHeight = size.height - curveOffset;
    path.moveTo(0, size.height);
    path.cubicTo(.03*size.width, curveOffset+.17*curveHeight, .97*size.width, curveOffset+.83*curveHeight, size.width, curveOffset);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class CurvedCorner extends CustomPainter {
  Color color;
  CurvedCorner({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, size.height);
    path.cubicTo(.15*size.width, .3*size.height, size.width, size.height, size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class GradBox extends StatelessWidget{
  double width;
  double height;
  double curvature;
  Widget child;
  bool reverse;
  EdgeInsets padding;
  Function onTap;
  Alignment alignment;
  GradBox({this.width, this.height, this.child, this.reverse=false,
    this.padding, this.onTap, this.alignment, this.curvature=25});

  @override
  Widget build(BuildContext context) {
    Color color1 = Theme.of(context).colorScheme.surface;
    Color color2 = Theme.of(context).colorScheme.primaryVariant;
    Color shadow = Theme.of(context).colorScheme.onBackground;
    return Container(
        width: width,
        height: height,
        alignment: alignment==null ? Alignment.center : alignment,
        padding: padding==null ? EdgeInsets.all(10) : padding,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: !reverse ? [color1, color2] : [color2, color1],
            ),
            borderRadius: BorderRadius.circular(curvature),
            boxShadow: [BoxShadow(
                color: shadow,
                offset: Offset(0.0, 5.0),
                blurRadius: 5.0)]
        ),
        child: (onTap==null) ? child : InkWell(onTap: onTap, child: child)
    );
  }
}
class SolidButton extends StatelessWidget{
  String text;
  Function onPressed;
  Widget child;
  Color color;
  Color textColor;

  SolidButton({this.text, this.onPressed, this.child, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).colorScheme.primary;
    } else if (color == Theme.of(context).colorScheme.secondary) {
      textColor = Theme.of(context).colorScheme.onSecondary;
      print("SET COLOR");
    }
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(color),
            backgroundColor: MaterialStateProperty.all(color),
            shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            elevation: MaterialStateProperty.all(5)
        ),
        child: child ?? Text(text,
          style: TextStyle(
              fontSize:16.0,
              fontWeight: FontWeight.w600,
              color: textColor ?? Theme.of(context).colorScheme.onPrimary
          ),
          overflow: TextOverflow.fade,
          softWrap: false,
        )
    );
  }
}

class SolidSquareButton extends StatelessWidget{
  String image;
  Function onPressed;

  SolidSquareButton({this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
            shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            fixedSize: MaterialStateProperty.all<Size>(Size.square(10)),
            elevation: MaterialStateProperty.all(5)
        ),
    );
  }
}

class GradText extends StatelessWidget {
  String text;
  Color color1;
  Color color2;
  double size;
  GradText({this.text, this.size, this.color1, this.color2});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:[color1, color2]
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
class TextLogo extends StatelessWidget {
  Color color;
  double width;
  double height;

  TextLogo({this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    print(height);
    var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
    return Container(
        width: width,
        height: height,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(
                  height: height,
                  width: width*0.20,
                  child: _themeProvider.getTheme==lightTheme ? Image.asset("lib/logos/thLogoDark.png")
                      : Image.asset("lib/logos/thLogoDark.png")
              ),
              Text(" Tartanhacks ",
                  style: TextStyle(
                    fontSize: height*0.4,
                    fontWeight: FontWeight.w600,
                    color: color,
                  )
              )
            ]
        )
    );
  }
}
class MenuButton extends StatelessWidget {
  Function onTap;
  var icon;

  MenuButton({this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    Color color1 = Theme.of(context).colorScheme.background;
    Color color2 = Theme.of(context).colorScheme.surface;
    Color shadow = Theme.of(context).colorScheme.secondaryVariant;
    return Material(
        type: MaterialType.button,
        color: Color(0x00000000),
        child: GradBox(
            width: 55,
            height: 55,
            padding: EdgeInsets.all(0),
            child: Icon(icon ?? Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
                size: 35
            ),
            onTap: onTap
        )
    );
  }
}

class HomeButton extends StatelessWidget {
  bool isSponsor;

  HomeButton(this.isSponsor);

  @override
  Widget build(BuildContext context) {
    Color color1 = Theme.of(context).colorScheme.background;
    Color color2 = Theme.of(context).colorScheme.surface;
    Color shadow = Theme.of(context).colorScheme.secondaryVariant;
    return Material(
        type: MaterialType.button,
        color: Color(0x00000000),
        child: GradBox(
            width: 55,
            height: 55,
            padding: EdgeInsets.all(0),
            child: Icon(Icons.home,
                color: Theme.of(context).colorScheme.onSurface,
                size: 35
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => isSponsor ? Sponsors() : Home(),),
                      (route) => false
              );
            }
        )
    );
  }
}

class FlagPainter extends CustomPainter {
  Color color;
  FlagPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width-(size.height/2), 0);
    Rect arcRect = Rect.fromCircle(center: Offset(size.width-(size.height/2), size.height/2), radius: size.height/2);
    path.arcTo(arcRect, -pi/2, pi, true);
    path.lineTo(0, size.height);
    path.lineTo(0,0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class BackFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 35,
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomPaint(
                    size: Size(80, 35),
                    painter: FlagPainter(color: Theme.of(context).colorScheme.primary),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: DecoratedIcon(Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shadows: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: darken(Theme.of(context).colorScheme.onBackground, 0.01),
                            offset: Offset(3.0, 0),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 22, 0),
                      child: DecoratedIcon(Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shadows: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: darken(Theme.of(context).colorScheme.onBackground, 0.01),
                            offset: Offset(3.0, 0),
                          ),
                        ],
                      )
                  )
                ]
            )
        )
    );
  }
}
class TopBar extends StatelessWidget {
  bool backflag;
  bool isSponsor;
  OverlayEntry _overlayEntry;
  TopBar({this.backflag = false, this.isSponsor = false});
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
            alignment: Alignment.topLeft,
            children: [
              CustomPaint(
                size: Size(screenWidth*0.65, screenHeight*0.2),
                painter: CurvedCorner(color: Theme.of(context).colorScheme.primary),
              ),
              Container(
                  width: screenWidth*0.65,
                  height: screenHeight*0.2,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child:TextLogo(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: screenWidth*0.65,
                      height: screenHeight*0.10
                  )
              ),
              if (backflag)
                Container(
                    width: screenWidth*0.65,
                    height: screenHeight*0.2,
                    alignment: Alignment.bottomLeft,
                    child: BackFlag()
                ),
            ]
        ),
        Container(
            width: screenWidth*0.35,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: backflag ? null : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HomeButton(isSponsor),
                MenuButton(
                    onTap: () {
                      if (isSponsor) {
                        Overlay.of(context).insert(SponsorMenuOverlay(context));
                      } else {
                        Overlay.of(context).insert(MenuOverlay(context));
                      }
                    }
                )
              ]
            )
        )
      ],
    );
  }
}
class WhiteOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /*
    var paint = Paint()
      ..color = Colors.white60
      ..strokeWidth = 15;
    */
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 15
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors:[Colors.white24, Colors.white],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0,0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
OverlayEntry MenuOverlay(BuildContext context) {
  final mqData = MediaQuery.of(context);
  final screenHeight = mqData.size.height;
  final screenWidth = mqData.size.width;
  var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
  OverlayEntry entry;

  entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          entry.remove();
        },
        child: Stack(
            alignment: Alignment.topRight,
            children:[
              CustomPaint(
                  size: mqData.size,
                  painter: WhiteOverlay()
              ),
              Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          Container(
                              width: screenWidth/4,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: MenuButton(
                                  onTap: () {
                                    entry.remove();
                                  },
                                  icon: Icons.close
                              )
                          ),
                        ]
                    ),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              children:[
                                MenuChoice(
                                  icon: Icons.schedule,
                                  text: "Schedule",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            EventsHomeScreen(),
                                        )
                                    );
                                  },
                                ),
                                MenuChoice(
                                  icon: Icons.pages,
                                  text: "Project",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            ProjSubmit(),
                                        )
                                    );
                                  },
                                ),
                                MenuChoice(
                                  icon: Icons.home,
                                  text: "Home",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Home(),
                                        )
                                    );
                                  },
                                ),
                                _themeProvider.getTheme==lightTheme ?
                                MenuChoice(
                                  icon: Icons.mode_night,
                                  text: "Dark",
                                  onTap: () {
                                    _themeProvider.setTheme(darkTheme);
                                    setThemePref("dark", entry, context);
                                  },
                                ) :
                                MenuChoice(
                                  icon: Icons.wb_sunny,
                                  text: "Light",
                                  onTap: () {
                                    _themeProvider.setTheme(lightTheme);
                                    setThemePref("light", entry, context);
                                  },
                                ),
                              ]
                          ),
                          Column(
                            children: [
                              MenuChoice(
                                icon: Icons.people_alt,
                                text: "Team",
                                onTap: () {
                                  entry.remove();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>

                                        ViewTeam(),
                                        settings: RouteSettings(
                                          arguments: "",
                                        )),

                                  );
                                },
                              ),
                              MenuChoice(
                                icon: Icons.qr_code_scanner,
                                text: "Scan",
                                onTap: () {
                                  entry.remove();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          CheckIn(),
                                      )
                                  );
                                },
                              ),
                              MenuChoice(
                                icon: Icons.person,
                                text: "Profile",
                                onTap: () {
                                  entry.remove();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: RouteSettings(name: "profpage"),
                                        builder: (context) => ProfilePage()),
                                  );
                                },
                              ),
                              MenuChoice(
                                  icon: Icons.logout,
                                  text: "Logout",
                                  onTap: () {logOut(entry, context);}
                              ),
                            ],
                          )
                        ]
                    )
                  ]
              ),
            ]
        ),
      )
  );
  return entry;
}

OverlayEntry SponsorMenuOverlay(BuildContext context) {
  final mqData = MediaQuery.of(context);
  final screenWidth = mqData.size.width;

  var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
  OverlayEntry entry;

  entry = OverlayEntry(
      builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            entry.remove();
          },
            child: Stack(
                alignment: Alignment.topRight,
                children:[
                  CustomPaint(
                      size: mqData.size,
                      painter: WhiteOverlay()
                  ),
                  Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Container(
                                  width: screenWidth/4,
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                  child: MenuButton(
                                    onTap: () {
                                      entry.remove();
                                    },
                                    icon: Icons.close,
                                  )
                              ),
                            ]
                        ),
                        SizedBox(height: 10),
                        Container(
                            alignment: Alignment.topRight,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  MenuChoice(
                                    icon: Icons.person,
                                    text: "Home",
                                    onTap: () {
                                      entry.remove();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              Sponsors(),
                                          )
                                      );
                                    },
                                  ),
                                  MenuChoice(
                                    icon: Icons.schedule,
                                    text: "Schedule",
                                    onTap: () {
                                      entry.remove();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              EventsHomeScreen(),
                                          )
                                      );
                                    },
                                  ),
                                  MenuChoice(
                                    icon: Icons.bookmark_outline,
                                    text: "Bookmarks",
                                    onTap: () {
                                      entry.remove();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              Bookmarks(),
                                          )
                                      );
                                    },
                                  ),

                                  _themeProvider.getTheme==lightTheme ?
                                  MenuChoice(
                                    icon: Icons.mode_night,
                                    text: "Dark",
                                    onTap: () {
                                      _themeProvider.setTheme(darkTheme);
                                      setThemePref("dark", entry, context);
                                    },
                                  ) :
                                  MenuChoice(
                                    icon: Icons.wb_sunny,
                                    text: "Light",
                                    onTap: () {
                                      _themeProvider.setTheme(lightTheme);
                                      setThemePref("light", entry, context);
                                    },
                                  ),
                                  MenuChoice(
                                    icon: Icons.logout,
                                    text: "Logout",
                                    onTap: () {logOut(entry, context);},
                                  ),
                                ]
                            )
                        )
                      ]
                  )
                ]
            )
      )
  );
  return entry;
}

void logOut(entry, context) async {
  var prefs = await SharedPreferences.getInstance();
  String theme = prefs.getString("theme");
  await prefs.clear();
  prefs.setString("theme", theme);
  entry.remove();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (ctxt) => new Login()),
          (route) => false
  );
  Provider.of<CheckInItemsModel>(context, listen: false).reset();
}

void setThemePref(theme, entry, context) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("theme", theme);
}

class MenuChoice extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  MenuChoice({this.icon, this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenWidth = mqData.size.width;
    Color color = Theme.of(context).colorScheme.error;
    return Container(
        width: screenWidth/4,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            children: [
              RawMaterialButton(
                onPressed: onTap,
                elevation: 2.0,
                fillColor: color,
                child: Icon(
                  icon,
                  size: 40.0,
                  color: Theme.of(context).colorScheme.onError,
                ),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              ),
              Text(text,
                style: TextStyle(
                    color: color,
                    fontSize: 14
                ),
              )
            ]
        )
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);

    return Scaffold(
        body: Container(
            height: screenHeight,
            width: screenWidth,
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                      height: screenHeight*0.35,
                      width: screenWidth,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Image.asset("lib/logos/thLogoDark.png")
                  ),
                  Text("Tartanhacks",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text("by Scottylabs",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 25),
                  CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,)
                ]
            )
        )
    );
  }
}

class WhiteOverlayLight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0,0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

OverlayEntry LoadingOverlay(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return OverlayEntry(
      builder: (context) => Positioned(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                  size: screenSize,
                  painter: WhiteOverlayLight()
              ),
              Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error,)
              )
            ],
          )
      )
  );
}

void errorDialog(context, String title, String response) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: new Text(title, style: Theme.of(context).textTheme.headline1),
        content: new Text(response, style: Theme.of(context).textTheme.bodyText2),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
            child: new Text(
              "OK",
              style: Theme.of(context).textTheme.headline4,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}