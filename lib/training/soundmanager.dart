import 'package:audioplayers/audioplayers.dart';

//Handles all sound-related functionalities.
class SoundManager {
  //static final playerCache = AudioCache();
  // final AudioPlayer audioPlayer = AudioPlayer();
  static AudioPlayer audioPlayer = AudioPlayer();

  void playSound(String fileName) async {
    audioPlayer.state;
    print("PLAY SOUND " + fileName);
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource(fileName));
  }

  static void stop() {
    audioPlayer.state;
    audioPlayer.stop();
  }

  void state() {
    print("playsound state ${audioPlayer.state}");
  }

  void dispose() {
    audioPlayer.state;
    audioPlayer.dispose();
  }
}
