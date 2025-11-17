#!/bin/sh
m3u='https://live-hls-web-aje.getaj.net/AJE/05.m3u8'
maxtime='00:01:00'
ffmpeg -i "${m3u}" -codec:v copy -codec:a copy -f hls -hls_time 10 -hls_list_size 3 -hls_flags delete_segments -t "${maxtime}" output.m3u8
