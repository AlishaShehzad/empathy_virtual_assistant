import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInputTextEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SpeechToText speechToTextInstance = SpeechToText();
  String recordedAudioString = "";
  bool isLoading = false;

  String _speechResult = '';

  initializeSpeechToText() async {
    await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    recordedAudioString = recognitionResult.recognizedWords;
    print(recordedAudioString);
    setState(() {
      _speechResult = recordedAudioString;
      userInputTextEditingController.text = _speechResult;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF090D1D),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset("images/sound on.png"),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.dehaze, size: 40, color: Colors.white)),
          backgroundColor: const Color(0xFF090D1D),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Image.asset(
                    "images/logo.png",
                  ),
                ),
                const SizedBox(
                  height: 150,
                  width: 380,
                  child: Text(
                    "Empathy is here to support you on your path to mental well-being, whether you're looking for counseling sessions, advice on your mental well-being, or ingenious conversation, Empathy provides support to encounter the issues you’re facing over your mental health and helps you to cope up with your psychological distress.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white, // Set the text color with hex code
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextField(
                          controller: userInputTextEditingController,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "how can I help you?",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //button
                    InkWell(
                      onTap: () {
                        //print("send user input");
                      },
                      child: AnimatedContainer(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                              shape: BoxShape.rectangle, color: Colors.deepPurpleAccent),
                          duration: const Duration(
                            milliseconds: 1000,
                          ),
                          curve: Curves.bounceInOut,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: InkWell(
                      onTap: () {
                        speechToTextInstance.isListening ? stopListeningNow() : startListeningNow();
                      },
                      child: speechToTextInstance.isListening
                          ? Center(
                              child: LoadingAnimationWidget.beat(
                                size: 100,
                                color: speechToTextInstance.isListening
                                    ? Colors.deepPurple
                                    : isLoading
                                        ? Colors.deepPurple[400]!
                                        : Colors.deepPurple[200]!,
                              ),
                            )
                          : Image.asset(
                              "images/mic.png",
                              height: 100,
                              width: 100,
                            ),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
