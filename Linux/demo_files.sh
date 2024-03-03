


for file in `ls demo*`;
do
    echo "$file"
    mv $file $file.bak
done