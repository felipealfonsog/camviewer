#!/bin/bash

# --- CONFIGURATION ---
USER="admin"
PASS="gdR2NgvCsAJxJ2Y0UrFJ"

IP1="192.168.100.31"
IP2="192.168.100.74"
IP3="192.168.100.38"

echo "📦 Checking for required packages..."

# --- INSTALL DEPENDENCIES ---
if ! command -v ffmpeg >/dev/null; then
    echo "→ Installing ffmpeg..."
    sudo pacman -Sy --noconfirm ffmpeg
else
    echo "✔ ffmpeg is already installed."
fi

if ! command -v python3 >/dev/null; then
    echo "→ Installing Python 3..."
    sudo pacman -Sy --noconfirm python
else
    echo "✔ Python 3 is already installed."
fi

# --- CREATE DIRECTORY STRUCTURE ---
echo "📁 Creating folder structure..."
mkdir -p camview/{cam1,cam2,cam3}
cd camview || exit 1

# --- GENERATE HTML DASHBOARD ---
echo "📝 Creating HTML dashboard..."
cat > index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>CCTV Dashboard</title>
  <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
  <style>
    body {
      background-color: #111;
      color: #eee;
      font-family: sans-serif;
      margin: 0;
      padding: 0;
    }
    header {
      background: #222;
      padding: 1rem;
      text-align: center;
      font-size: 1.5rem;
      color: #00ff88;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
      gap: 1rem;
      padding: 1rem;
    }
    .card {
      background: #1e1e1e;
      padding: 0.5rem;
      border-radius: 8px;
    }
    h2 {
      font-size: 1rem;
      color: #0af;
    }
    video {
      width: 100%;
      border-radius: 6px;
      background: #000;
    }
  </style>
</head>
<body>
  <header>CCTV Live View - Host: \$(hostname -I | cut -d' ' -f1):8080</header>
  <div class="grid">
    <div class="card">
      <h2>Camera 1 (${IP1})</h2>
      <video id="video1" controls autoplay muted></video>
    </div>
    <div class="card">
      <h2>Camera 2 (${IP2})</h2>
      <video id="video2" controls autoplay muted></video>
    </div>
    <div class="card">
      <h2>Camera 3 (${IP3})</h2>
      <video id="video3" controls autoplay muted></video>
    </div>
  </div>
  <script>
    function loadStream(videoId, url) {
      const video = document.getElementById(videoId);
      if (Hls.isSupported()) {
        const hls = new Hls();
        hls.loadSource(url);
        hls.attachMedia(video);
      } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        video.src = url;
      }
    }
    loadStream('video1', 'cam1/index.m3u8');
    loadStream('video2', 'cam2/index.m3u8');
    loadStream('video3', 'cam3/index.m3u8');
  </script>
</body>
</html>
EOF

# --- START FFMPEG STREAMS ---
echo "🎥 Starting video streams..."

ffmpeg -i rtsp://$USER:$PASS@$IP1:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam1/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP2:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam2/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP3:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam3/index.m3u8 > /dev/null 2>&1 &

sleep 2

# --- START WEB SERVER ---
echo "🌐 Web server running at: http://$(hostname -I | cut -d' ' -f1):8080"
python3 -m http.server 8080

