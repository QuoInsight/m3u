#!/bin/sh

#sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm
#sudo dnf config-manager --set-enabled crb
#sudo dnf install ffmpeg ## Fast Forward Moving Picture Experts Group ##

img="_img.png" ## 256x144 ## scp img.png opc@161.118.192.255:~/m3u
t=10 ; mp4="img${t}s.mp4" ; m3u="img.m3u8" ## rm img*

ffmpeg -loop 1 -i "${img}" -t ${t}  -c:v libx264 -pix_fmt yuv420p -crf 23 -tune stillimage "${mp4}"
ffmpeg -stream_loop -1 -i "${mp4}" -codec copy -start_number 1 -f hls -hls_time ${t} -hls_list_size 3 -hls_flags delete_segments -t "${t}" "${m3u}"
