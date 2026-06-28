#!/usr/bin/env bash
set -e

TARGET_EXTENSIONS='-name "*.sh" -o -name "*.ps1" -o -name "*.lua" -o -name "*.cmd" -o -name "*.md" -o -name "*.nu"'

find . -type f \( $TARGET_EXTENSIONS \) | while read -r FILE_PATH; do
	if ! grep -q $'\r' "$FILE_PATH"; then
		TEMP_FILE=$(mktemp)
		awk '{sub(/\r$/, ""); printf "%s\r\n", $(0)}' "$FILE_PATH" > "$TEMP_FILE"
		mv "$TEMP_FILE" "$FILE_PATH"
		echo -e "\e[36mCRLF: $(basename "$FILE_PATH")\e[0m"
	fi
done
