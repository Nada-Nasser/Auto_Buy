import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_speech/config/recognition_config.dart';
import 'package:google_speech/google_speech.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_stream/sound_stream.dart';

class VoiceRecorder {
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  final RecorderStream _recorder = RecorderStream();

  // StreamSubscription<List<int>> _audioStreamSubscription;
//  BehaviorSubject<List<int>> _audioStream;

  get isRecording => _myRecorder.isRecording;

  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
        encoding: AudioEncoding.AMR_WB,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'ar-EG',
      );

  void initialize() {
    _myRecorder.openAudioSession();
    _recorder.initialize();
  }

  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myRecorder.closeAudioSession();
    _myRecorder = null;
  }

  Future<void> record() async {
    // Request Microphone permission if needed
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");

    _myRecorder.setAudioFocus(focus: AudioFocus.requestFocusAndStopOthers);

    await _myRecorder.startRecorder(
      toFile: "command_voice",
      codec: Codec.amrWB,
      sampleRate: 16000,
    );
  }

  Future<String> stopRecorder() async {
    String anURL = await _myRecorder.stopRecorder();
    String output = await _recognize(anURL);
    return output;
  }

  ///******************************************************************///
  ///GOOGLE CLOUD SECTION
  Future<String> _recognize(String path) async {
    String text;
    final serviceAccount = ServiceAccount.fromString(r'''{
  "type": "service_account",
  "project_id": "auto-buy-e8bc2",
  "private_key_id": "39d9e269b86ae8725e0348ec73c3bbfc15592a27",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDAl2xEOA0rLLA8\n9vKMnZxCkNzffID1S21mOCzWlc9rfvzdkwK3DZ3WPwh+7Zs3qboojRaOZjbY72JS\nwjsvc9mJfaBZla8fR9Uv5uecllAmyRxEvAzUj+O3tK09ri4hOc0H13uk2UoaPOk+\n6tVMwXLhBc/6HUk2By1XLc6vjLZBuWUsFyqcy36Xs5D5hOBU5EILQPm4RrdmmLs8\n1q2XBcUi3UcwERecQAH7xfsXFvXfdH/pUA/SqChj4qM/A+mw3C7z1fUdPDn//VrJ\nsOUH6YjiVDgRKolOKlemuZ5EleY6XIvyLYQPnpvh9XvvoTqXE//0Pi6p3++fVxyU\nYtyk0MtPAgMBAAECggEAC/8JAf4Em/h01dqDMZngeA9liRCZSJSbl0icFy9OGm6j\nhsdRRC1RJ11vxKNwp3jA0FieQhDapvKdfkHI+MpPj45HfnnVABUz+BlHutI5SRRk\npWEAfGQ/ryhOIWk7FSi9I7Ln0CHhlfbOh8COHr5uztagC/7mme3vUUULx2JaOLrp\n6Wphq4W7YosTZxl8kRH4DfiJBszKcHEjG0shRGHD6MVWvYjnG4fdmS4/raejs97o\nM4eM3JPdgYa0SqMtb68eZzM7UhoPiWFih7D90xOfhbkwXOe13j1tCYzfAsXINjyA\n6PKD8CkXD7IjJic5d9aNq/ENGvoK/ZfGrVpfQ38aAQKBgQD8QlsL4OeSrPaKW60D\nycnHKy7ccVPYTW6fkS7+IuwYAsRGN1mjL0uTQ0XpRA/uKaP24Ge1UyAJaA159nHy\nxxKgnq0tgBgWbRJro7sP90Wru04cdy1XSs7fw07ckKAvnp9HxZwbujAms0EQ8BKy\n6yuwX92yoiunfRK2HCUR/PkVAQKBgQDDco1usmVM/UJtvZUB0lj1KoJ7CNnVrVCq\njMx8oBJIfYWc3f+4elBiXRoVt+3FzmjLNJho43+DBXOxu/4C7MM95EbcbPR52XkL\nJn3yNXx7M2VmAkLBozpAZyQ75kE0xQ8Ox0zb19gWVroo1QpId5elDJL9PRmQAuN4\nJWv4nmNQTwKBgGFRLBS6EDx6s6YO1gFnIIvQsgRjSAhjXvD6LpnmWRSuRJAeHFuj\nDFHkmxzxn/+uWs4MJpZCWlKmrMRHehBCEoKalI7AIwrLy1ZxVOJE78DfwrOimoBZ\noNOcYlkfBl04oZQrvRzJSHg1oT1qkJwrs7AYW8vlWlgEHWraEscMw/8BAoGAKeEy\n8yRg1oVyJYe5FSHYk/ge63QzETlJDrKK4q1+HXBgIAPl1sbG0Lz4aOz3kyouhFRp\n0Bfna9DQQKZywHexQmLW2Ea0gCOcb0o5NJxHZzLVKG2Vll5+jexL9FXbZQ5Qsq78\nBiOTFv5Qd41m3a5anTA7ku3zu0sTKNyD7UsrJrsCgYBrO7L0V+sjHFSIJaDgoKrT\nppCTHTGGvu78xDb95uxi2HTif+9gbDfLP5sOGWs9v4Euo5IEI25u29M+1tw9RfHR\nbbSAnsympdJ5Pot8mwnjnpQkRphGVkGjo9p6Rjg3Tgc3Rs5anwW9m9DquvtvGWJP\nGchKOxcl4fUlh0wmNGgQrQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "auto-buy-e8bc2@appspot.gserviceaccount.com",
  "client_id": "104117970522921498160",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/auto-buy-e8bc2%40appspot.gserviceaccount.com"
}
  ''');
    // final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final speechToText = SpeechToTextBeta.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent(path);
    await speechToText.recognize(config, audio).then((value) {
      text =
          value.results.map((e) => e.alternatives.first.transcript).join('\n');
    });

    print("Recognized Text : $text");

    return text;
  }

  Future<List<int>> _getAudioContent(String name) async {
    return File(name).readAsBytesSync().toList();
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    // await _audioStreamSubscription?.cancel();
    //  await _audioStream?.close();
  }
}
