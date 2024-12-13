#!/bin/sh

# Load environment variables in order of priority
for env_file in .env.development.local
do
  if [ -f "$env_file" ]; then
    export $(cat "$env_file" | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}')
  fi
done

PACKAGE_NAME="@p2p-org/p2pwebsite-apps-lib"

if [ -z "$APPS_LIB_PATH" ]; then
  echo "Error: APPS_LIB_PATH is not set in any .env file"
  echo "Please set APPS_LIB_PATH to the absolute path of your local library package"
  echo "Example: APPS_LIB_PATH=\"/Users/username/projects/p2pwebsite-apps-lib/p2p-org-p2pwebsite-apps-lib-*.tgz\""
  exit 1
fi

if ! ls $APPS_LIB_PATH >/dev/null 2>&1; then
  echo "Error: No package found at $APPS_LIB_PATH"
  echo "Please check if the path is correct and the package has been built"
  exit 1
fi

echo "Checking if $PACKAGE_NAME is installed..."
pnpm list $PACKAGE_NAME

echo "Removing $PACKAGE_NAME..."
pnpm remove $PACKAGE_NAME

echo "Installing latest local build of $PACKAGE_NAME..."
pnpm add file:$(ls -t $APPS_LIB_PATH | head -1)

echo "Installation complete!"
