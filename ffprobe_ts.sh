#!/bin/sh
ts_file=~/m3u/plutotv/hls_1000-00083.ts
key_file=~/m3u/plutotv/hls_1000_keyfile_0.key
if [ ! -z "$key_file" ]; then
  openssl enc -aes-128-cbc -d -K `xxd -p "${key_file}"` -iv '00000000000000000000000000000054' -in "${ts_file}" -out "${ts_file}.dec"
  ts_file="${ts_file}.dec"
fi
ffp=`ffprobe -show_frames -i "${ts_file}" 2>&1 | grep -e 'start:' -e 'pts' | head -n 3`

duration=`echo "$ffp" | sed -n '1s/.*Duration: \([0-9:\.]*\).*/\1/p'`
start=`echo "$ffp" | sed -n '1s/.*start: \([0-9\.]*\).*/\1/p'`
pts=`echo "$ffp" | sed -n '2s|pts=||p'`
pts_time=`echo "$ffp" | sed -n '3s|pts_time=||p'`

timescale=`echo "(${pts}/${pts_time})+0.50" | bc -l`
timescale=`printf "%d" "$timescale" 2>/dev/null`
start=`date -d@${pts_time} -u '+%H:%M:%S'`
duration=`TZ=utc date -d "1970-01-01 ${duration}" '+%s'`
end=`echo "${pts_time}+${duration}" | bc -l`
end=`date -d@${end} -u +%H:%M:%S`

echo "$ffprobe"
echo ">> ${pts} / ${pts_time} = ${timescale} "
echo ">> WEBVTT"
echo ">> X-TIMESTAMP-MAP=MPEGTS:90000,LOCAL:00:00:00.000"
echo ">> ${start}.000 --> ${end}.999"
