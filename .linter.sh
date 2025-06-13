#!/bin/bash
cd /home/kavia/workspace/code-generation/recipevault-49442-3171c2b7/recipeappfrontend
npm run build
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
   exit 1
fi

