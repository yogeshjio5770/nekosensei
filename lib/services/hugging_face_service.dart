import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

/// Service for using self-hosted Hugging Face Whisper for speech recognition
class HuggingFaceService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _audioPath;

  // Your Hugging Face Space API URL (username: yogesh20061)
  final String _apiUrl = 'https://yogesh20061-nekosensei-whisper-api.hf.space/transcribe';

  Future<void> initialize() async {
    await _recorder.openRecorder();
  }

  bool get isRecording => _isRecording;

  Future<bool> startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _audioPath = '${tempDir.path}/recording.wav';

      await _recorder.startRecorder(
        toFile: _audioPath,
        codec: Codec.pcm16WAV,
      );

      _isRecording = true;
      return true;
    } catch (e) {
      print('[HuggingFace] Start recording failed: $e');
      return false;
    }
  }

  Future<String?> stopAndTranscribe() async {
    try {
      await _recorder.stopRecorder();
      _isRecording = false;

      if (_audioPath == null) return null;

      final file = File(_audioPath!);
      if (!await file.exists()) return null;

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.files.add(await http.MultipartFile.fromPath('file', _audioPath!));

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text']?.toString().trim();
      } else {
        print('[HuggingFace] API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('[HuggingFace] Transcribe failed: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
