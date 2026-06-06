#!/usr/bin/env bash

if [[ -z "${1}" || ! -d "${1}" ]]; then
	echo -e "\e[31mErro: Forneça um diretório válido.\e[0m"
	exit 1
fi

INPUT_DIR=$(realpath "${1}")
BASE_NAME=$(basename "$INPUT_DIR")
OUTPUT_ROOT="$(dirname "$INPUT_DIR")/${BASE_NAME}.pdf"

mkdir -p "$OUTPUT_ROOT"

find "$INPUT_DIR" -type f -name "*.md" -not -path "$OUTPUT_ROOT/*" | while read -r MD_FILE; do
	RELATIVE_DIR=$(dirname "${MD_FILE#$INPUT_DIR/}")
	TARGET_DIR="$OUTPUT_ROOT/$RELATIVE_DIR"
	
	mkdir -p "$TARGET_DIR"
	
	FILE_BASE=$(basename "$MD_FILE" .md)
	PDF_OUTPUT="$TARGET_DIR/$FILE_BASE.pdf"

	echo -e "\e[36mPDF: $FILE_BASE.pdf\e[0m"

	pandoc "$MD_FILE" -o "$PDF_OUTPUT" \
		--pdf-engine=weasyprint \
		-V margin-top=20mm -V margin-bottom=20mm \
		-V margin-left=15mm -V margin-right=15mm
done

echo -e "\n\e[32mSucesso: $OUTPUT_ROOT\e[0m"
