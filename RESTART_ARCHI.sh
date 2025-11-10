#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "   RESTARTING ARCHI WITH TRANSLATED PLUGIN"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "1. Closing all Archi instances..."
pkill -9 -f Archi 2>/dev/null
sleep 2

if ps aux | grep -i "Archi/jre" | grep -v grep > /dev/null; then
    echo "   ⚠️  Archi still running, trying again..."
    pkill -9 -f "Archi"
    sleep 2
fi

if ps aux | grep -i "Archi/jre" | grep -v grep > /dev/null; then
    echo "   ❌ ERROR: Could not close Archi"
    echo "   Please close Archi manually and run this script again"
    exit 1
else
    echo "   ✓ Archi closed"
fi

echo ""
echo "2. Starting Archi..."
/home/victor/apps/Archi/Archi > /tmp/archi-translated.log 2>&1 &
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
echo "  ✓ Menu shows: 'Default Labels' (not 'Labels Padrão')"
echo "  ✓ Click: Default Labels → Manage Default Labels"
echo "  ✓ Dialog title should be: 'Manage Default Labels'"
echo "  ✓ Columns should be: 'Element Type' and 'Default Label'"
echo ""
echo "If still in Portuguese, check the logs:"
echo "  tail -f /tmp/archi-translated.log"
echo ""
echo "═══════════════════════════════════════════════════════════════"

