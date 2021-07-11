import 'dart:html';

import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';

class OptioServices {
    final serviceAccount = ServiceAccount.fromString(r'''{
      "type": "service_account",
      "project_id": "auto-buy-e8bc2",
      "private_key_id": "21653f74021bcb3b84b7ff95fdff0289953447d3",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrpA+d7ga0wkUe\nQg7GWdVEskhMW0Hk7uLnX89STnYWTt4kitJUMFw+unM3AlcXQPglU/mpTGXxN9zH\nICTH5e3fqPQ04Q2UivNnrva26dWylB5RKmCfyjcrvnqHCa/fIg+WaTZ/1hVZnMy+\nzSSmsd6yID06B3HVhwMtGj/3MLO/G4f/J0y13Xg24oYLdOKWO20vBvfFJz6WOypy\nhNwLgsRBuKd6jYU8lSeOrfmDLsj2Bc8Fi2fodifAZya0IyTzhAdZU+gOcGhIcqej\nm9vXrWozL/D9oqTrmxdfn0K1gxO24fY2IOCzqNox8YX3YzyPMgsv7i5x8m93eHIZ\nxrak9CeDAgMBAAECggEABK76OGZs5rSlOQlJjVm9my+zWMRTkWftnj/JmeI1EGdX\nGQHh3146c9zg3j1l0mcwS/IsF0NmIUoKXaEyDXN6JVSDwNEP3F/IjRdxZtYNeLrY\nPF0H8xRC7JAUBh9IHiABPE91gqyhqRSc0H29rW2f8APJw1a9zwRbQPk8906i5rII\nutC7HcpDRSbU+Miq9SbR+3hwR8ByGhSkVtvKZQFyjd9OlIrGkd5suvEJqGkpBK23\noX+NFh5UhR06o4Px1uDCFA6DkfFt30Mx9Skwvt2nuS4LDoPnQxQrg/fuHxxvlDIC\nlPvr1mGyw/PiyIA5OXzWn2KVUvrZtLKh1luB9xyn4QKBgQDgJDrJnZFxhdDh2kC8\nIgHU+RlYpMtP4LUgTwjlOFVkQtxCbpaBqzpq/B30MSFD9Pm/HHHNkpPVySQNE3cZ\n05LKtJuQwB6wzpUCbczJKHOpplafWTzVcEm0MniE1uVWFvpf4Y1eos7rBkh76sI4\nq1oWZ5+PDrbYQHzOpvOQ3l22eQKBgQDECYFxWd5XWcV3QYiwW4L48OigXfmWFTUe\nNfPzxBt7fyWK+9HB6TsyqbR1rElGpyn1HCOUspFTjwqHQjrMgpeRRhzjcxGmsHrG\nvTDXCujOaziAuKEGuKDQZ0T0Z8Jz9APm972PO8g5NepAwrMClOU7tsBjxoQCmpxN\nnnptgmX+2wKBgB75wsoUJYJ7zMc5o1KcnIYzOqZ+d759PmrNoVwUMfDeMJRZtiEL\nadJZL0aM95ztoQohQzT2ucmEt5+6/e2qyJGM7ibN9i/XDM6+H9v45Csg2r3A1mBk\n2Tq28uLg0+bW3BkeEaxvcYsXXjMJ2Xd9bsDD51Ac53XxS44/kk+F+4t5AoGBAJTs\nz7xH1GQxm5SkYW3wp0fs5BxoJ+J/S/IedKx8D5C7H888zLXuM/2h9KjscGJPPc2q\nSdF98m8zHIFyq+6PSwue4vVbhk5GhY8TTNYgwImH5M3M9O+BNRH9UeIGLTAfcRN2\nozf753im38XA43MToC3EANYLil/cCt/ghAtLY6a/AoGAKbUpIZK/W5Gz5prBBJH6\nMXPwp+d4GfyPgayWE68wqhqDkeeSFinRyT+sYoStpkkXUMDlXnKQOxThSOpFJ66O\nfliJfcu8IIwFf1B7HbHQqyFEXUfQkDaWYoSil3QENferC61L37Zz70Khq44yD1/O\nQgVvSl2J/g8bLImjmm9Kyj0=\n-----END PRIVATE KEY-----\n",
      "client_email": "optio-apis@auto-buy-e8bc2.iam.gserviceaccount.com",
      "client_id": "112405583658343495554",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/optio-apis%40auto-buy-e8bc2.iam.gserviceaccount.com"
    }
    ''');

    // takeInput()async{
    //   final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    //   final config = RecognitionConfig(
    //       encoding: AudioEncoding.LINEAR16,
    //       model: RecognitionModel.basic,
    //       enableAutomaticPunctuation: true,
    //       sampleRateHertz: 16000,
    //       languageCode: 'en-US');
    //   final streamingConfig = StreamingRecognitionConfig(config: config, interimResults: true);
    //
    //   final audio = await _getAudioStream('test.wav');
    //   final responseStream = speechToText.streamingRecognize(streamingConfig, audio);
    //   responseStream.listen((data) {
    //     // listen for response
    //   });
    // }
    //
    // Future<Stream<List<int>>> _getAudioStream(String name) async {
    //   final directory = await getApplicationDocumentsDirectory();
    //   final path = directory.path + '/$name';
    //   return File(path).openRead();
    // }


}