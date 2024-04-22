# proxygen.sh
A simple bash script to merge separate card images into single ready-to-print pdf file with standard _**Android: Netrunner**_ card sizes (6.2x8.65cm).

#### Depends on imagemagick ^7
## How to use
1. Make sure you have a `proxygen.config` file in the same directory with `proxygen.sh`
2. Place source images into a folder and provide it's relative path to the `SOURCE_DIR` variable in config
3. If you want to specify numbers of copies for the cards create a _cards config file_ and provide it's relative path to the `CARDS_CONFIG_FILE` variable in config
4. Specify card sizes and list paddings if needed (though it's highly recommended to keep them the same as in `proxygen.config.example`)
5. Open terminal, navigate to the folder containing the script and run `/bin/zsh ./proxygen.sh` 
6. Wait for the script to complete
7. Find your done and dusted PDF in the output folder, print it, cut the cards and enjoy playing!

Requires `proxygen.config` in the root directory (see `proxygen.config.example`)

Config variables (`!` means required):

- `FILE_EXT` - image file extension (without dot), e.q. "png" (default value is `jpg`)
- `!SOURCE_DIR` - path to the directory containing source images*
- `RESULT_DIR` - path to the output directory (default value is `./out`)*
- `ITEM_WIDTH` - width of the card on the document list in px (recommended value is `732`)**
- `ITEM_HEIGHT` - height of the card on the document list in px (recommended value is `1018`)**
- `CARDS_CONFIG_FILE` - path to the file containing list of cards and their copies needed to be included in the resulting file (see `cards_list.example`). When no config provided every image in the source directory will be used once.***

(*) - all paths are relative to the directory containing `proxygen.sh` file

(**) - for 300 dpi printing

(***) - cards config format example:

`Card name 01.jpg|2`

`Card name 02.jpg|3`

`Card name 03.jpg|1`

`...`

`{card name N}.{file format}|{number of copies of this card}`