#!/bin/dash
# TESTS FOR girt-init

if [ -d ".girt" ]; then
    rm -r ".girt"
fi
first_output=$(sh girt-init)
if [ "$first_output" != "Initialized empty girt repository in .girt" ]; then
    echo "Test failed girt-init"
    echo "Program: '$first_output'"
    echo "Expected: 'Initialized empty girt repository in .girt'"
    rm -r ".girt"
    exit 1
fi
second_output=$(sh girt-init 2>&1)
if [ "$second_output" != "girt-init: error: .girt already exists" ]; then
    echo "Test failed girt-init"
    echo "Program: '$second_output'"
    echo "Expected: 'girt-init: error: .girt already exists'"
    rm -r ".girt"
    exit 1
fi
echo "Test Passed girt-init"
rm -r ".girt"
