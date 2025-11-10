#!/bin/bash

# Script to reinstall the translated version of the plugin

echo "═══════════════════════════════════════════════════════════════"
echo "   REINSTALLING TRANSLATED PLUGIN"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR"

echo "1. Removing old version..."
rm -rf ~/.archi/dropins/com.vhsystem.defaultlabel_*
echo "   ✓ Old version removed"
echo ""

echo "2. Installing translated version..."
cp -r "$PROJECT_DIR/final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier" ~/.archi/dropins/
echo "   ✓ Translated version copied"
echo ""

echo "3. Cleaning OSGi cache..."
rm -rf ~/.archi/config/org.eclipse.osgi/*
echo "   ✓ Cache cleaned"
echo ""

echo "4. Verifying installation..."
if [ -d ~/.archi/dropins/com.vhsystem.defaultlabel_1.0.0.qualifier ]; then
    echo "   ✅ Plugin installed at: ~/.archi/dropins/com.vhsystem.defaultlabel_1.0.0.qualifier"
    
    # Verify English strings
    if strings ~/.archi/dropins/com.vhsystem.defaultlabel_1.0.0.qualifier/com/vhsystem/defaultlabel/dialogs/ManageLabelsDialog.class 2>/dev/null | grep -q "Manage Default Labels"; then
        echo "   ✅ Plugin is in ENGLISH"
    else
        echo "   ⚠️  Warning: Could not verify language"
    fi
else
    echo "   ❌ ERROR: Plugin not found after installation!"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ INSTALLATION COMPLETE!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Close Archi COMPLETELY (all windows)"
echo "2. Restart Archi"
echo "3. Look for 'Default Labels' menu (in English)"
echo "4. Open: Default Labels → Manage Default Labels"
echo ""
echo "Expected UI (in English):"
echo "  - Window title: 'Manage Default Labels'"
echo "  - Instruction: 'Configure default labels that will be...'"
echo "  - Column headers: 'Element Type' and 'Default Label'"
echo ""
echo "═══════════════════════════════════════════════════════════════"

