#!/bin/bash

# --- CONFIGURACIÓN ---
USER="admin"
PASS="xxxxxxxxxxxxxxxxxx"

IP1="192.168.100.31"
IP2="192.168.100.74"
IP3="192.168.100.38"

# --- INSTALAR DEPENDENCIAS ---
echo "📦 Verificando instalación de dependencias..."

if ! command -v ffmpeg >/dev/null; then
    echo "→ Instalando FFmpeg..."
    sudo pacman -Sy --noconfirm ffmpeg
else
    echo "✔ FFmpeg ya está instalado."
fi

if ! command -v python3 >/dev/null; then
    echo "→ Instalando Python..."
    sudo pacman -Sy --noconfirm python
else
    echo "✔ Python ya está instalado."
fi

# --- CREAR ESTRUCTURA ---
echo "📁 Creando estructura de carpetas..."
mkdir -p camview/{cam1,cam2,cam3}
cd camview || exit 1

# --- CREAR ARCHIVO HTML ---
echo "📝 Generando archivo HTML..."
cat > index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Mis cámaras</title>
  <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</head>
<body>
  <h2>Cámara 1</h2>
  <video id="video1" width="480" height="270" controls autoplay muted></video>
  <h2>Cámara 2</h2>
  <video id="video2" width="480" height="270" controls autoplay muted></video>
  <h2>Cámara 3</h2>
  <video id="video3" width="480" height="270" controls autoplay muted></video>

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

# --- LANZAR PROCESOS FFMPEG ---
echo "🎥 Iniciando streams..."

ffmpeg -i rtsp://$USER:$PASS@$IP1:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam1/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP2:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam2/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP3:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments cam3/index.m3u8 > /dev/null 2>&1 &

sleep 2

# --- INICIAR SERVIDOR WEB ---
echo "🌐 Iniciando servidor web en http://localhost:8080"
python3 -m http.server 8080

