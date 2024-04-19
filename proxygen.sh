#!/bin/bash

DEFAULT_FILE_EXT=jpg
DEFAULT_RESULT_DIR=./out
DEFAULT_ITEM_WIDTH=732
DEFAULT_ITEM_HEIGHT=1018
DEFAULT_PADDING_HORIZONTAL=142
DEFAULT_PADDING_VERTICAL=221

echo "---------------------------------------------------"
echo "PROXYGEN SCRIPT STARTED"
echo "---------------------------------------------------"

echo "STEP 1: reading config..."
if [ -f ./proxygen.config ]; then
  echo "STEP 1 SUCCESS: proxygen.config found, using it"
  . ./proxygen.config
  FILE_EXT=${FILE_EXT:-$DEFAULT_FILE_EXT}
  RESULT_DIR=${RESULT_DIR:-$DEFAULT_RESULT_DIR}
  ITEM_WIDTH=${ITEM_WIDTH:-$DEFAULT_ITEM_WIDTH}
  ITEM_HEIGHT=${ITEM_HEIGHT:-$DEFAULT_ITEM_HEIGHT}
  PADDING_HORIZONTAL=${PADDING_HORIZONTAL:-$DEFAULT_PADDING_HORIZONTAL}
  PADDING_VERTICAL=${PADDING_VERTICAL:-$DEFAULT_PADDING_VERTICAL}
else
  echo "STEP 1 FAILED: please make sure there is a 'proxygen.config' file in the root of current directory"
  exit 1
fi

echo "STEP 2: preparing directories..."
if [  -d "$RESULT_DIR" ]; then
  rm "$RESULT_DIR"/*
else
  mkdir "$RESULT_DIR"
fi
mkdir ./tmp

if [ -f "$CARDS_CONFIG_FILE" ]; then
  echo "STEP 3: cards config found, generating card list..."
  while IFS= read -r LINE
  do
      CARD_NAME=$(echo "$LINE" | cut -d '|' -f 1)
      CARD_COPIES=$(echo "$LINE" | cut -d '|' -f 2)
      for i in $(seq 1 "$CARD_COPIES"); do
        echo \""$SOURCE_DIR"/"$CARD_NAME"\" >> ./tmp/cards_list
      done
  done < "$CARDS_CONFIG_FILE"
else
  echo "STEP 3: cards config not found, all cards in the source directory will be used"
  echo "$SOURCE_DIR/*.$FILE_EXT" > ./tmp/cards_list
fi

echo "STEP 4: Merging images..."
magick montage @./tmp/cards_list -tile 3x3 -geometry $((ITEM_WIDTH))x$((ITEM_HEIGHT))+0+0 "tmp/output.$FILE_EXT"

rm -rf ./tmp/cards_list

echo "STEP 5: Generating PDF file..."
magick convert "tmp/*.$FILE_EXT" \
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

echo "STEP 6: Done! You can now find your printable PDF file in ${RESULT_DIR}/proxy.pdf"

echo "---------------------------------------------------"
echo "PROXYGEN SCRIPT FINISHED"
echo "---------------------------------------------------"