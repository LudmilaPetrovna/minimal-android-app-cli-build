#!/bin/bash

#convert -size 512x512  plasma:fractal -paint 10  -blur 0x5  -paint 10 -level 10%-50% ic_launcher-web.png
SCALE4=(3 4 6 8 12 16)
NAMES=(LDPI MDPI HDPI XHDPI XXHDPI XXXHDPI)
for q in {0..5}; do
OUTSIZE=$((${SCALE4[$q]}*48/4));
OUTDIR=`echo res/drawable-${NAMES[$q]} | tr "[A-Z]" "[a-z]"`;
OUTFILE="$OUTDIR/ic_launcher.png";
mkdir -p "$OUTDIR"
convert ic_launcher-web.png -resize ${OUTSIZE}x${OUTSIZE} -sharpen 1x1 "$OUTFILE";done
