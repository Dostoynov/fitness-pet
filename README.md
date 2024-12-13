# React Boilerplate

## First time setup

```sh
pnpm install
pnpm run dev
```

## Before any commit

```sh
pnpm run release:check
```

## Local Development with UI Libraries

To debug UI libraries locally, follow these steps:

1. Build your local UI libraries:

```bash
# In your UI library directory
cd path/to/somelib
pnpm install
pnpm build
pnpm pack
```

2. Set up environment variables:

```bash
# Make scripts executable
chmod +x scripts/reinstall-apps-ui.sh scripts/reinstall-apps-lib.sh

# Copy the development environment file
cp .env.development .env.development.local

# Edit .env.development.local and set the absolute paths to your local packages:
APPS_UI_PATH="/absolute/path/to/somelib/somelib-*.tgz""
```

3. Install the local packages:

```bash
# For UI library
cd ../somelib
pnpm install
pnpm build
pnpm pack
cd -
pnpm run reinstall:apps-ui
```

4. After making changes to the libraries:
   - Rebuild the library (`pnpm build && pnpm pack`)
   - Run the corresponding reinstall script (`pnpm run reinstall:somelib`)
   - Restart your development server if needed

Note: Make sure to use absolute paths in your .env.development.local file to avoid any path resolution issues.
