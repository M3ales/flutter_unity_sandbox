import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityWrapper extends StatefulWidget {
  @override
  _UnityWrapperState createState() => _UnityWrapperState();
}

class _UnityWrapperState extends State<UnityWrapper> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Unity Flutter Demo'),
      ),
      body: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessage,
              onUnitySceneLoaded: onUnitySceneLoaded,
              fullscreen: false,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text("Rotation speed:"),
                    ),
                    Slider(
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        setRotationSpeed(value.toString());
                      },
                      value: _sliderValue,
                      min: 0,
                      max: 20,
                    ),
                    TextButton(
                        key: const Key("Start"),
                        onPressed: pressStart,
                        child: const Text("Start")),
                    BackButton(
                      key: const Key("Close"),
                      color: Colors.red,
                      onPressed: pressClose,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Communcation from Flutter to Unity
  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  Future<void> pressClose() async {
    print("Press Close");
    var isLoaded = await _unityWidgetController.isLoaded();
    if (isLoaded != null && isLoaded) {
      print("Attempting to unload");
      // await _unityWidgetController.unload();
      Navigator.of(context).pop();
    } else {
      print("Not Loaded");
    }
    await PrintDebug();
  }

  Future<void> pressStart() async {
    print('Pressed Start');
    var isLoaded = await _unityWidgetController.isLoaded();
    var isPaused = await _unityWidgetController.isPaused();
    if(isPaused != null && isPaused) {
      await _unityWidgetController.resume();
    }
    if (isLoaded != null && !isLoaded) {
      print("Creating");
      var result = await _unityWidgetController.create();
      print('Unity Create Result: ' + result.toString());
      if (result != null && result) {
        await _unityWidgetController.pause();
        await _unityWidgetController.resume();
      } else {
        print("Failed to create");
      }
    } else {
      print("Loaded Already");
    }
    await PrintDebug();
  }

  Future<void> PrintDebug() async {
    print("-----\nController Debug\n-----");
    print("isLoaded: " + (await _unityWidgetController.isLoaded()).toString());
    print("isPaused: " + (await _unityWidgetController.isPaused()).toString());
    print("isReady: " + (await _unityWidgetController.isReady()).toString());
    print("inBackground: " +
        (await _unityWidgetController.inBackground()).toString());
    print("-----\nEnd Controller Debug\n-----");
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
    PrintDebug();
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
    PrintDebug();
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    print('Received scene loaded from unity: ${sceneInfo?.name}');
    print(
        'Received scene loaded from unity buildIndex: ${sceneInfo?.buildIndex}');
    PrintDebug();
  }
}
