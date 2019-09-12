#!/bin/bash

timestamp="$1"
staging_user_home_dir=$(eval echo "~")

# Create a workspace inside the user's home directory
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher"
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp"
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging"