#!/bin/bash


# create clip
#============
ffmpeg -i input.avi -ss 00:00:00 -t 00:05:00 -async 1 -vcodec copy -acodec copy out.avi


#==========================================================#
# 720p = 1280x720
#==========================================================#

# 1st pass
#=========

ffmpeg -i infile.mp4 \
-c:v libx264 -profile:v high -level:v 4.0 -preset slow \
-b:v 4750k -bufsize 1835k \
-vf "yadif=0:-1:0, scale=1280:trunc(ow/a/2)*2" \
-threads 0 -x264opts keyint=250:min-keyint=25 \
-pass 1 -an \
-f mp4 720p-high.mp4


# 2nd pass
#=========

ffmpeg -i infile.mp4 \
-c:v libx264 -profile:v high -level:v 4.0 -preset slow \
-b:v 4750k -bufsize 1835k \
-vf "yadif=0:-1:0, scale=1280:trunc(ow/a/2)*2" \
-threads 0 -x264opts keyint=250:min-keyint=25 \
-pass 2 -c:a libfdk_aac -b:a 192k \
-f mp4 720p-high.mp4

#==========================================================#
# 480p = 720x480p
#==========================================================#

# 1st pass
#=========

ffmpeg -i infile.mp4 \
-c:v libx264 -profile:v main -level:v 4.0 -preset slow \
-b:v 2500k -bufsize 1835k \
-vf "yadif=0:-1:0, scale=720:trunc(ow/a/2)*2" \
-threads 0 -x264opts keyint=250:min-keyint=25 \
-pass 1 -an \
-f mp4 480p-high.mp4


# 2nd pass
#=========

ffmpeg -i infile.mp4 \
-c:v libx264 -profile:v main -level:v 4.0 -preset slow \
-b:v 2500k -bufsize 1835k \
-vf "yadif=0:-1:0, scale=720:trunc(ow/a/2)*2" \
-threads 0 -x264opts keyint=250:min-keyint=25 \
-pass 2 -c:a libfdk_aac -b:a 128k \
-f mp4 480p-high.mp4


#==========================================================#
# 2 pass baseline
#==========================================================#

# pass 1
#=======
ffmpeg -i infile.mp4 \
-c:v libx264 -crf 18 -profile:v baseline -bsf:v h264_mp4toannexb -preset slow -b:v 2000k -bufsize 1835k -vf scale=854:480 \
-threads 0 -pix_fmt yuv420p -flags -global_header -x264opts keyint=100:min-keyint=100 -pass 1 -an -f mp4 out-480p.mp4

# pass 2
#=======
ffmpeg -i infile.mp4 \
-c:v libx264 -crf 18 -profile:v baseline -bsf:v h264_mp4toannexb -preset slow -b:v 2000k -bufsize 1835k -vf scale=854:480 \
-threads 0 -pix_fmt yuv420p -flags -global_header -x264opts keyint=100:min-keyint=100 -pass 2 -c:a libfdk_aac -b:a 128k -bsf:a aac_adtstoasc -f mp4 out-480p.mp4


#==========================================================#
# 2 pass high profile
#==========================================================#

# pass 1
#=======
ffmpeg -i infile.mp4 \
-c:v libx264 -crf 18 -profile:v high -bsf:v h264_mp4toannexb -preset slow -b:v 2500k -bufsize 1835k -vf scale=854:480 \
-threads 0 -pix_fmt yuv420p -flags -global_header -x264opts keyint=100:min-keyint=100 -pass 1 -an -f mp4 out-480p.mp4

# pass 2
#=======
ffmpeg -i infile.mp4 \
-c:v libx264 -crf 18 -profile:v high -bsf:v h264_mp4toannexb -preset slow -b:v 2500k -bufsize 1835k -vf scale=854:480 \
-threads 0 -pix_fmt yuv420p -flags -global_header -x264opts keyint=100:min-keyint=100 -pass 2 -c:a libfdk_aac -b:a 128k -bsf:a aac_adtstoasc -f mp4 out-480p.mp4


#==========================================================#
# segment video for hls
#==========================================================#


#==========================================================#
# h264_mp4toannexb + aac_adtstoasc
#==========================================================#

ffmpeg -i infile.mp4 -vcodec copy -acodec copy -bsf:v h264_mp4toannexb -bsf:a aac_adtstoasc -hls_time 10 -hls_list_size 999999999 output.m3u8

#==========================================================#
# h264_mp4toannexb
#==========================================================#

ffmpeg -i infile.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb -hls_time 10 -hls_list_size 99999 output.m3u8

#==========================================================#
# none
#==========================================================#
ffmpeg -i infile.mp4 -vcodec copy -acodec copy -hls_time 10 -hls_list_size 99999 output.m3u8
