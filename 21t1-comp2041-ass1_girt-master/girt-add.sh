#!/bin/dash
directory=".girt"
if [ -d "$directory" ]; then
    cd $directory
    cd "logs"
    touch index.txt
    for files in "$@"
    do
        echo "$files" >> index.txt
    done
    
fi

