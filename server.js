const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');
const { spawn } = require('child_process');

const PORT = 8080;
const PUBLIC_DIR = path.join(__dirname, 'public');

// Ejecutar el script de streams
const ffmpegProcess = spawn('bash', ['start_streams.sh'], {
  cwd: __dirname,
  detached: true,
  stdio: 'ignore',
});
ffmpegProcess.unref();

function getLocalIP() {
  const interfaces = os.networkInterfaces();
  for (const iface of Object.values(interfaces)) {
    for (const details of iface) {
      if (details.family === 'IPv4' && !details.internal) {
        return details.address;
      }
    }
  }
  return 'localhost';
}

const server = http.createServer((req, res) => {
  let filePath = path.join(PUBLIC_DIR, req.url === '/' ? 'index.template.html' : req.url);
  const ext = path.extname(filePath);

  if (filePath.endsWith('index.template.html')) {
    fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
        res.writeHead(500);
        res.end('Server error');
        return;
      }
      const ip = getLocalIP();
      const content = data.replace(/{{IP_ADDRESS}}/g, ip);
      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end(content);
    });
  } else {
    const mimeTypes = {
      '.m3u8': 'application/vnd.apple.mpegurl',
      '.ts': 'video/mp2t',
      '.js': 'text/javascript',
      '.css': 'text/css',
      '.html': 'text/html',
    };

    fs.readFile(filePath, (err, content) => {
      if (err) {
        res.writeHead(404);
        res.end('Not found');
        return;
      }
      const mime = mimeTypes[ext] || 'application/octet-stream';
      res.writeHead(200, { 'Content-Type': mime });
      res.end(content);
    });
  }
});

server.listen(PORT, () => {
  console.log(`✅ CamViewer is running at http://${getLocalIP()}:${PORT}/`);
});
