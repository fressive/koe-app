import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:koe/models/model.dart';

class SongInformationController extends GetxController {
  final title = "歌曲".obs;
  final artist = "艺术家".obs;
  final playing = false.obs;
  final position = 0.0.obs;
  final duration = 1.0.obs;
  final artUri =
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3761843179,3646757056&fm=26&gp=0.jpg"
          .obs;
  final Rx<Song?> model = Song().obs;
}
