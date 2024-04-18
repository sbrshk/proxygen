#!/bin/bash

ITEM_WIDTH=732
ITEM_HEIGHT=1018
PADDING_HORIZONTAL=142
PADDING_VERTICAL=221

if [  -d "./out" ]; then
  rm ./out/*
else
  mkdir ./out
fi
mkdir ./tmp

echo "Merging images in current directory to proxy.pdf file..."
echo "Total images: $(find . -type f -name "*.jpg" | wc -l)"

magick montage *.jpg -tile 3x3 -geometry $((ITEM_WIDTH))x$((ITEM_HEIGHT))+0+0 tmp/output.jpg

magick convert tmp/*.jpg \
  -scale $((ITEM_WIDTH * 3))x"$((ITEM_HEIGHT * 3))" \
  -bordercolor white \
  -border $((PADDING_HORIZONTAL))x$((PADDING_VERTICAL)) \
  -extent $((ITEM_WIDTH * 3 + PADDING_HORIZONTAL * 2))x"$((ITEM_HEIGHT * 3 + PADDING_VERTICAL * 2))" \
  -draw "line $((ITEM_WIDTH + PADDING_HORIZONTAL)),0 $((ITEM_WIDTH + PADDING_HORIZONTAL)),$((PADDING_VERTICAL))" \
  -draw "line $((ITEM_WIDTH * 2 + PADDING_HORIZONTAL)),0 $((ITEM_WIDTH * 2 + PADDING_HORIZONTAL)),$((PADDING_VERTICAL))" \
  -draw "line $((ITEM_WIDTH + PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 3 + PADDING_VERTICAL)) $((ITEM_WIDTH + PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 3 + PADDING_VERTICAL * 2))" \
  -draw "line $((ITEM_WIDTH * 2 + PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 3 + PADDING_VERTICAL)) $((ITEM_WIDTH * 2 + PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 3 + PADDING_VERTICAL * 2))" \
  -draw "line 0,$((ITEM_HEIGHT + PADDING_VERTICAL)) $((PADDING_HORIZONTAL)),$((ITEM_HEIGHT + PADDING_VERTICAL))" \
  -draw "line 0,$((ITEM_HEIGHT * 2 + PADDING_VERTICAL)) $((PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 2 + PADDING_VERTICAL))" \
  -draw "line $((ITEM_WIDTH * 3 + PADDING_HORIZONTAL)),$((ITEM_HEIGHT + PADDING_VERTICAL)) $((ITEM_WIDTH * 3 + PADDING_HORIZONTAL * 2)),$((ITEM_HEIGHT + PADDING_VERTICAL))" \
  -draw "line $((ITEM_WIDTH * 3 + PADDING_HORIZONTAL)),$((ITEM_HEIGHT * 2 + PADDING_VERTICAL)) $((ITEM_WIDTH * 3 + PADDING_HORIZONTAL * 2)),$((ITEM_HEIGHT * 2 + PADDING_VERTICAL))" \
  out/proxy.pdf

rm -rf ./tmp

echo "Done!"