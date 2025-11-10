#!/bin/bash

# Script rápido para preparar compilação

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"

echo "=========================================="
echo "Preparação para Compilação"
echo "=========================================="
echo ""

# Encontra dependências do Archi
echo "Procurando dependências do Archi em ~/.archi..."
ARCHI_MODEL=$(find ~/.archi -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
ARCHI_EDITOR=$(find ~/.archi -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)

if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
    echo "✓ Dependências encontradas!"
    echo "  Model: $ARCHI_MODEL"
    echo "  Editor: $ARCHI_EDITOR"
    ARCHI_PLUGINS_DIR=$(dirname "$ARCHI_MODEL")
    echo "  Pasta: $ARCHI_PLUGINS_DIR"
    echo ""
    
    # Salva informações
    echo "$ARCHI_MODEL" > /tmp/archi_model_jar.txt
    echo "$ARCHI_EDITOR" > /tmp/archi_editor_jar.txt
    echo "$ARCHI_PLUGINS_DIR" > /tmp/archi_plugins_dir.txt
    
    echo "Informações salvas em /tmp/archi_*.txt"
else
    echo "⚠ Dependências não encontradas em ~/.archi"
    echo "Procure manualmente ou instale o Archi primeiro"
    exit 1
fi

echo ""
echo "=========================================="
echo "PRÓXIMOS PASSOS:"
echo "=========================================="
echo ""
echo "1. Abra o Eclipse"
echo ""
echo "2. Escolha um workspace (ex: $PROJECT_DIR/../eclipse-workspace)"
echo ""
echo "3. Importe o projeto:"
echo "   File → Import → Existing Projects"
echo "   → $PROJECT_DIR"
echo ""
echo "4. Configure dependências:"
echo "   Properties → Java Build Path → Add External JARs"
echo "   → $ARCHI_MODEL"
echo "   → $ARCHI_EDITOR"
echo ""
echo "5. Compile: Project → Clean → Build"
echo ""
echo "6. Exporte: File → Export → Deployable plug-ins"
echo ""
echo "=========================================="
echo ""
echo "OU execute: ./execute_compile.sh"
echo ""

