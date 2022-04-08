#!/bin/dash
# TEST FOR girt-show
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi

show_no_girt=$(sh girt-show '0:a' 2>&1)
if [ "$show_no_girt" != "girt-show: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-show"
    echo "Program: '$log_show_girt'"
    echo "Expected: 'girt-show: error: girt repository directory .girt not found'"
    exit 1
fi

output_init=$(sh girt-init)

show_not_in_index=$(sh girt-show ':a' 2>&1)
if [ "$show_not_in_index" != "girt-show: error: 'a' not found in index" ]; then
    echo "Test failed girt-show"
    echo "Program: '$how_not_in_index'"
    echo "Expected: 'girt-show: error: 'a' not found in indexd'"
    rm -r ".girt"
    exit 1
fi
echo "show 1 test" > a
add_a=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-show"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    exit 1
fi
commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-show"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi
echo "show 2 test" > a
add_a_1=$(sh girt-add a)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-show"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a_1"
    rm -r ".girt"
    rm a
    exit 1
fi

show_index=$(sh girt-show ':a')
if [ "$show_index" != "show 2 test" ]; then
    echo "Test failed girt-show"
    echo "Program: '$show_index'"
    echo "Expected: 'show 2 test'"
    rm -r ".girt"
    rm a
    exit 1
fi
show_commit=$(sh girt-show '0:a')
if [ "$show_commit" != "show 1 test" ]; then
    echo "Test failed girt-show"
    echo "Program: '$show_commit'"
    echo "Expected: 'show 1 test'"
    rm -r ".girt"
    rm a
    exit 1
fi
show_wrong_commit=$(sh girt-show '1:a' 2>&1)
if [ "$show_wrong_commit" != "girt-show: error: unknown commit '1'" ]; then
    echo "Test failed girt-show"
    echo "Program: '$show_wrong_commit'"
    echo "Expected: 'girt-show: error: unknown commit '1'"
    rm -r ".girt"
    rm a
    exit 1
fi
show_wrong_file=$(sh girt-show '0:b' 2>&1)
if [ "$show_wrong_file" != "girt-show: error: 'b' not found in commit 0" ]; then
    echo "Test failed girt-show"
    echo "Program: '$show_wrong_file'"
    echo "Expected: 'girt-show: error: 'b' not found in commit 0'"
    rm -r ".girt"
    rm a
    exit 1
fi
echo "Test Passed girt-show"
rm -r ".girt"
rm a
