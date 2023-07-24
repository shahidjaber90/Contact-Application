import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

class SpeectToTextView extends StatefulWidget {
  const SpeectToTextView({super.key});

  @override
  State<SpeectToTextView> createState() => _SpeectToTextViewState();
}

class _SpeectToTextViewState extends State<SpeectToTextView> {
  speechToText.SpeechToText? speech;
  bool isSpeech = false;
  String speechText = '';
  String speechText2 = '';
  List<String> finalText = [];
  String? statusCheck;
  int valss = 0;

  void startListening() async {
    if (!isSpeech) {
      bool avail = await speech!.initialize(
        onStatus: (status) {
          statusCheck = status.toString();
          print('status message: $status');
          isNotListening();
        },
        onError: (val) => print('error message: $val'),
      );

      if (avail) {
        setState(() {
          isSpeech = true;
        });
        speech!.listen(
          onResult: (val) {
            if (valss == 0) {
              setState(() {
                speechText = val.recognizedWords;
                print('speechtext:::: $speechText');
              });
            }
          },
        );
        valss++;
      }
    }
  }

  void isNotListening() async {
    setState(() {
      if (speechText.isNotEmpty) {
        finalText.add(speechText);
        speechText = '';
      }
      finalText.add(speechText2);
      speechText2 = '';
    });
    if (isSpeech == true && statusCheck! == 'done') {
      bool avail = await speech!.initialize(
        onStatus: (status) {
          statusCheck = status.toString();
          print('status message: $status');
        },
        onError: (val) => print('error message: $val'),
      );
      if (avail) {
        setState(() {
          isSpeech = true;
        });
        speech!.listen(
          onResult: (val) {
            setState(() {
              speechText2 = val.recognizedWords;
              print('speechtext 2:::: $speechText2');
            });
          },
        );
      }
    }
  }

  void stop() {
    setState(() {
      isSpeech = false;
    });
    speech!.stop();
  }

  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isSpeech,
          glowColor: Colors.blue.shade200,
          duration: const Duration(milliseconds: 20000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          endRadius: 75.0,
          child: FloatingActionButton(
            onPressed: isSpeech ? stop : startListening,
            child: Icon(isSpeech ? Icons.mic : Icons.mic_off_rounded),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(speechText),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: finalText
                        .map(
                          (item) => Text(
                            item,
                            style: TextStyle(
                              color: Colors.blue.shade300,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
