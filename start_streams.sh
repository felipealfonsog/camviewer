#!/bin/bash

USER="admin"
PASS="gdR2NgvCsAJxJ2Y0UrFJ"

IP1="192.168.100.31"
IP2="192.168.100.74"
IP3="192.168.100.38"

mkdir -p public/cam1 public/cam2 public/cam3

echo "🎥 Starting camera streams..."

ffmpeg -i rtsp://$USER:$PASS@$IP1:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments public/cam1/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP2:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments public/cam2/index.m3u8 > /dev/null 2>&1 &

ffmpeg -i rtsp://$USER:$PASS@$IP3:554/onvif1 \
  -c:v copy -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments public/cam3/index.m3u8 > /dev/null 2>&1 &

echo "✅ Streams started."
