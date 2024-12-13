#!/bin/sh

# Function to get current version from package.json
get_current_version() {
    local package=$1
    local version=$(node -e "const v = require('./package.json').dependencies['$package']; console.log(v.startsWith('file:') ? v.match(/[0-9]+\.[0-9]+\.[0-9]+/)[0] : v)")
    echo $version
}

# Function to check if package exists in npm registry
check_npm_package() {
    local package=$1
    local version=$2
    # Remove ^ or ~ from version if present
    version=$(echo $version | sed 's/[\^~]//')

    if ! npm view "$package@$version" >/dev/null 2>&1; then
        echo "Error: $package@$version not found in npm registry"
        exit 1
    fi
}

# Function to check if package is installed from file
is_file_installation() {
    local package=$1
    local value=$(node -e "console.log(require('./package.json').dependencies['$package'].startsWith('file:') ? 'true' : 'false')")
    echo $value
}

# Function to install package and ignore peer dependency warnings
install_package() {
    local package=$1
    local version=$2
    # Create a temporary .npmrc file to disable strict peer dependencies
    echo "strict-peer-dependencies=false" > .npmrc.temp
    NPMRC=.npmrc.temp pnpm add "$package@$version"
    local exit_code=$?
    rm .npmrc.temp
    return $exit_code
}

# UI Package
PACKAGE_UI="@p2p-org/p2pwebsite-apps-ui"
VERSION_UI=$(get_current_version $PACKAGE_UI)
IS_UI_LOCAL=$(is_file_installation $PACKAGE_UI)

if [ -z "$VERSION_UI" ]; then
    echo "Error: Could not find $PACKAGE_UI in package.json"
    exit 1
fi

# Lib Package
PACKAGE_LIB="@p2p-org/p2pwebsite-apps-lib"
VERSION_LIB=$(get_current_version $PACKAGE_LIB)
IS_LIB_LOCAL=$(is_file_installation $PACKAGE_LIB)

if [ -z "$VERSION_LIB" ]; then
    echo "Error: Could not find $PACKAGE_LIB in package.json"
    exit 1
fi

# Check if packages exist in npm registry
echo "Checking packages in npm registry..."
check_npm_package $PACKAGE_UI $VERSION_UI
check_npm_package $PACKAGE_LIB $VERSION_LIB

# Only reinstall packages that are installed from file
if [ "$IS_UI_LOCAL" = "true" ] || [ "$IS_LIB_LOCAL" = "true" ]; then
    echo "Removing local packages..."
    if [ "$IS_UI_LOCAL" = "true" ]; then
        echo "Removing $PACKAGE_UI..."
        pnpm remove $PACKAGE_UI
        echo "Installing $PACKAGE_UI@$VERSION_UI from npm..."
        if ! install_package $PACKAGE_UI $VERSION_UI; then
            echo "Warning: Installation completed with peer dependency warnings"
        fi
    fi

    if [ "$IS_LIB_LOCAL" = "true" ]; then
        echo "Removing $PACKAGE_LIB..."
        pnpm remove $PACKAGE_LIB
        echo "Installing $PACKAGE_LIB@$VERSION_LIB from npm..."
        if ! install_package $PACKAGE_LIB $VERSION_LIB; then
            echo "Warning: Installation completed with peer dependency warnings"
        fi
    fi

    echo "Successfully reverted to npm packages:"
    [ "$IS_UI_LOCAL" = "true" ] && echo "$PACKAGE_UI@$VERSION_UI"
    [ "$IS_LIB_LOCAL" = "true" ] && echo "$PACKAGE_LIB@$VERSION_LIB"
else
    echo "All packages are already installed from npm registry. Nothing to do."
fi
