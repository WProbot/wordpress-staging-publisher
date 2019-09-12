#!/bin/bash

timestamp="$1"
production_user_home_dir=$(eval echo "~")

# Create a workspace inside the user's home directory
mkdir -p "$production_user_home_dir/.wordpress-staging-publisher"
mkdir -p "$production_user_home_dir/.wordpress-staging-publisher/$timestamp"
mkdir -p "$production_user_home_dir/.wordpress-staging-publisher/$timestamp/production"
mkdir -p "$production_user_home_dir/.wordpress-staging-publisher/$timestamp/console"