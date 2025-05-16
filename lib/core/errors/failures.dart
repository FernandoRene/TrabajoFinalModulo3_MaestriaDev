abstract class Failure {
  final String message;
  
  const Failure({required this.message});
  
  @override
  String toString() => message;
}

class CameraFailure extends Failure {
  const CameraFailure({required super.message});
}

class OcrFailure extends Failure {
  const OcrFailure({required super.message});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}