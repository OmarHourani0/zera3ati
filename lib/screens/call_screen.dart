import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:twilio_programmable_video/twilio_programmable_video.dart';
// import 'package:bloc/bloc.dart';
// import 'package:http/http.dart';

const String appId = '7b3cd04a567540fdab2dccc136b7c628';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String channelName = "CallToken";
  String token =
      "007eJxTYPDql0o8ohKUdi4mpfORh2zqelmjd3fyTjY0LVnhttT74FcFBvMk4+QUA5NEUzNzUxODtJTEJKOU5ORkQ2OzJPNkMyOLrC1/UxoCGRlMSkqYGRkgEMTnZHBOzMkJyc9OzWNgAAAPNyIS";

  int uid = 1; // uid of the local user

  late Future<void> _engineInitialization;

  int? _remoteUid = 2; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  Future<void> initializeAgoraEngine() async {
    agoraEngine = await createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));
    // Add other necessary setup here
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  // Define the _buildUI method to build your UI
  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black12, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background_dark.jpg'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              // Container for the local video
              Container(
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 72, 95, 105),
                ),
                child: Center(
                  child: _localPreview(),
                ),
              ),
              const SizedBox(height: 10),
              //Container for the Remote video
              Container(
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 72, 95, 105),
                ),
                child: Center(
                  child: _remoteVideo(),
                ),
              ),
              // Button Row
              SizedBox(height: 18),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.phone_in_talk),
                      label: const Text(
                        "Join",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _isJoined ? null : () => {join()},
                      style: ButtonStyle(
                        enableFeedback: true,
                        elevation: MaterialStatePropertyAll(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.phone_disabled,
                        color: Color.fromARGB(255, 225, 137, 131),
                      ),
                      label: const Text(
                        "Leave",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _isJoined ? () => {leave()} : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          const Color.fromARGB(255, 163, 44, 35),
                        ),
                        enableFeedback: true,
                        elevation: MaterialStatePropertyAll(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get started with Video Calling'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_dark.jpg'),
                fit: BoxFit.cover),
          ),
          child: FutureBuilder(
            future: _engineInitialization,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // The initialization is complete, you can now build your UI
                return _buildUI();
              } else if (snapshot.hasError) {
                // Handle initialization errors here
                return Center(
                  child: Text("Error initializing Agora Engine"),
                );
              } else {
                // Show a loading indicator while initialization is in progress
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      );
    }
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        onAgoraVideoViewCreated: (viewId) async {
          // retrieve or request camera and microphone permissions
          await [Permission.microphone, Permission.camera].request();

          //create an instance of the Agora engine
          agoraEngine = createAgoraRtcEngine();
          await agoraEngine.initialize(const RtcEngineContext(appId: appId));

          await agoraEngine.enableVideo();

          // Register the event handler
          agoraEngine.registerEventHandler(
            RtcEngineEventHandler(
              onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
                // showMessage(
                //     "Local user uid:${connection.localUid} joined the channel");
                setState(() {
                  showMessage(
                      "Local user uid:${connection.localUid} joined the channel");
                  _isJoined = true;
                });
              },
              onUserJoined:
                  (RtcConnection connection, int remoteUid, int elapsed) {
                showMessage("Remote user uid:$remoteUid joined the channel");
                setState(() {
                  _remoteUid = remoteUid;
                });
              },
              onUserOffline: (RtcConnection connection, int remoteUid,
                  UserOfflineReasonType reason) {
                showMessage("Remote user uid:$remoteUid left the channel");
                setState(() {
                  _remoteUid = null;
                });
              },
            ),
          );
        },
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
          useAndroidSurfaceView: true,
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
  }

  // Widget _status() {
  //   String statusText;

  //   if (!_isJoined)
  //     statusText = 'Join a channel';
  //   else if (_remoteUid == null)
  //     statusText = 'Waiting for a remote user to join...';
  //   else
  //     statusText = 'Connected to remote user, ui:$_remoteUid';

  //   return Text(
  //     statusText,
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Set up an instance of Agora engine
  //   setupVideoSDKEngine();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize Agora engine
  //   initializeAgoraEngine().then((_) {
  //     setState(() {});
  //   });
  // }
  @override
  void initState() {
    super.initState();
    // Initialize Agora engine
    _engineInitialization = initializeAgoraEngine();
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
      //isInteractiveAudience: true,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );

    // Set video encoder configuration after joining
    await agoraEngine.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 15,
          orientationMode: OrientationMode
              .orientationModeFixedPortrait //VideoOutputOrientationMode.FixedPortrait,
          ),
    );

    await agoraEngine.enableLocalVideo(true);

    await agoraEngine.enableInstantMediaRendering();

    await agoraEngine.enableVideo();

    await agoraEngine.enableSoundPositionIndication(true);

    await agoraEngine.enableDualStreamMode(enabled: true);

    await agoraEngine.getConnectionState();

    setState(() {
      _isJoined = true;
    });
  }
  // Future<void> setupVoiceSDKEngine() async {
  //   // retrieve or request microphone permission
  //   await [Permission.microphone].request();

  //   //create an instance of the Agora engine
  //   agoraEngine = createAgoraRtcEngine();
  //   await agoraEngine.initialize(const RtcEngineContext(appId: appId));

  //   await agoraEngine.setChannelProfile(ChannelProfileType
  //       .channelProfileLiveBroadcasting); //ChannelProfile.LiveBroadcasting);

  //   // Register the event handler
  //   agoraEngine.registerEventHandler(
  //     RtcEngineEventHandler(
  //       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
  //         showMessage(
  //             "Local user id:${connection.localUid} joined the channel");
  //         setState(() {
  //           _isJoined = true;
  //         });
  //       },
  //       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
  //         showMessage("Remote user id:$remoteUid joined the channel");
  //         setState(() {
  //           _remoteUid = remoteUid;
  //         });
  //       },
  //       onUserOffline: (RtcConnection connection, int remoteUid,
  //           UserOfflineReasonType reason) {
  //         showMessage("Remote user id:$remoteUid left the channel");
  //         setState(() {
  //           _remoteUid = null;
  //         });
  //       },
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Set up an instance of Agora engine
  //   setupVoiceSDKEngine();
  // }

  // Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  showMessage(String message) {
    setState(() {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
    // scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    //   content: Text(message),
    // ));
  }
}
