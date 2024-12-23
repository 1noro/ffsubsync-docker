#!/bin/bash

video_file_path=$1
video_file_ext="mkv"
srt_file_path=$2
result_dir="result"

if [[ -f "$video_file_path" ]]; then
    video_file_ext="${video_file_path##*.}"
    echo "Video file: '$video_file_path' (extension: '$video_file_ext')"
else
    echo "The file '$video_file_path' does not exist"
    exit 1
fi

if [[ -f "$srt_file_path" ]]; then
    if [[ "$srt_file_path" == *.srt ]]; then
        echo "Subs file: '$srt_file_path' (extension: 'srt')"
    else
        echo "The file '$srt_file_path' does not have a 'srt' extension"
        exit 1
    fi
else
    echo "The file '$srt_file_path' does not exist"
    exist 1
fi

if [[ -d "$result_dir" ]]; then
    echo "Result directory: '$(pwd)/$result_dir'"
else
    echo "The directory '$(pwd)/$result_dir' does not exist, recreating"
    mkdir $result_dir
fi

docker run --rm \
    -u "$(id -u)":"$(id -g)" \
    -v ./"$result_dir":/result:rw \
    -v "$video_file_path":/video."$video_file_ext":ro \
    -v "$srt_file_path":/subsIn.srt:ro \
    ffsubsync-local:latest \
    /bin/bash -c "source /pyvenv1/bin/activate && \
    ffs /video.$video_file_ext -i /subsIn.srt -o /result/subsOut.srt"
