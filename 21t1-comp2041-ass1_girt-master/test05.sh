#!/bin/dash
# TEST FOR girt-commit -a
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi

output_init=$(sh girt-init)

echo "Commit -a 1 test" > a
add_a=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-commit -a"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi
commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-commit -a"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi

echo "Commit -a 2 test" > a
commit_a=$(sh girt-commit -a -m 'second')
if [ "$commit_a" != "Committed as commit 1" ]; then
    echo "Test failed girt-commit -a"
    echo "Program: '$commit_a'"
    echo "Expected: 'Committed as commit 1'"
    rm -r ".girt"
    rm a
    exit 1
fi

show_commit_1=$(sh girt-show '1:a')
if [ "$show_commit_1" != "Commit -a 2 test" ]; then
    echo "Test failed girt-commit -a"
    echo "Program: '$show_commit_1'"
    echo "Expected: 'Commit -a 2 test'"
    rm -r ".girt"
    rm a
    exit 1
fi
show_commit_0=$(sh girt-show '0:a')
if [ "$show_commit_0" != "Commit -a 1 test" ]; then
    echo "Test failed girt-commit -a"
    echo "Program: '$show_commit_0'"
    echo "Expected: 'Commit -a 1 test'"
    rm -r ".girt"
    rm a
    exit 1
fi

echo "Test Passed girt-commit -a command"
rm -r ".girt"
rm a
