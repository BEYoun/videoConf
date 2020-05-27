import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet_example/no-glow-effect.scroll-behavior.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final serverText = TextEditingController(text: "https://joona.icu");
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor = TextEditingController(text: "#FF");//transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(52, 58, 64, 1),
//        dividerColor: Colors.deepPurpleAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text('Joona.icu'),
          actions: <Widget>
          [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {  },
            ),
          ],
        ),
        body: Row(
          children: <Widget>
          [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowEffectScrollBehavior(),
                child: SingleChildScrollView(
                  child: SizedBox(
                    //height: MediaQuery.of(context).size.height * 0.85,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10 * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>
                        [
                          Column(
                            children: <Widget>
                            [
                              Text('Joona.icu', style: TextStyle(fontFamily: "Segoe UI", fontSize: 30),),
                              Text('Adoptez la visio-facilité', style: TextStyle(fontFamily: "Segoe UI", fontSize: 15),),
                            ],
                          ),
                          Image(image: AssetImage('assets/images/base-main-logo.png'),),
                          TextFormField(
                              decoration: InputDecoration(hintText: 'Entrez un nom de conference'),
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: (term){
                              }
                          ),
                          RaisedButton(
                            onPressed: (){
                              _joinMeeting();
                            },
                            child: Text('Commencer'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(options,
          listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
            debugPrint("${options.room} will join with message: $message");
          }, onConferenceJoined: ({message}) {
            debugPrint("${options.room} joined with message: $message");
          }, onConferenceTerminated: ({message}) {
            debugPrint("${options.room} terminated with message: $message");
          }));
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
