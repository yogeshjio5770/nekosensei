"""Generate lightweight WAV sound effects for NekoSensei."""
import math
import struct
import wave
from pathlib import Path

OUT = Path(__file__).parent.parent / "assets" / "audio"
OUT.mkdir(parents=True, exist_ok=True)
SAMPLE_RATE = 44100


def write_wav(path: Path, samples):
    with wave.open(str(path), "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SAMPLE_RATE)
    for s in samples:
        v = int(max(-32767, min(32767, s)))
        w.writeframes(struct.pack("<h", v))


def tone(freq, duration, volume=0.35, fade=0.02):
    n = int(SAMPLE_RATE * duration)
    fade_n = int(SAMPLE_RATE * fade)
    out = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = 1.0
        if i < fade_n:
            env = i / fade_n
        elif i > n - fade_n:
            env = (n - i) / fade_n
        out.append(32767 * volume * env * math.sin(2 * math.pi * freq * t))
    return out


def correct():
    s = tone(523, 0.08) + tone(659, 0.08) + tone(784, 0.12)
    write_wav(OUT / "correct.wav", s)


def wrong():
    s = tone(180, 0.15, volume=0.4) + tone(140, 0.2, volume=0.35)
    write_wav(OUT / "wrong.wav", s)


def success():
    s = (
        tone(523, 0.1)
        + tone(659, 0.1)
        + tone(784, 0.1)
        + tone(1047, 0.25, volume=0.3)
    )
    write_wav(OUT / "success.wav", s)


def tap():
    s = tone(880, 0.04, volume=0.2)
    write_wav(OUT / "tap.wav", s)


if __name__ == "__main__":
    correct()
    wrong()
    success()
    tap()
    print("Generated:", list(OUT.glob("*.wav")))
