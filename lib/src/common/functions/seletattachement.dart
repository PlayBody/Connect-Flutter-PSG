import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SelectAttachments {
  Future<String> selectMovie() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return '';
    return video.path;
  }

  Future<ChewieController?> loadVideoFileController(String path) async {
    var vController = VideoPlayerController.file(File(path));

    bool isLoadMovie = true;
    await vController
        .initialize()
        .onError((error, stackTrace) => isLoadMovie = false);

    if (isLoadMovie) {
      return ChewieController(
        videoPlayerController: vController,
        autoPlay: false,
        looping: false,
      );
    }

    return null;
  }

  Future<ChewieController?> loadVideoNetWorkController(String path) async {
    var vController = VideoPlayerController.network(path);

    bool isLoadMovie = true;
    await vController
        .initialize()
        .onError((error, stackTrace) => isLoadMovie = false);

    if (isLoadMovie) {
      return ChewieController(
        videoPlayerController: vController,
        autoPlay: false,
        looping: false,
      );
    }

    return null;
  }

  Future<String> selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return '';
    return image.path;
  }

  Future<dynamic> selectFileMovie() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result == null) return {'file_path': null, 'file_name': null};
    String fileName = result.files.first.name;
    String? filePath = result.files.first.path;

    String? thumbPath;
    if (filePath != null) {
      thumbPath = await VideoThumbnail.thumbnailFile(
          video: filePath,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 100,
          maxWidth: 170,
          quality: 25);
    }
    // if (thumbPath != null) videoPath = thumbPath;

    return {
      'file_path': thumbPath,
      'file_name': fileName,
      'video_file': filePath
    };
  }

  Future<dynamic> selectImageWithFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return {'file_path': null, 'file_name': null};
    String fileName = result.files.first.name;
    String? filePath = result.files.first.path;

    // final FilePicker _picker = FilePicker();
    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // if (image == null) return '';
    return {'file_path': filePath, 'file_name': fileName};
  }
}
