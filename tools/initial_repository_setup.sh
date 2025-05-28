#!/usr/bin/env bash

# Configure git hooks directory to 'build/hooks'

git config --local core.hooksPath ./tools/hooks
chmod +x ./tools/hooks/pre-commit
echo "Git hooks configured!"
