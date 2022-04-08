#!/bin/dash
# TEST FOR girt-checkout
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi
if [ -f "b" ]; then
    rm  "b"
fi
checkout_no_girt=$(sh girt-checkout b1 2>&1)
if [ "$checkout_no_girt" != "girt-checkout: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$checkout_no_girt'"
    echo "Expected: 'girt-checkout: error: girt repository directory .girt not found'"
    exit 1
fi


output_init=$(sh girt-init)
checkout_no_commit=$(sh girt-checkout b1 2>&1)
if [ "$checkout_no_commit" != "girt-checkout: error: this command can not be run until after the first commit" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$checkout_no_commit'"
    echo "Expected: 'girt-checkout: error: this command can not be run until after the first commit'"
    rm -r ".girt"
    exit 1
fi


touch a
add_a=$(sh girt-add a 2>&1)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-checkout"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi

commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi

branch_b1=$(sh girt-branch b1 2>&1)
checkout_b1=$(sh girt-checkout b1 2>&1)
if [ "$checkout_b1" != "Switched to branch 'b1'" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$checkout_b1'"
    echo "Expected: 'Switched to branch 'b1''"
    rm a
    rm -r ".girt"
    exit 1
fi

touch b
add_b=$(sh girt-add b 2>&1)
if ! [ -e ".girt/index/b1/b" ]; then
    echo "Test failed girt-checkout"
    echo "'b' was not added to the index"
    echo "Program printed: $add_b"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi

commit_second=$(sh girt-commit -m 'second')
if [ "$commit_second" != "Committed as commit 1" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$commit_second'"
    echo "Expected: 'Committed as commit 1'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi

checkout_master=$(sh girt-checkout master 2>&1)
if [ "$checkout_master" != "Switched to branch 'master'" ]; then
    echo "Test failed girt-checkout"
    echo "Program: '$checkout_master'"
    echo "Expected: 'Switched to branch 'master''"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
if [ -e "b" ]; then
    echo "Test failed girt-checkout"
    echo "'b' should not be in the current directory"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi

echo "Test Passed girt-checkout"
rm a
rm -r ".girt"
