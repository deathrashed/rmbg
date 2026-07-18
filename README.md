<p align="center">
  <img src="./assets/rmbg-icon.svg" width="500" alt="rmbg icon">
</p>

<h1 align="center">rmbg</h1>

<p align="center">
  <a href="#installation">
    <img src="https://img.shields.io/badge/Install-Manual-06B6D4?style=for-the-badge&logo=download&logoColor=white&labelColor=202020" alt="Install">
  </a>
  <a href="#usage">
    <img src="https://img.shields.io/badge/Usage-CLI-8B5CF6?style=for-the-badge&logo=terminal&logoColor=white&labelColor=202020" alt="Usage">
  </a>
  <a href="https://imagemagick.org/">
    <img src="https://img.shields.io/badge/Powered-ImageMagick-FF5A52?style=for-the-badge&logo=imagemagick&logoColor=white&labelColor=202020" alt="ImageMagick">
  </a>
</p>

Remove solid color backgrounds from images using ImageMagick. Works with PNG, JPG, JPEG, GIF, and ICNS files.

---

## Index

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Scripts](#scripts)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)

---

## <img src="https://api.iconify.design/lucide:info.svg?color=%2306B6D4" width="22" height="22" alt="Info icon"> Overview

rmbg is a command-line tool that removes solid color backgrounds from images. It uses ImageMagick's fuzz and flood-fill capabilities to detect and remove backgrounds, then cleans rough edges with a border technique.

### Features

- <img src="https://api.iconify.design/lucide:image.svg?color=%2306B6D4" width="14" height="14" alt="Image icon"> Supports PNG, JPG, JPEG, GIF, and ICNS
- <img src="https://api.iconify.design/lucide:folder.svg?color=%2306B6D4" width="14" height="14" alt="Folder icon"> Batch processing for folders
- <img src="https://api.iconify.design/lucide:folder-search.svg?color=%2306B6D4" width="14" height="14" alt="Folder search icon"> Recursive subfolder processing
- <img src="https://api.iconify.design/lucide:search.svg?color=%2306B6D4" width="14" height="14" alt="Search icon"> Filter by filename pattern
- <img src="https://api.iconify.design/lucide:sparkles.svg?color=%2306B6D4" width="14" height="14" alt="Sparkles icon"> Smart background color auto-detection (uses top-left corner)
- <img src="https://api.iconify.design/lucide:brush.svg?color=%2306B6D4" width="14" height="14" alt="Brush icon"> Edge smoothing and anti-aliasing
- <img src="https://api.iconify.design/lucide:palette.svg?color=%2306B6D4" width="14" height="14" alt="Palette icon"> Grayscale conversion to strip colored halos from logo outlines
- <img src="https://api.iconify.design/lucide:wand.svg?color=%2306B6D4" width="14" height="14" alt="Wand icon"> HSB saturation + darkness mask (logo/stencil mode)
- <img src="https://api.iconify.design/lucide:aperture.svg?color=%2306B6D4" width="14" height="14" alt="Aperture icon"> AppleScript integration for Finder
- <img src="https://api.iconify.design/lucide:eye.svg?color=%2306B6D4" width="14" height="14" alt="Eye icon"> Auto-open results

---

## <img src="https://api.iconify.design/lucide:package.svg?color=%2306B6D4" width="22" height="22" alt="Package icon"> Prerequisites

| Dependency | Required | Installation |
| :--- | :---: | :--- |
| ImageMagick | Yes | `brew install imagemagick` |
| Python 3 | Yes | Pre-installed on macOS |
| PIL (Pillow) | For ICNS | `pip install pillow` |

Verify dependencies:

```bash
convert --version
python3 -c "from PIL import Image; print('PIL OK')"
```

---

## <img src="https://api.iconify.design/lucide:download.svg?color=%2306B6D4" width="22" height="22" alt="Download icon"> Installation

### Quick Install

```bash
~/Scripts/Riley/rmbg/install.sh
```

The install script will:
- Verify/install dependencies (ImageMagick, PIL)
- Create symlink in `~/bin/rmbg`
- Add shell completion to `~/.bashrc` / `~/.zshrc`
- Install man page

### Manual Install

```bash
# Symlink to ~/bin
ln -s ~/Scripts/Riley/rmbg/bin/rmbg ~/bin/rmbg

# Or link to system PATH
sudo ln -s ~/Scripts/Riley/rmbg/bin/rmbg /usr/local/bin/rmbg

# Shell completion
source ~/Scripts/Riley/rmbg/completions/rmbg.bash

# Man page
cp ~/Scripts/Riley/rmbg/man/man1/rmbg.1 /usr/local/share/man/man1/
mandb
```

---

## <img src="https://api.iconify.design/lucide:terminal.svg?color=%2306B6D4" width="22" height="22" alt="Terminal icon"> Usage

### Basic Commands

```bash
# Single file - auto-detect background color (default)
rmbg image.png

# Single file - white background explicitly
rmbg image.png -w

# Single file - smooth edges & desaturate (kills colored edge halos on black/white logos)
rmbg image.png -a -d

# Smart Logo mode - HSB saturation + darkness mask (great for textured/smoke backgrounds)
rmbg image.png -L -a

# Folder - process all images
rmbg folder/

# Folder - recursive, only logo files
rmbg folder/ -R -m "logo"

# Replace originals
rmbg folder/ -r -R

# Open result after processing
rmbg image.png -o

# Custom background color
rmbg image.png -b "#FF0000"
rmbg image.png -b "white"
```

### Command Reference

| Command | Purpose | Notes |
| :--- | :--- | :--- |
| `rmbg image.png` | Process single file | Output: `image_clean.png` |
| `rmbg folder/` | Process folder | Only top-level files |
| `rmbg folder/ -R` | Recursive processing | Includes subfolders |
| `rmbg -m "logo"` | Filter by pattern | Only files containing "logo" |
| `rmbg -r` | Replace originals | Warning: overwrites input |
| `rmbg -o` | Open after processing | Uses `open` command |
| `rmbg -w` | White background | Shorthand for `-b white` |
| `rmbg -f 25` | Fuzz percentage | Higher = more aggressive matching |

### Options Detail

| Option | Alias | Default | Description |
| :--- | :---: | :--- | :--- |
| `--prefix` | `-p` | (none) | Add prefix to output filename |
| `--suffix` | `-s` | `_clean` | Add suffix to output filename |
| `--replace` | `-r` | false | Replace original file |
| `--open` | `-o` | false | Open result after processing |
| `--fuzz` | `-f` | 15 | Color matching fuzz percentage |
| `--recursive` | `-R` | false | Process subfolders |
| `--background` | `-b` | auto | Background color (or auto to detect) |
| `--white` | `-w` | false | Shorthand for white background |
| `--logo` | `-L` | false | Use smart logo mode (HSB saturation + darkness mask) |
| `--antialias` | `-a` | false | Smooth/anti-alias the output edges |
| `--desaturate` | `-d` | false | Convert output logo to grayscale (kills colored halos) |
| `--match` | `-m` | (none) | Filter files by pattern |
| `--verbose` | `-v` | false | Show processing details |
| `--help` | `-h` | - | Show help message |

---

## <img src="https://api.iconify.design/lucide:file-code.svg?color=%238B5CF6" width="22" height="22" alt="Code icon"> Scripts

Helper scripts included in `scripts/`:

### AppleScript

| Script | Purpose | Installation |
| :--- | :--- | :--- |
| `rmbg-finder.applescript` | Finder Services integration | Copy to `~/Library/Services/` |
| `rmbg-drop.applescript` | Drag and drop handler | Make into app with Script Editor |

### Shell Scripts

| Script | Purpose | Usage |
| :--- | :--- | :--- |
| `rmbg-watch.sh` | Watch folder for new images | `./rmbg-watch.sh <folder> [options]` |
| `rmbg-batch.sh` | Process multiple folders | `./rmbg-batch.sh folder1 folder2` |
| `rmbg-km-wrapper.sh` | Process Finder selection for KM | Called by KM macros |

### Keyboard Maestro Toolset

We provide a pre-built Keyboard Maestro macro bundle in [RMBG_Toolset.kmmacros](./RMBG_Toolset.kmmacros) that integrates directly with macOS Finder selection. It imports into your existing `Finder - Convert` palette and provides 5 distinct macro options:

1. **RMBG - Auto-detect Background**: Automatically detects the solid background color and keys it out, saving to a new `*_clean.png` file next to the original.
2. **RMBG - Auto-detect & Replace Original**: Auto-detects the background color and overwrites/replaces the original file (safely converts JPG/JPEG to transparent PNG and deletes the original JPG).
3. **RMBG - Grayscale Logo (Kill Halos)**: Auto-detects background, smooths edges (anti-aliases), and desaturates output (perfect for black/white logo extraction).
4. **RMBG - Smart Logo (Textured Background)**: Uses HSB saturation + darkness mask to cleanly extract logos from foggy, smoking, or textured backgrounds.
5. **RMBG - Custom Color Removal (Prompt)**: Prompts you for a custom color, fuzz factor, toggles for antialiasing/desaturation, and a toggle for "Replace Original".

These macros are powered by [rmbg-km-wrapper.sh](./scripts/rmbg-km-wrapper.sh) to ensure zero logic duplication.

### Automator Quick Action

Create a Finder Quick Action:

1. **Automator > New > Quick Action**
2. **Workflow receives**: `files or folders` in `any application`
3. **Add "Run Shell Script"** action:
   - Shell: `/bin/bash`
   - Pass input: `as arguments`
   - Code:
     ```bash
     "/Users/rd/Scripts/Riley/rmbg/bin/rmbg-automator" "$@"
     ```
4. **Save** as "rmbg"

Now right-click any image/folder in Finder and select **Quick Actions > rmbg**

### Installing AppleScript as Finder Service

1. Open `rmbg-finder.applescript` in Script Editor
2. Save to `~/Library/Services/`
3. Select files in Finder, right-click > Services > rmbg

### Installing AppleScript as App

1. Open `rmbg-drop.applescript` in Script Editor
2. Export as Application
3. Drag files/folders onto the app icon

---

## <img src="https://api.iconify.design/lucide:sliders.svg?color=%2306B6D4" width="22" height="22" alt="Sliders icon"> Configuration

No configuration file required. All options are passed via command-line arguments.

### Environment Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `RMBG_FUZZ` | Default fuzz percentage | `15` |
| `RMBG_BG` | Default background color | `black` |

---

## <img src="https://api.iconify.design/lucide:folder-tree.svg?color=%2306B6D4" width="22" height="22" alt="Folder icon"> Project Structure

```
rmbg/
├── README.md              # This file
├── install.sh             # Installation script
├── bin/
│   └── rmbg              # Main executable
├── scripts/
│   ├── rmbg-finder.applescript
│   ├── rmbg-drop.applescript
│   ├── rmbg-watch.sh
│   └── rmbg-batch.sh
├── completions/
│   └── rmbg.bash          # Shell completion
├── man/
│   └── man1/
│       └── rmbg.1        # Man page
├── lib/                   # (reserved for future)
└── assets/
    └── rmbbg-icon.svg    # Project icon
```

---

## <img src="https://api.iconify.design/lucide:life-buoy.svg?color=%2306B6D4" width="22" height="22" alt="Life buoy icon"> Troubleshooting

### "no matches found" Error

When using glob patterns in zsh, escape or quote arguments:

```bash
rmbg "/Volumes/Folder/Artist" -R
```

### ImageMagick Not Found

Ensure ImageMagick is installed and in your PATH:

```bash
brew install imagemagick
export PATH="/usr/local/opt/imagemagick/bin:$PATH"
```

### ICNS Conversion Fails

Install Pillow for ICNS support:

```bash
pip install pillow
```

### Slow Processing

Reduce fuzz percentage for faster processing:

```bash
rmbg image.png -f 5
```

---

## <img src="https://api.iconify.design/lucide:wrench.svg?color=%2306B6D4" width="22" height="22" alt="Wrench icon"> Maintenance

### Update rmbg

Pull latest changes or reinstall:

```bash
# Update binary
cp ~/Scripts/Riley/rmbg/bin/rmbg ~/bin/rmbg

# Or re-run install
~/Scripts/Riley/rmbg/install.sh
```

### Add New Formats

To add support for additional image formats, edit `bin/rmbg` and add the extension to the file glob patterns:

```bash
# In bin/rmbg, find and add:
# For WebP support:
"$input"/*.webp
```

### Uninstall

```bash
rm ~/bin/rmbg
rm ~/Library/Services/rmbg-finder.applescript
rm -rf ~/Scripts/Riley/rmbg
```