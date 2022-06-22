#!/bin/bash

git pull
git add -u ./*
git commit -m "$1"
git push -u

chmod -R 770 *

