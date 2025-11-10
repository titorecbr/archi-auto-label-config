#!/bin/bash

# Script para configurar e compilar automaticamente usando Eclipse headless

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
WORKSPACE_DIR="$PROJECT_DIR/../eclipse-workspace"

echo "=========================================="
echo "Configuração Automática do Eclipse"
echo "=========================================="
echo ""

# Encontra o Eclipse
ECLIPSE_PATH=""
for path in ~/eclipse/eclipse ~/Downloads/eclipse/eclipse ~/Desktop/eclipse/eclipse /opt/eclipse/eclipse; do
    if [ -f "$path" ]; then
        ECLIPSE_PATH="$path"
        break
    fi
done

if [ -z "$ECLIPSE_PATH" ]; then
    echo "Eclipse não encontrado automaticamente."
    echo "Por favor, informe o caminho completo do executável do Eclipse:"
    read -p "Caminho: " ECLIPSE_PATH
fi

if [ ! -f "$ECLIPSE_PATH" ]; then
    echo "ERRO: Eclipse não encontrado em: $ECLIPSE_PATH"
    exit 1
fi

ECLIPSE_HOME=$(dirname "$ECLIPSE_PATH")
echo "Eclipse encontrado: $ECLIPSE_PATH"
echo ""

# Cria workspace
mkdir -p "$WORKSPACE_DIR"
echo "Workspace criado: $WORKSPACE_DIR"
echo ""

# Encontra dependências do Archi
echo "Procurando dependências do Archi..."
ARCHI_PLUGINS=""
for dir in ~/.archi/plugins /opt/archi/plugins /usr/share/archi/plugins; do
    if [ -d "$dir" ]; then
        ARCHI_PLUGINS="$dir"
        break
    fi
done

if [ -z "$ARCHI_PLUGINS" ]; then
    echo "AVISO: Pasta de plugins do Archi não encontrada."
    echo "Você precisará adicionar as dependências manualmente."
else
    echo "Plugins do Archi encontrados em: $ARCHI_PLUGINS"
fi

echo ""
echo "=========================================="
echo "PRÓXIMOS PASSOS MANUAIS:"
echo "=========================================="
echo ""
echo "1. Abra o Eclipse:"
echo "   $ECLIPSE_PATH -data $WORKSPACE_DIR"
echo ""
echo "2. Quando perguntar sobre o workspace, escolha:"
echo "   $WORKSPACE_DIR"
echo ""
echo "3. Importe o projeto:"
echo "   File → Import → Existing Projects into Workspace"
echo "   → Selecione: $PROJECT_DIR"
echo ""
if [ -n "$ARCHI_PLUGINS" ]; then
    echo "4. Configure dependências:"
    echo "   Properties → Java Build Path → Add External JARs"
    echo "   → Navegue até: $ARCHI_PLUGINS"
    echo "   → Selecione: com.archimatetool.model_*.jar"
    echo "   → Selecione: com.archimatetool.editor_*.jar"
    echo ""
    echo "5. Compile: Project → Clean → Build"
    echo ""
    echo "6. Exporte: File → Export → Deployable plug-ins"
else
    echo "4. Configure dependências do Archi manualmente"
    echo "5. Compile: Project → Clean → Build"
    echo "6. Exporte: File → Export → Deployable plug-ins"
fi
echo ""
echo "=========================================="

