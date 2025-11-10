#!/bin/bash

# Script to restart Archi with the installed plugin

echo "═══════════════════════════════════════════════════════════════"
echo "   RESTARTING ARCHI"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Try to find Archi executable
ARCHI_EXEC=""

if [ -f "/home/victor/apps/Archi/Archi" ]; then
    ARCHI_EXEC="/home/victor/apps/Archi/Archi"
elif [ -f "$HOME/apps/Archi/Archi" ]; then
    ARCHI_EXEC="$HOME/apps/Archi/Archi"
elif [ -f "$HOME/Archi/Archi" ]; then
    ARCHI_EXEC="$HOME/Archi/Archi"
elif [ -f "/opt/Archi/Archi" ]; then
    ARCHI_EXEC="/opt/Archi/Archi"
elif command -v archi &> /dev/null; then
    ARCHI_EXEC="archi"
else
    echo "❌ ERROR: Could not find Archi executable"
    echo "   Please start Archi manually"
    exit 1
fi

echo "1. Closing all Archi instances..."
pkill -9 -f Archi 2>/dev/null
sleep 2

if ps aux | grep -i "Archi" | grep -v grep > /dev/null; then
    echo "   ⚠️  Archi still running, trying again..."
    pkill -9 -f "Archi"
    sleep 2
fi

if ps aux | grep -i "Archi" | grep -v grep > /dev/null; then
    echo "   ❌ ERROR: Could not close Archi"
    echo "   Please close Archi manually and run this script again"
    exit 1
else
    echo "   ✓ Archi closed"
fi

echo ""
echo "2. Starting Archi..."
$ARCHI_EXEC > /tmp/archi.log 2>&1 &
ARCHI_PID=$!
echo "   ✓ Archi started (PID: $ARCHI_PID)"
echo ""

echo "3. Waiting for Archi to initialize..."
sleep 5
echo "   ✓ Archi should be ready"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "✅ ARCHI RESTARTED!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "NOW CHECK:"
echo ""
echo "  ✓ Menu shows: 'Tools → Manage Default Labels'"
echo "  ✓ Click: Tools → Manage Default Labels"
echo "  ✓ Dialog title should be: 'Manage Default Labels'"
echo "  ✓ Columns should be: 'Element Type' and 'Default Label'"
echo ""
echo "If the plugin doesn't appear, check the logs:"
echo "  tail -f /tmp/archi.log"
echo ""
echo "═══════════════════════════════════════════════════════════════"

