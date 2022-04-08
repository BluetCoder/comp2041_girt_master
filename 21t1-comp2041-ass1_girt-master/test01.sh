#!/bin/dash
#TEST FOR girt-add
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi
add_no_girt=$(sh girt-add 2>&1)
if [ "$add_no_girt" != "girt-add: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-add"
    echo "Program: '$add_no_girt'"
    echo "Expected: 'girt-add: error: girt repository directory .girt not found'"
    exit 1
fi
init_output=$(sh girt-init)
add_no_file=$(sh girt-add a 2>&1)
if  [ "$add_no_file" != "girt-add: error: can not open 'a'" ]; then
    echo "Test failed girt-add"
    echo "Program: '$add_no_file'"
    echo "Expected: 'girt-add: error: can not open 'a'"
    rm -r ".girt"
    exit 1
fi
touch a
add_a=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-add"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi
echo "Test Passed girt-add"
rm -r ".girt"
rm a
