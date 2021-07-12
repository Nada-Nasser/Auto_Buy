import 'package:auto_buy/blocs/optio_change_notifier.dart';
import 'package:auto_buy/services/sound_recording.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:provider/provider.dart';

class TextInputOptio extends StatefulWidget {
  @override
  _TextInputOptioState createState() => _TextInputOptioState();
}

class _TextInputOptioState extends State<TextInputOptio> {
  final TextEditingController _textEditingController = TextEditingController();
  final recorder = SoundRecorder();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(() {setState(() {});});
    recorder.init();
  }
  @override
  void dispose(){
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = recorder.isRecording;
    IconData recordIcon = isRecording? Icons.stop:Icons.mic;
    return Container(
      margin: EdgeInsets.fromLTRB(1, 0, 1, 10),
      child: ListTile(
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.transparent
          ),
          child: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: "Say or Write something!!",
              hintStyle: TextStyle(
                color: Colors.orange,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.orange,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  width: 3,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ),
        trailing: IconButton(
          icon: _textEditingController.text.isEmpty?Icon(Icons.mic):Icon(recordIcon),
          onPressed: () async{
            //TODO: make sure spaces aren't taken into input
            if(_textEditingController.text.isNotEmpty){
              Provider.of<OptioChangeNotifier>(context, listen: false).userCommandInsert(input:_textEditingController.text,who: 1);
              _textEditingController.text = "";
            }else{
              await recorder.toggleRecording();
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}


