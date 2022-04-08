#!/bin/dash
# TEST FOR girt-checkout
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi

branch_no_girt=$(sh girt-branch 2>&1)
if [ "$branch_no_girt" != "girt-branch: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_no_girt'"
    echo "Expected: 'girt-branch: error: girt repository directory .girt not found'"
    exit 1
fi


output_init=$(sh girt-init)
branch_no_commit=$(sh girt-branch 2>&1)
if [ "$branch_no_commit" != "girt-branch: error: this command can not be run until after the first commit" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_no_commit'"
    echo "Expected: 'girt-branch: error: this command can not be run until after the first commit'"
    exit 1
fi


touch a
add_a=$(sh girt-add a 2>&1)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-branch"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi

commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi

branch_b1=$(sh girt-branch b1 2>&1)
branch_show=$(sh girt-branch)
if [ "$branch_show" != "b1
master" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_show'"
    echo "Expected: 'b1\nmaster'"
    rm -r ".girt"
    rm a
    exit 1
fi
branch_delete=$(sh girt-branch -d b1)
if [ "$branch_delete" != "Deleted branch 'b1'" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_delete'"
    echo "Expected: 'Deleted branch 'b1'"
    rm -r ".girt"
    rm a
    exit 1
fi
branch_show=$(sh girt-branch)
if [ "$branch_show" != "master" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_show'"
    echo "Expected: 'master'"
    rm -r ".girt"
    rm a
    exit 1
fi
branch_delete=$(sh girt-branch -d master 2>&1)
if [ "$branch_delete" != "girt-branch: error: can not delete branch 'master'" ]; then
    echo "Test failed girt-branch"
    echo "Program: '$branch_delete'"
    echo "Expected: 'girt-branch: error: can not delete branch 'master''"
    rm -r ".girt"
    rm a
    exit 1
fi
echo "Test Passed girt-branch"
rm a
rm -r ".girt"
