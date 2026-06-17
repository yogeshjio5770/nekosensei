import gradio as gr
import whisper
import tempfile
import os

print("🚀 Starting NekoSensei Whisper API...")

# Load Whisper model (small for balanced speed & accuracy, perfect for Japanese learning)
print("📥 Loading Whisper model (small)...")
model = whisper.load_model("small")
print("✅ Model loaded successfully!")

def transcribe_audio(audio_file):
    print(f"🎤 Received audio file: {audio_file}")
    
    try:
        # Transcribe audio (force Japanese for better accuracy)
        print("🔍 Transcribing audio...")
        result = model.transcribe(audio_file, language="ja")
        transcription = result["text"].strip()
        print(f"✅ Transcription complete: {transcription}")
        return transcription
    except Exception as e:
        print(f"❌ Error during transcription: {e}")
        return f"Error: {e}"

# Create Gradio interface
demo = gr.Interface(
    fn=transcribe_audio,
    inputs=gr.Audio(type="filepath", label="Speak Japanese!"),
    outputs=gr.Textbox(label="Transcription"),
    title="NekoSensei Whisper API",
    description="Japanese speech recognition using OpenAI Whisper, hosted for free on Hugging Face Spaces!",
)

print("🏁 App setup complete! Launching Gradio...")

# Launch the app
demo.launch(server_name="0.0.0.0", server_port=7860)
