from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
import whisper
import tempfile
import uvicorn
import os
import anyio # Used for running synchronous tasks in an async context

app = FastAPI()

# Load the Whisper model once when the application starts
# This is crucial for performance and resource management
try:
    model = whisper.load_model("medium")
    print("INFO: Whisper model 'medium' loaded successfully.")
except Exception as e:
    print(f"ERROR: Failed to load Whisper model: {e}")
    # You might want to exit or handle this more gracefully in a production app
    model = None

@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):
    if model is None:
        raise HTTPException(status_code=500, detail="Whisper model not loaded.")

    temp_file_path = None
    try:
        # IMPORTANT: Ensure the suffix matches what Flutter is sending (from videocall.dart)
        # We changed Flutter to send .aac, so the backend should expect .aac
        with tempfile.NamedTemporaryFile(delete=False, suffix=".aac") as temp_audio:
            contents = await file.read()
            temp_audio.write(contents)
            temp_audio.flush() # Ensure data is written to disk
            temp_file_path = temp_audio.name

        print(f"INFO: Received audio file: {file.filename}, saved to {temp_file_path}")

        # CORRECTED LINE: Use a lambda to pass keyword arguments to model.transcribe
        # The lambda ensures 'task="translate"' is passed to model.transcribe,
        # not to anyio.to_thread.run_sync.
        result = await anyio.to_thread.run_sync(
            lambda: model.transcribe(temp_file_path, task="translate")
        )

        print(f"INFO: Transcription successful for {file.filename}")
        return {"text": result["text"]}

    except Exception as e:
        print(f"ERROR: Transcription failed for {file.filename}: {e}")
        raise HTTPException(status_code=500, detail=f"Transcription failed: {e}")
    finally:
        # Ensure the temporary file is deleted, even if an error occurred
        if temp_file_path and os.path.exists(temp_file_path):
            try:
                os.unlink(temp_file_path)
                print(f"INFO: Deleted temporary file: {temp_file_path}")
            except Exception as e:
                print(f"WARNING: Failed to delete temporary file {temp_file_path}: {e}")

# To run this server:
# 1. Save the code as main.py (or app.py)
# 2. Make sure you have uvicorn, fastapi, and whisper installed:
#    pip install uvicorn fastapi "openai-whisper" "python-multipart" "anyio"
# 3. Run from your terminal: uvicorn main:app --host 0.0.0.0 --port 8000 --reload
