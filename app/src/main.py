from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse
from fastapi.responses import HTMLResponse
import os, hashlib, time
from ddb import put_mapping, get_mapping

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <!doctype html>
    <html>
      <head>
        <title>URL shortener</title>
      </head>
      <body>
        <h1>URL shortener</h1>

        <input id="url" placeholder="https://example.com">
        <button onclick="shorten()">Shorten</button>

        <p id="result"></p>

        <script>
          async function shorten() {
            const url = document.getElementById("url").value;

            const res = await fetch("/shorten", {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ url: url })
            });

            const data = await res.json();
            document.getElementById("result").innerText =
              res.ok ? data.short : "error";
          }
        </script>
      </body>
    </html>
    """

@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}

@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}

@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return RedirectResponse(item["url"])
