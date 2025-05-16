import 'dart:io';
import 'package:camera/camera.dart' as camera;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/capture_image.dart';
import '../../../repositories.dart';

// Estado para la cámara
class CameraState {
  final camera.CameraController? controller;
  final bool isInitialized;
  final bool isCapturing;
  final File? capturedImage;
  final String? error;

  CameraState({
    this.controller,
    this.isInitialized = false,
    this.isCapturing = false,
    this.capturedImage,
    this.error,
  });

  CameraState copyWith({
    camera.CameraController? controller,
    bool? isInitialized,
    bool? isCapturing,
    File? capturedImage,
    String? error,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isCapturing: isCapturing ?? this.isCapturing,
      capturedImage: capturedImage ?? this.capturedImage,
      error: error,
    );
  }
}

// Controlador para la cámara
class CameraControllerNotifier extends StateNotifier<CameraState> {
  final Ref ref;

  CameraControllerNotifier(this.ref) : super(CameraState());

  Future<void> captureImage() async {
    state = state.copyWith(isCapturing: true, error: null);
    try {
      final captureImageUseCase = CaptureImage(ref.read(ocrRepositoryProvider));
      final image = await captureImageUseCase();
      if (image != null) {
        state = state.copyWith(capturedImage: image, isCapturing: false);
      } else {
        state = state.copyWith(isCapturing: false, error: 'No se pudo capturar la imagen');
      }
    } catch (e) {
      state = state.copyWith(isCapturing: false, error: e.toString());
    }
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await camera.availableCameras();
      final cameraDevice = cameras.first;
      final controller = camera.CameraController(
        cameraDevice,
        camera.ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      state = state.copyWith(controller: controller, isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

// Proveedor para el controlador de cámara
final cameraControllerProvider = StateNotifierProvider<CameraControllerNotifier, CameraState>((ref) {
  return CameraControllerNotifier(ref);
});

// Proveedor para el caso de uso CaptureImage
final captureImageProvider = Provider<CaptureImage>((ref) {
  return CaptureImage(ref.watch(ocrRepositoryProvider));
});