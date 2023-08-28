
input_dir='/data/Twist_Solid/DNA/input/automate/'
for dir in $(ls $input_dir)
do
    for file in $(ls $input_dir${dir})
    do
        unlink $input_dir${dir}/$file
    done
done