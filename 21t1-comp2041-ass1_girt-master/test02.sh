#!/bin/dash
#TEST FOR girt-commit
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi
if [ -f "b" ]; then
    rm  "b"
fi
if [ -f "c" ]; then
    rm  "c"
fi

commit_no_girt=$(sh girt-commit -m 'first' 2>&1)
if ! [ "$commit_no_girt" = "girt-commit: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_no_girt'"
    echo "Expected: 'girt-commit: error: girt repository directory .girt not found'"
    exit 1
fi

output_init=$(sh girt-init)

commit_no_m=$(sh girt-commit '1' 2>&1)
if ! [ "$commit_no_m" = "usage: girt-commit [-a] -m commit-message" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_no_m'"
    echo "Expected: 'usage: girt-commit [-a] -m commit-message'"
    rm -r ".girt"
    exit 1
fi

commit_no_args=$(sh girt-commit 2>&1)
if [ "$commit_no_args" != "usage: girt-commit [-a] -m commit-message" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_no_args'"
    echo "Expected: 'usage: girt-commit [-a] -m commit-message'"
    rm -r ".girt"
    exit 1
fi
commit_many_args=$(sh girt-commit -m hello world 2>&1)
if ! [ "$commit_many_args" = "usage: girt-commit [-a] -m commit-message" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_many_args'"
    echo "Expected: 'usage: girt-commit [-a] -m commit-message'"
    rm -r ".girt"
    exit 1
fi

touch a
touch b
touch c
add_a_b_c=$(sh girt-add a b c)
commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    rm b
    rm c
    exit 1
    
fi
add_a_b_c_1=$(sh girt-add a b c)
commit_second=$(sh girt-commit -m 'second' 2>&1)
if ! [ "$commit_second" = "nothing to commit" ]; then
    echo "Test failed girt-commit"
    echo "Program: '$commit_second'"
    echo "Expected: 'nothing to commit'"
    rm -r ".girt"
    rm a
    rm b
    rm c
    exit 1
fi
echo "Test Passed girt-commit"
rm -r ".girt"
rm a
rm b
rm c
