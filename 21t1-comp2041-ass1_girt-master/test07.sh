#!/bin/dash
# TEST FOR girt-status
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi
if [ -f "b" ]; then
    rm  "b"
fi

status_no_girt=$(sh girt-status 2>&1)
if [ "$status_no_girt" != "girt-status: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-status"
    echo "Program: '$status_no_girt'"
    echo "Expected: 'girt-status: error: girt repository directory .girt not found'"
    exit 1
fi

output_init=$(sh girt-init)

touch a
touch b
add_a=$(sh girt-add a 2>&1)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-status"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi

commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-status"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
add_b=$(sh girt-add b 2>&1)
if ! [ -e ".girt/index/master/b" ]; then
    echo "Test failed girt-status"
    echo "'b' was not added to the index"
    echo "Program printed: $add_b"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
status_output=$(sh girt-status 2>&1)
a_output=$(echo ${status_output} | grep -E "a - same as repo")
b_output=$(echo ${status_output} | grep -E "b - added to index")
if [ "$a_output" = "" ] || [ "$b_output" = "" ]; then
    echo "Test failed girt-status"
    echo "Program: '$a_output and $b_output'"
    echo "Expected: 'a - same as repo and b - added to index'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
echo "Test Passed girt-status"
rm a
rm b
rm -r ".girt"
