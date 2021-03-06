#!/bin/bash

COPYNEW_SOURCE_DIRECTORY=""
COPYNEW_DESTIN_DIRECTORY=""

cd $(dirname "${BASH_SOURCE[0]}")
if [ -f .env ]; then
  source .env
fi

# validate folders exist
if [[ ! -d "$COPYNEW_SOURCE_DIRECTORY" ]] || [[ ! -d "$COPYNEW_DESTIN_DIRECTORY" ]]; then
  echo "Error: invalid COPYNEW_SOURCE_DIRECTORY or COPYNEW_DESTIN_DIRECTORY Check source code. Aborting."
  exit 1
fi

touch .copynew .copyold

ls -1 "$COPYNEW_SOURCE_DIRECTORY" > .copynew

while read file; do
  found=0
  while read old; do
    if [ "$file" == "$old" ]; then
      found=1
      break
    fi
  done < .copyold
  if [ $found = 0 ]; then
    echo "$COPYNEW_SOURCE_DIRECTORY/$file"
    ln -s "$COPYNEW_SOURCE_DIRECTORY/$file" "$COPYNEW_DESTIN_DIRECTORY/$file"
  fi
done < .copynew

# make sure tempfile not empty so as to not overwrite
# extract log in event of connection issues, errors, etc.
if [ -s .copynew ]; then
  mv .copynew .copyold
fi
