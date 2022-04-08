#!/bin/dash
# TEST FOR girt-rm
if [ -d ".girt" ]; then
    rm -r ".girt"
fi
if [ -f "a" ]; then
    rm  "a"
fi
if [ -f "b" ]; then
    rm  "b"
fi

rm_no_girt=$(sh girt-rm a b 2>&1)
if [ "$rm_no_girt" != "girt-rm: error: girt repository directory .girt not found" ]; then
    echo "Test failed girt-rm"
    echo "Program: '$rm_no_girt'"
    echo "Expected: 'girt-rm: error: girt repository directory .girt not found'"
    exit 1
fi

output_init=$(sh girt-init)
rm_invalid_file=$(sh girt-rm a c 2>&1)
if [ "$rm_invalid_file" != "girt-rm: error: 'a' is not in the girt repository" ]; then
    echo "Test failed girt-rm"
    echo "Program: '$rm_invalid_file'"
    echo "Expected: 'girt-rm: error: 'a' is not in the girt repository'"
    rm -r ".girt"
    exit 1
fi
touch a
touch b
add_a=$(sh girt-add a b 2>&1)
if ! [ -e ".girt/index/master/a" ]; then
    echo "Test failed girt-rm"
    echo "'a' was not added to the index"
    echo "Program printed: $add_a"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
rm_cant_delete=$(sh girt-rm a b 2>&1)
if [ "$rm_cant_delete" != "girt-rm: error: 'a' has staged changes in the index" ]; then
    echo "Test failed girt-rm"
    echo "Program: '$rm_cant_delete'"
    echo "Expected: 'girt-rm: error: 'a' has staged changes in the index'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
commit_first=$(sh girt-commit -m 'first')
if [ "$commit_first" != "Committed as commit 0" ]; then
    echo "Test failed girt-rm"
    echo "Program: '$commit_first'"
    echo "Expected: 'Committed as commit 0'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
rm_can_delete=$(sh girt-rm a b)
if [ -f "a" ] || [ -f "b" ]; then
    echo "Test failed girt-rm"
    echo "Program: 'Files have not been deleted'"
    echo "Expected: 'Both a and b to be deleted'"
    rm -r ".girt"
    rm a
    rm b
    exit 1
fi
echo "Test Passed girt-rm"
rm -r ".girt"
