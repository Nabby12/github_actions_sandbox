#!/bin/sh -l

sample_input="$INPUT_SAMPLE_INPUT"

echo $sample_input

SAMPLE_OUTPUT="${sample_input}"" -> sample_output"

echo "::add-mask::$SAMPLE_OUTPUT"
echo "::set-output name=sample_output::$SAMPLE_OUTPUT"
