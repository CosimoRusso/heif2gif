#!/bin/bash
if [ $# -eq 0 ]
then
    echo "Need a path"
    exit 1
fi
FOLDER=$1
if [ ! -d "$FOLDER" ]; then
    echo "Directory does not exists"
    exit
fi
cd "$FOLDER"
for file in *; do
    if [ -f "$file" ]; then
        RES=$(heif-info "$file" 2> /tmp/Error)
        RES=$(cat /tmp/Error)
        rm /tmp/Error
        if [ -z "$RES" ]; then
            #convert
            shopt -s nocasematch
            newName=${file//\.heic/""}
            shopt -u nocasematch
            ext=".jpg"
            newName="$newName$ext"
            heif-convert "$file" "$newName" > /dev/null 2> /dev/Error
            error=$(cat /tmp/Error)
            rm /tmp/Error
            if [ -z "$error" ]; then
                echo "$file --> $newName"
                rm "$file"
            elif
                echo "Error with $file: $error"
            fi
        fi
    fi 
done
