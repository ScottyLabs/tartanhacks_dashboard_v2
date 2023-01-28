import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';

class EditTeam extends StatefulWidget {
  @override
  _EditTeamState createState() => _EditTeamState();
}

/*
class OrangeButton extends StatelessWidget{
  String text;
  Function onPressed;

  SolidButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
          shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          elevation: MaterialStateProperty.all(5)
        ),
        child: Text(text,
          style: TextStyle(fontSize:16.0, fontWeight: FontWeight.w600,color:Theme.of(context).colorScheme.onPrimary),
          overflow: TextOverflow.fade,
          softWrap: false,
        )
    );
  }
}*/

class _EditTeamState extends State<EditTeam> {

  final List<Map> _teamMembers = [{'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
                          {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
                          {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"}];
  final String _teamName = "My Team";
  final String _teamDesc = "my team description";
  bool read = true;


  Widget mailIconSelect(bool read){
    if (read){
      return Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    } else {
      return Icon(
          Icons.mark_email_unread,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    }
  }

  Widget _buildTeamHeader(bool read) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("TEAM", style: Theme.of(context).textTheme.headline2),
        mailIconSelect(read)
      ]
    );
  }

  Widget _buildTeamDesc() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_teamName, style: Theme.of(context).textTheme.headline4),
        Text(_teamDesc, style: Theme.of(context).textTheme.bodyText2)
      ]
    );
  }

  Widget _buildMember(int member) {
    String emailStr = "(" + _teamMembers[member]['email'] + ")";
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_teamMembers[member]['name'], style: Theme.of(context).textTheme.bodyText2),
        Text(emailStr, style: Theme.of(context).textTheme.bodyText2)
      ]
    );
  }

  Widget _buildTeamMembers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Team Members", style: Theme.of(context).textTheme.headline4),
        Column(
          children: [
            _buildMember(0),
            _buildMember(1),
            _buildMember(2)
          ]
        )
      ]
    );
  }
  

  Widget _leaveTeamBtn() {
    return (
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
            shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            elevation: MaterialStateProperty.all(5),
            ),
          onPressed: () {  },
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("Leave Team",
            style: TextStyle(fontSize:16.0, fontWeight: FontWeight.w600,color:Theme.of(context).colorScheme.onPrimary),
            overflow: TextOverflow.fade,
            softWrap: false
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return DefaultPage(
      backflag: true,
      reverse: true,
      child:
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
              width: screenWidth*0.9,
              height: screenHeight*0.75,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //height: screenHeight*0.05,
                      child: _buildTeamHeader(read)
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //height: screenHeight*0.2,
                      child: _buildTeamDesc()
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //height: screenHeight*0.05,
                      child: SolidButton(
                          text: "EDIT TEAM NAME AND INFO"
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //height: screenHeight*0.1,
                      child: _buildTeamMembers()
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //height: screenHeight*0.1,
                      child: SolidButton(
                          text: "INVITE NEW MEMBER"
                      )
                    ),
                    _leaveTeamBtn()
                ]
              )
            )
        )
    );
  }
}