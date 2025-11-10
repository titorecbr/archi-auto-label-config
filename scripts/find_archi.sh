#!/bin/bash

# Script to help locate Archi installation

echo "=========================================="
echo "🔍 Finding Archi Installation"
echo "=========================================="
echo ""

found=0

# 1. Check if in PATH
echo "1️⃣ Checking if 'archi' is in PATH..."
if command -v archi &> /dev/null; then
    ARCHI_PATH=$(which archi)
    echo "   ✅ Found: $ARCHI_PATH"
    ARCHI_DIR=$(dirname "$ARCHI_PATH")
    echo "   Directory: $ARCHI_DIR"
    found=1
else
    echo "   ❌ Not found in PATH"
fi
echo ""

# 2. Search common directories
echo "2️⃣ Searching common directories..."
COMMON_DIRS=(
    "/opt/Archi"
    "/opt/archi"
    "/usr/local/Archi"
    "/usr/share/Archi"
    "$HOME/Archi"
    "$HOME/Downloads/Archi"
    "$HOME/.local/share/Archi"
    "$HOME/Apps/Archi"
    "$HOME/opt/Archi"
    "$HOME/apps/Archi"
)

for dir in "${COMMON_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "   ✅ Found: $dir"
        found=1
        
        # Check for required JARs
        if ls "$dir"/**/com.archimatetool.model_*.jar &> /dev/null; then
            echo "      🎯 THIS IS THE CORRECT DIRECTORY!"
            echo ""
            echo "      To build the plugin, run:"
            echo "      bash scripts/build_final.sh \"$dir\""
            echo ""
        fi
    fi
done

if [ $found -eq 0 ]; then
    echo "   ❌ Not found in common directories"
fi
echo ""

# 3. Look for AppImages
echo "3️⃣ Looking for Archi AppImage..."
APPIMAGES=$(find ~ ~/Downloads ~/Desktop -maxdepth 2 -name "*Archi*.AppImage" -o -name "*archi*.AppImage" 2>/dev/null)

if [ -n "$APPIMAGES" ]; then
    echo "$APPIMAGES" | while read -r appimage; do
        echo "   ✅ Found: $appimage"
        found=1
    done
    echo ""
    echo "   ℹ️  To use AppImage, extract it first:"
    echo "   1. chmod +x ArchiAppImage.AppImage"
    echo "   2. ./ArchiAppImage.AppImage --appimage-extract"
    echo "   3. bash scripts/build_final.sh ./squashfs-root"
else
    echo "   ❌ No AppImage found"
fi
echo ""

# 4. Check for running Archi processes
echo "4️⃣ Checking for running Archi processes..."
ARCHI_PROCESS=$(ps aux | grep -i archi | grep -v grep | grep -v "find_archi" | head -1)

if [ -n "$ARCHI_PROCESS" ]; then
    echo "   ✅ Archi is running!"
    
    # Try to extract path from process
    ARCHI_PID=$(echo "$ARCHI_PROCESS" | awk '{print $2}')
    if [ -n "$ARCHI_PID" ]; then
        ARCHI_EXE=$(readlink -f /proc/$ARCHI_PID/exe 2>/dev/null)
        if [ -n "$ARCHI_EXE" ]; then
            ARCHI_DIR=$(dirname "$ARCHI_EXE")
            echo "   Executable: $ARCHI_EXE"
            echo "   Directory: $ARCHI_DIR"
            
            if ls "$ARCHI_DIR"/**/com.archimatetool.model_*.jar &> /dev/null 2>&1; then
                echo "   🎯 THIS IS THE CORRECT DIRECTORY!"
                echo ""
                echo "   To build the plugin, run:"
                echo "   bash scripts/build_final.sh \"$ARCHI_DIR\""
            fi
        fi
    fi
else
    echo "   ❌ Archi is not running"
fi
echo ""

# 5. Search for Archi JARs in home directory
echo "5️⃣ Searching for Archi JARs in home directory (may take time)..."
ARCHI_JARS=$(find ~ -maxdepth 5 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -3)

if [ -n "$ARCHI_JARS" ]; then
    echo "   ✅ Archi JARs found:"
    echo "$ARCHI_JARS" | while read -r jar; do
        jar_dir=$(dirname "$jar")
        echo "   📦 $jar"
        echo "      Directory: $jar_dir"
        echo ""
        echo "      To build the plugin, run:"
        echo "      bash scripts/build_final.sh \"$jar_dir/..\""
        echo ""
    done
else
    echo "   ❌ No Archi JARs found"
fi
echo ""

# 6. Check Snap installation
echo "6️⃣ Checking Snap installation..."
if command -v snap &> /dev/null; then
    if snap list 2>/dev/null | grep -i archi &> /dev/null; then
        echo "   ✅ Archi installed via Snap!"
        SNAP_DIR="$HOME/snap/archi/current/.archi"
        echo "   Directory: $SNAP_DIR"
        
        if [ -d "$SNAP_DIR" ]; then
            echo "   🎯 Check plugins at: $SNAP_DIR/dropins"
        fi
    else
        echo "   ❌ Archi not installed via Snap"
    fi
else
    echo "   ❌ Snap not available"
fi
echo ""

# 7. Check Flatpak installation
echo "7️⃣ Checking Flatpak installation..."
if command -v flatpak &> /dev/null; then
    if flatpak list 2>/dev/null | grep -i archi &> /dev/null; then
        echo "   ✅ Archi installed via Flatpak!"
    else
        echo "   ❌ Archi not installed via Flatpak"
    fi
else
    echo "   ❌ Flatpak not available"
fi
echo ""

# Final summary
echo "=========================================="
echo "📋 SUMMARY"
echo "=========================================="
echo ""

if [ $found -eq 1 ]; then
    echo "✅ Found possible Archi installations above."
    echo ""
    echo "To build the plugin:"
    echo "1. Choose one of the directories found above"
    echo "2. Run: bash scripts/build_final.sh /path/chosen"
    echo ""
    echo "Example:"
    echo "  bash scripts/build_final.sh /opt/Archi"
else
    echo "❌ Could not find Archi installation."
    echo ""
    echo "You can:"
    echo "1. Download Archi from: https://www.archimatetool.com/download/"
    echo "2. Install in a common directory (/opt/Archi or ~/Archi)"
    echo "3. Then run: bash scripts/build_final.sh /path/installed"
    echo ""
    echo "OR"
    echo ""
    echo "Use Eclipse to compile:"
    echo "1. Import project into Eclipse"
    echo "2. Configure Archi dependencies"
    echo "3. Build automatically"
fi
echo ""

