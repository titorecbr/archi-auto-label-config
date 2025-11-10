#!/bin/bash

# Script interativo para compilar o plugin

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"

echo "=========================================="
echo "Compilação do Plugin - Default Label Plugin"
echo "=========================================="
echo ""

# Pergunta onde está o Eclipse
echo "Onde você instalou o Eclipse?"
echo "Exemplos:"
echo "  ~/eclipse/eclipse"
echo "  ~/Downloads/eclipse/eclipse"
echo "  /opt/eclipse/eclipse"
echo ""
read -p "Caminho completo do executável do Eclipse: " ECLIPSE_PATH

if [ ! -f "$ECLIPSE_PATH" ]; then
    echo "ERRO: Eclipse não encontrado em: $ECLIPSE_PATH"
    exit 1
fi

ECLIPSE_HOME=$(dirname "$ECLIPSE_PATH")
echo ""
echo "✓ Eclipse encontrado: $ECLIPSE_PATH"
echo ""

# Pergunta sobre workspace
echo "Onde você quer criar o workspace do Eclipse?"
echo "(pressione Enter para usar: $PROJECT_DIR/../eclipse-workspace)"
read -p "Caminho do workspace: " WORKSPACE_DIR

if [ -z "$WORKSPACE_DIR" ]; then
    WORKSPACE_DIR="$PROJECT_DIR/../eclipse-workspace"
fi

mkdir -p "$WORKSPACE_DIR"
echo "✓ Workspace: $WORKSPACE_DIR"
echo ""

# Procura dependências do Archi
echo "Procurando dependências do Archi..."
ARCHI_MODEL=$(find ~/.archi /opt /usr -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
ARCHI_EDITOR=$(find ~/.archi /opt /usr -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)

if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
    echo "✓ Dependências encontradas:"
    echo "  Model: $ARCHI_MODEL"
    echo "  Editor: $ARCHI_EDITOR"
    ARCHI_PLUGINS_DIR=$(dirname "$ARCHI_MODEL")
else
    echo "⚠ Dependências não encontradas automaticamente"
    echo ""
    echo "Onde está instalado o Archi?"
    read -p "Caminho da pasta plugins do Archi: " ARCHI_PLUGINS_DIR
fi

echo ""
echo "=========================================="
echo "RESUMO DA CONFIGURAÇÃO"
echo "=========================================="
echo "Eclipse: $ECLIPSE_PATH"
echo "Workspace: $WORKSPACE_DIR"
echo "Projeto: $PROJECT_DIR"
if [ -n "$ARCHI_PLUGINS_DIR" ]; then
    echo "Plugins Archi: $ARCHI_PLUGINS_DIR"
fi
echo ""
echo "=========================================="
echo ""
echo "Agora vou abrir o Eclipse para você..."
echo "Siga as instruções em COMPILAR_AGORA.txt"
echo ""
read -p "Pressione Enter para abrir o Eclipse..."

# Abre o Eclipse
"$ECLIPSE_PATH" -data "$WORKSPACE_DIR" &

echo ""
echo "Eclipse aberto! Agora siga os passos em COMPILAR_AGORA.txt"
echo ""

