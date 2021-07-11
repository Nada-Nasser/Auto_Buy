import 'dart:convert';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder _myRecorder;
  bool _isRecorderInit = false;

  bool get isRecording => _myRecorder.isRecording;

  Future<void> _record() async {
    if(_isRecorderInit == false) return;
    print('is recording');
    await _myRecorder.startRecorder(
      toFile: '/root/sdk_gphone_x86/Android/data',
    );
  }

  Future<void> _stopRecorder() async {
    if(_isRecorderInit==false) return;
    print('stopped recording');
    await _myRecorder.stopRecorder();
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
}