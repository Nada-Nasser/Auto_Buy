import 'package:auto_buy/blocs/optio_change_notifier.dart';
import 'package:auto_buy/screens/optio/voice_recorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextInputOptio extends StatefulWidget {
  @override
  _TextInputOptioState createState() => _TextInputOptioState();
}

class _TextInputOptioState extends State<TextInputOptio> {
  TextEditingController _textEditingController = TextEditingController();
  VoiceRecorder recorder = VoiceRecorder();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {});
    });
    recorder.initialize();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optio = Provider.of<OptioChangeNotifier>(context, listen: false);
    IconData recordIcon = recorder.isRecording ? Icons.stop : Icons.mic;
    return Container(
      margin: EdgeInsets.fromLTRB(1, 0, 1, 10),
      child: ListTile(
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.transparent),
          child: buildTextInputField(),
        ),
        trailing: IconButton(
          icon: _textEditingController.text.isEmpty
              ? Icon(recordIcon)
              : Icon(Icons.arrow_forward_ios),
          onPressed: () => onClickSendButton(optio),
        ),
      ),
    );
  }

  TextFormField buildTextInputField() {
    return TextFormField(
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
    );
  }

  onClickSendButton(OptioChangeNotifier optio) async {
    if (_textEditingController.text.isNotEmpty) {
      optio.insertUserCommand(input: _textEditingController.text, who: 1);
      _textEditingController.text = "";
    } else {
      if (recorder.isRecording) {
        _textEditingController.text = await recorder.stopRecorder();
        print(_textEditingController.text);
      } else {
        await recorder.record();
      }
    }
    setState(() {});
  }
}
