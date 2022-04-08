#!/bin/dash
dot="."
inc=0
directory=".snapshot."
while [ $inc -ge 0 ];
    do
    if [ -d "$directory$inc" ]; then
        inc=$((inc + 1))
    else
        break
    fi
done
mkdir $directory$inc
echo "Creating snapshot $inc"
for file_name in * ;
do
    if [ "$file_name" = "snapshot-save.sh" ] || [ "$file_name" = "snapshot-save.sh~" ] ;
    then
        continue
    elif [ "$file_name" = "snapshot-load.sh" ] || [ "$file_name" = "snapshot-load.sh~" ] ;
    then
        continue
    fi
    already_saved=$(echo $file_name | cut -c 1)
    if [ "$already_saved" = "$dot" ]; then
        continue
    else
        cp "$file_name" "$directory$inc"
        #echo "Backup of '$file_name' saved as '$directory$inc/$file_name'"
    fi
done


   # if [ "$file_name" == "snapshot-save.sh" ];
   # then
   #     continue
   # elif [ "$file_name" == "snapshot-load.sh" ];
   # then
   #     continue
   # fi
