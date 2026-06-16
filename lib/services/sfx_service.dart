import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Programmatic sound effects — no external MP3 dependency required.
class SfxService {
  SfxService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;
  static const _sampleRate = 44100;

  Future<void> playCorrect() => _play(_buildCorrect());
  Future<void> playWrong() => _play(_buildWrong());
  Future<void> playSuccess() => _play(_buildSuccess());
  Future<void> playTap() => _play(_buildTap());

  Future<void> _play(Uint8List wav) async {
    try {
      await _player.stop();
      await _player.play(BytesSource(wav));
    } catch (_) {}
  }

  Uint8List _buildCorrect() => _wav(
        _seq([
          _tone(523, 0.08),
          _tone(659, 0.08),
          _tone(784, 0.12),
        ]),
      );

  Uint8List _buildWrong() => _wav(
        _seq([
          _tone(180, 0.15, vol: 0.4),
          _tone(140, 0.2, vol: 0.35),
        ]),
      );

  Uint8List _buildSuccess() => _wav(
        _seq([
          _tone(523, 0.1),
          _tone(659, 0.1),
          _tone(784, 0.1),
          _tone(1047, 0.25, vol: 0.3),
        ]),
      );

  Uint8List _buildTap() => _wav(_tone(880, 0.04, vol: 0.2));

  List<double> _seq(List<List<double>> parts) =>
      parts.expand((p) => p).toList();

  List<double> _tone(double freq, double duration, {double vol = 0.35}) {
    final n = (_sampleRate * duration).round();
    final fade = (_sampleRate * 0.02).round();
    final out = <double>[];
    for (var i = 0; i < n; i++) {
      var env = 1.0;
      if (i < fade) env = i / fade;
      if (i > n - fade) env = (n - i) / fade;
      out.add(32767 * vol * env * sin(2 * pi * freq * i / _sampleRate));
    }
    return out;
  }

  Uint8List _wav(List<double> samples) {
    final data = ByteData(samples.length * 2);
    for (var i = 0; i < samples.length; i++) {
      final v = samples[i].round().clamp(-32767, 32767);
      data.setInt16(i * 2, v, Endian.little);
    }
    final header = _wavHeader(samples.length);
    return Uint8List.fromList([...header, ...data.buffer.asUint8List()]);
  }

  List<int> _wavHeader(int sampleCount) {
    final dataSize = sampleCount * 2;
    final fileSize = 36 + dataSize;
    return [
      ...'RIFF'.codeUnits,
      ..._le32(fileSize),
      ...'WAVE'.codeUnits,
      ...'fmt '.codeUnits,
      ..._le32(16),
      ..._le16(1),
      ..._le16(1),
      ..._le32(_sampleRate),
      ..._le32(_sampleRate * 2),
      ..._le16(2),
      ..._le16(16),
      ...'data'.codeUnits,
      ..._le32(dataSize),
    ];
  }

  List<int> _le32(int v) => [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff];
  List<int> _le16(int v) => [v & 0xff, (v >> 8) & 0xff];

  void dispose() => _player.dispose();
}
