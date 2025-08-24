#!/bin/bash

# Function to handle directory changes and script execution
run_script_in_directory() {
  local dir="$1"
  local script="$2"
  cd "$dir" || { echo "Failed to change directory to $dir"; exit 1; }
  bash "$script"
  cd "$original_dir" || { echo "Failed to return to the original directory"; exit 1; }
}

# Function to copy the APK file
copy_apk() {
  local apk_path="output/app/android/agri-expert.apk"

  # Remove the existing APK file if it exists
  if [ -f "$apk_path" ]; then
    echo "Deleting existing APK: $apk_path"
    rm "$apk_path"
  else
    echo "No existing APK found at $apk_path"
  fi

  # Copy the new APK file code/agriapp/build/app/outputs/flutter-apk/app-release.apk
  cp code/agriapp/build/app/outputs/flutter-apk/app-release.apk "$apk_path"
}

# Function to handle Git operations
handle_git() {
  # Uncomment if initializing a new Git repository
  # git init

  git add .
  git commit -m "i commit"

  # Uncomment and set the remote repository URL if not already set
  # git remote add origin https://github.com/agriai444/agri-ai.git

  # Uncomment if renaming the default branch to 'main'
  # git branch -M main

  git push -u origin main
}

# Main script execution

# Save the current directory to return to later
original_dir=$(pwd)


run_script_in_directory "code/admin-web" "d.sh"

run_script_in_directory "code/agriapp" "build.sh"


copy_apk


handle_git
