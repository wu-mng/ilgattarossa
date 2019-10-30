#!/bin/bash
# Set the source folder here, be sure there's NO_SPACES in the folder's name!
# Put the images you want to compress into the folder. 
SOURCE=responsive
# Set the desired sizes for the compressed images
SIZES=(380 640 960 1280 1600)
# Set the destination folder here, be sure there's NO_SPACES in the folder's name!
# The compressed images will be in $DESTINATION/$SIZE
# DESTINATION=src

for s in ${SIZES[@]}; do
    mkdir -p "$SOURCE/$s"
done

for f in "$SOURCE"/*; do
    echo &&
    FILETYPE="${f#*.}" &&
    if [[ "$FILETYPE" == "png" ]]; then
        echo "optimizing '$f'" &&
        optipng -quiet "$f"
    fi
    if [[ "$FILETYPE" == "jpg" ]]; then
        echo "optimizing '$f'" &&
        jpegoptim "$f"
    fi
    # assign $(command) to VARIABLE
    FILEWIDTH=$(identify -format %w "$f") &&
    FILENAME=$(basename -- "$f") &&
    FILESIZE=$(wc -c "$f" | cut -d' ' -f1) &&
    
    for s in ${SIZES[@]}; do
        # if the destination file width exceeds the original file width, just copy the original file
        if [ "$s" -gt "$FILEWIDTH" ]; then
        echo "'$f' is smaller than $s px, copying it to '$SOURCE/$s/'..." &&
        cp "$f" "$SOURCE/$s/"
        else
        # compress the file
        echo "creating '$SOURCE/$s/$FILENAME'" &&
        mogrify -path "$SOURCE/$s" -define png:compression-level=9 -sampling-factor 4:2:0 -strip -quality 85 -interlace plane -colorspace sRGB -resize "$s"x "$f" &&
            # optimize the .png file
            if [[ "$FILETYPE" == "png" ]]; then
                echo "optimizing '$SOURCE/$s/$FILENAME'" &&
                optipng -quiet "$SOURCE/$s/$FILENAME"
            fi
            # optimize the .jpg file 
            # made no difference in the tests, so it's commented out
            #~ if [[ "$FILETYPE" == "jpg" ]]; then
                #~ jpegoptim "$SOURCE/$s/$FILENAME"
            #~ fi
        fi
        FILE2="$SOURCE/$s/$FILENAME" &&
        FILE2NAME=$(basename -- "$FILE2") &&
        FILE2SIZE=$(wc -c "$FILE2" | cut -d' ' -f1) &&
        if [[ "$FILE2NAME" == "$FILENAME" ]]; then
            # if the compressed file is bigger than the original file (it's rare, but can happen), overwrite it with the original file
            if [ "$FILE2SIZE" -gt "$FILESIZE" ]; then
            echo "'$FILE2' is bigger than '$f', copying '$f' to '$SOURCE/$s'..." &&
            rm "$FILE2" &&
            cp "$f" "$SOURCE/$s/"
            # here we should copy the file to all the remaining sources, then "break" out of this loop 
            fi
        fi 
    done
done
