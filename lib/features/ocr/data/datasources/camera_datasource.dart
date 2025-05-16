import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';

abstract class CameraDataSource {
  Future<XFile?> captureImage();
}

class CameraDataSourceImpl implements CameraDataSource {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<XFile?> captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 100,
      );
      return image;
    } catch (e) {
      throw CameraFailure(message: 'Error al capturar la imagen: $e');
    }
  }
}