# CamViewer

CamViewer is a simple web-based CCTV dashboard that allows you to stream multiple RTSP camera feeds through a clean HLS interface. It uses FFmpeg for transcoding and a Node.js backend to serve the interface and handle stream startup. It is compatible with Arch Linux and macOS (including Apple Silicon). The frontend is optimized for desktop and Android TV browsers.

---

## 📦 Requirements

- FFmpeg
- Node.js ≥ 14
- Python ≥ 3.6 (optional fallback server)
- OS support: Arch Linux, macOS

---

## 📁 Project Structure

```
camviewer/
├── backend/
│   ├── server.js              # Node.js backend server
│   └── start_streams.sh       # Shell script to start FFmpeg streams
├── frontend/
│   └── index.html             # Web dashboard
├── .gitignore
├── package.json
└── README.md
```

---

## ⚙️ Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/yourusername/camviewer.git
cd camviewer
```

### On Arch Linux:

```bash
sudo pacman -S --noconfirm ffmpeg nodejs npm python
```

### On macOS:

```bash
brew install ffmpeg node python
```

Install Node.js dependencies:

```bash
npm install
```

Make sure the streaming script is executable:

```bash
chmod +x backend/start_streams.sh
```

---

## 🔧 Configuration

Edit the backend/start_streams.sh file and set your camera login and IPs:

```bash
USER="admin"
PASS="your_camera_password"

IP1="192.168.100.31"
IP2="192.168.100.74"
IP3="192.168.100.38"
```

These represent your camera login credentials and IP addresses.

---

## 🚀 Usage

Start everything together:

```bash
npm start
```

Alternatively:

```bash
bash backend/start_streams.sh
node backend/server.js
```

This will:

- Start FFmpeg processes in the background to transcode the RTSP feeds to HLS.
- Launch a Node.js server on port 8080 to serve the frontend interface.

---

## 🌐 Accessing the Dashboard

Open your browser and navigate to:

```
http://<your_local_ip>:8080
```

Example:

```
http://192.168.100.12:8080
```

Tested on desktop browsers and Android TV browsers like Puffin or TV Bro.

---

## 🛑 Stopping the Streams

To stop the streams:

```bash
pkill -f ffmpeg
```

Or simply press Ctrl+C in the terminal running the server.

---

## ✏️ Customizing the Dashboard

You can modify frontend/index.html to:

- Rename camera labels
- Change layout or styling
- Add new camera streams (update backend/start_streams.sh accordingly)

The layout is responsive and uses HLS.js to render the live streams via <video> tags.

---

## 📂 .gitignore

This project includes the following .gitignore:

```gitignore
node_modules/
cam1/
cam2/
cam3/
*.m3u8
*.ts
.DS_Store
*.log
```

---

## 🧪 Development Tips

- Test your RTSP URLs in VLC to ensure connectivity
- Verify all IPs are reachable from your local network
- Use htop or ps to monitor ffmpeg processes

---

## 📃 License

BSD 3-Clause License

Copyright (c) 2025, CamViewer Contributors  
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.  
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.  
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.  

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
