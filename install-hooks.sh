#!/bin/bash

# Copy all hooks from the .githooks directory to the .git/hooks directory
cp -r .githooks/* .git/hooks/

# Make sure all hooks are executable
chmod +x .git/hooks/*
