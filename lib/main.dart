import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:notefear/main_screan.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
int total = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MainScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Noteify'))),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Container(
              height: 180.0,
              width: 180.0,
              child: FittedBox(
                child: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Construct the path where the image should be saved using the
                      // pattern package.
                      //    final path = join(
                      // Store the picture in the temp directory.
                      // Find the temp directory using the `path_provider` plugin.
                      //    (await getTemporaryDirectory()).path,
                      //     '${DateTime.now()}.png',
                      //   );

                      // Attempt to take a picture and log where it's been saved.
                      final  path=await _controller.takePicture();
                      print("path is ${path.path}");
                      // If the picture was taken, display it on a new screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(path.path),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  DisplayPictureScreen(this.imagePath);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List ? op;
  Image ? img;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    img = Image.file(File(widget.imagePath));
    classifyImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
//    Image img = Image.file(File(widget.imagePath));
//    classifyImage(widget.imagePath, total);

    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: img)),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> runTextToSpeech(String outputMoney, int totalMoney) async {
    FlutterTts flutterTts;
    flutterTts = new FlutterTts();

    if (outputMoney == "عشرين جنيها") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "20 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "عشرة جنيهات") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "10 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "خمسة جنيهات") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "5 pounds, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "جنيه واحد") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "1 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "خمسون جنيها") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "50 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "مائة جنيه") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "100 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }

    if (outputMoney == "ماتين جنيه") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "200 pounds, Your total is now pounds, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
  }
  classifyImage(String image) async {
    var output = await Tflite.runModelOnImage(
      path: image,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output);
    op = output;

    if (op != null) {
      if (op![0]["label"] == "جنيه واحد") {
        total += 50;
        runTextToSpeech("جنيه واحد", total);
      }
      if (op![0]["label"] == "خمسة جنيهات") {
        total += 100;
        runTextToSpeech("خمسة جنيهات", total);
      }
      if (op![0]["label"] == "عشرة جنيهات") {
        total += 200;
        runTextToSpeech("عشرة جنيهات", total);
      }
      if (op![0]["label"] == "عشرين جنيها") {
        total += 500;
        runTextToSpeech("عشرين جنيها", total);
      }
      if (op![0]["label"] == "خمسون جنيها") {
        total += 2000;
        runTextToSpeech("خمسون جنيها", total);
      }
      if (op![0]["label"] == "مائة جنيه") {
        total += 2000;
        runTextToSpeech("مائة جنيه", total);
      }
      if (op![0]["label"] == "ماتين جنيه") {
        total += 2000;
        runTextToSpeech("ماتين جنيه", total);
      }

    } else
      runTextToSpeech("No note found", total);
  }
  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}