#!/bin/dash
#TEST FOR girt-log
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi

log_no_girt=$(sh girt-log -m 'first' 2>&1)
if [ "$log_no_girt" != "girt-log: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-log"
    echo "Program: '$log_no_girt'"
    echo "Expected: 'girt-log: error: girt repository directory .girt not found'"
    exit 1
fi

output_init=$(sh girt-init)
log_args=$(sh girt-log -m 'first' 2>&1)
if [ "$log_args" != "usage: girt-log" ]; then
    echo "Test failed girt-log"
    echo "Program: '$log_args'"
    echo "Expected: 'usage: girt-log'"
    exit 1
    rm -r ".girt"
fi
touch a
add_a=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-log"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi

commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-log"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi
echo "log 1 test" >> a
add_a_1=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-log"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a_1"
    rm -r ".girt"
    rm a
    exit 1
fi
commit_second=$(sh girt-commit -m 'second')
if [ "$commit_second" != "Committed as commit 1" ]; then
    echo "Test failed girt-log"
    echo "Program: '$commit_second'"
    echo "Expected: 'Committed as commit 1'"
    rm -r ".girt"
    rm a
    exit 1
fi
log_output=$(sh girt-log)
if [ "$log_output" != "1 second
0 first" ]; then
    echo "Test failed girt-log"
    echo "Program: '$log_output'"
    echo "Expected: '1 second\n0 first'"
    rm -r ".girt"
    rm a
    exit 1
fi

echo "Test Passed girt-log"
rm -r ".girt"
rm a
