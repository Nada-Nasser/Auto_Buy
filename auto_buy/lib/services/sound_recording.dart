import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SoundRecorder {
  FlutterSoundRecorder _myRecorder;
  bool _isRecorderInit = false;
  dynamic _recorderSubscription;
  String recordPath;
  bool get isRecording => _myRecorder.isRecording;

  Future<void> _record() async {
    if(_isRecorderInit == false) return;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    recordPath = '$tempPath/record1.mp3';
    print('is recording');
    await _myRecorder.startRecorder(
      toFile: recordPath,
    );
  }

  Future<void> _stopRecorder() async {
    if(_isRecorderInit==false) return null;
    print('stopped recording');
    await _myRecorder.stopRecorder();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    recordPath = '$tempPath/record1.mp3';
    File f = File(recordPath);
    print(f.readAsBytesSync().toList());
  }

  Future<void> toggleRecording()async{
    if(_myRecorder.isStopped)
    {
      await _record();
    }else{
      await _stopRecorder();
    }
  }

  void init() async{
    _myRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException("Microphone permission needed");
    }
    await _myRecorder.openAudioSession();
    _isRecorderInit = true;
  }

  void dispose(){
    if(!_isRecorderInit) return;
    print('dispose');
    _myRecorder.closeAudioSession();
    _myRecorder = null;
    _isRecorderInit = false;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/counter.txt');
  }


    Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}

