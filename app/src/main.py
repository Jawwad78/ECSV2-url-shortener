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
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Jawwad URL Shortener</title>
  <style>
    body{
      margin:0;
      font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;
      line-height:1.4;
      background:#16a34a;
      color:#ffffff;
    }

    .wrap{min-height:100vh;display:grid;place-items:center;padding:24px}

    .hero{
      text-align:center;
      margin-bottom:24px;
    }

    .hero h1{
      margin:0;
      font-size:34px;
      font-weight:700;
    }

    .hero p{
      margin-top:8px;
      opacity:.9;
    }

    .card{
      width:min(720px,100%);
      border:1px solid rgba(255,255,255,.3);
      border-radius:14px;
      padding:18px;
      background:rgba(0,0,0,.15);
    }

    .row{display:flex;gap:10px;flex-wrap:wrap}

    input{
   flex:1 1 520px;
   min-width:300px;
   padding:16px;
   font-size:16px;
   border-radius:12px;
   border:1px solid rgba(255,255,255,.4);
   background:#ffffff;
   color:#000000;
   }
    button{
      padding:12px 14px;
      border-radius:10px;
      border:1px solid rgba(255,255,255,.4);
      background:#000000;
      color:#ffffff;
      cursor:pointer;
      font-weight:600;
    }

    button:disabled{opacity:.6;cursor:not-allowed}

    #result{
      margin-top:18px;
      padding:18px;
      border-radius:10px;
      border:1px solid rgba(255,255,255,.3);
      background:rgba(0,0,0,.25);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:10px;
      min-height:80px;
    }

    #short{
      overflow-wrap:anywhere;
      font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace;
      font-size:16px;
      color:#ffffff;
    }

    #msg{
      margin-top:10px;
      min-height:20px;
      font-size:14px;
    }
  </style>
</head>
<body>

<div class="wrap">

  <div>
    <div class="hero">
      <h1>Jawwad’s URL Shortener</h1>
      <p>Turn long URLs into short, shareable links.</p>
    </div>

    <div class="card">

      <div class="row">
        <input id="url" inputmode="url" autocomplete="off" placeholder="https://example.com" />
        <button id="btn" onclick="shorten()">Shorten</button>
      </div>

      <div id="result">
        <a id="short" href="#" target="_blank" rel="noopener noreferrer"></a>
        <button id="copy" onclick="copyShort()" disabled>Copy</button>
      </div>

      <div id="msg"></div>

    </div>
  </div>

</div>

<script>
  const $ = (id) => document.getElementById(id);
  const elUrl = $("url"),
        elBtn = $("btn"),
        elMsg = $("msg"),
        elShort = $("short"),
        elCopy = $("copy");

  let last = "";

  elUrl.addEventListener("keydown", (e) => {
    if (e.key === "Enter") shorten();
  });

  const setMsg = (t, bad=false) => {
    elMsg.textContent = t;
    elMsg.style.color = bad ? "#ffb4b4" : "#ffffff";
  };

  const busy = (b) => {
    elBtn.disabled=b;
    elUrl.disabled=b;
    elBtn.textContent = b ? "Shortening…" : "Shorten";
    elCopy.disabled = b || !last;
  };

  const fullShort = (s) => {
    if (!s) return "";
    if (s.startsWith("http://") || s.startsWith("https://")) return s;
    const base = location.origin.replace(/\/$/, "");
    return base + (s.startsWith("/") ? s : "/" + s);
  };

  async function shorten(){
    const url = elUrl.value.trim();
    setMsg("");
    last="";
    elShort.textContent="";
    elCopy.disabled=true;

    if(!url){
      setMsg("Enter a URL first.", true);
      return;
    }

    busy(true);

    try{
      const res = await fetch("/shorten",{
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify({url})
      });

      const data = await res.json().catch(()=>null);

      if(!res.ok){
        setMsg((data && (data.detail||data.message)) || "Request failed.", true);
        return;
      }

      last = fullShort(data && data.short);

      if(!last){
        setMsg("No short URL returned.", true);
        return;
      }

      elShort.textContent = last;
      elShort.href = last;
      elCopy.disabled=false;
      setMsg("Done.");
    }
    catch{
      setMsg("Network error.", true);
    }
    finally{
      busy(false);
    }
  }

  async function copyShort(){
    if(!last) return;
    try{
      await navigator.clipboard.writeText(last);
      setMsg("Copied.");
    }
    catch{
      const ta=document.createElement("textarea");
      ta.value=last;
      document.body.appendChild(ta);
      ta.select();
      document.execCommand("copy");
      document.body.removeChild(ta);
      setMsg("Copied.");
    }
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
