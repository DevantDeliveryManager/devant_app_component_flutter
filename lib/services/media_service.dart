import 'dart:io';

import 'package:devant_components/utils/task_runner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/logger.dart';
import '../utils/typedefs.dart';



class MediaService {
  MediaService._();
  static final MediaService instance = MediaService._();

  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from gallery or camera.
  FutureEither<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return runTask(
      () async {
        final XFile? file = await _imagePicker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        return file != null ? File(file.path) : null;
      },
      operation: 'media.pickImage',
      category: LogCategory.app,
      context: {'source': source.name},
    );
  }

  /// Pick multiple images from gallery.
  FutureEither<List<File>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return runTask(
      () async {
        final List<XFile> files = await _imagePicker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        return files.map((file) => File(file.path)).toList();
      },
      operation: 'media.pickMultiImage',
      category: LogCategory.app,
    );
  }

  /// Pick a video from gallery or camera.
  FutureEither<File?> pickVideo({
    required ImageSource source,
    Duration? maxDuration,
  }) async {
    return runTask(
      () async {
        final XFile? file = await _imagePicker.pickVideo(
          source: source,
          maxDuration: maxDuration,
        );

        return file != null ? File(file.path) : null;
      },
      operation: 'media.pickVideo',
      category: LogCategory.app,
      context: {'source': source.name},
    );
  }

  /// Pick one or more files from the device.
  FutureEither<List<File>> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    return runTask(
      () async {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: type,
          allowedExtensions: allowedExtensions,
          allowMultiple: allowMultiple,
        );

        if (result == null || result.files.isEmpty) return [];

        return result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
      },
      operation: 'media.pickFiles',
      category: LogCategory.app,
    );
  }
}
