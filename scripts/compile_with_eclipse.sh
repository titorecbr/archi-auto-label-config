#!/bin/bash

# Script para compilar o plugin usando Eclipse

echo "=========================================="
echo "Compilação do Plugin usando Eclipse"
echo "=========================================="
echo ""

# Pergunta onde está o Eclipse
if [ -z "$ECLIPSE_HOME" ]; then
    echo "Por favor, informe o caminho do Eclipse:"
    echo "Exemplo: /home/victor/eclipse/eclipse"
    echo ""
    read -p "Caminho do Eclipse: " ECLIPSE_PATH
    
    if [ ! -f "$ECLIPSE_PATH" ] && [ ! -d "$ECLIPSE_PATH" ]; then
        echo "ERRO: Eclipse não encontrado em: $ECLIPSE_PATH"
        exit 1
    fi
    
    # Se for um diretório, procura o executável
    if [ -d "$ECLIPSE_PATH" ]; then
        if [ -f "$ECLIPSE_PATH/eclipse" ]; then
            ECLIPSE_HOME="$ECLIPSE_PATH"
        else
            echo "ERRO: Executável eclipse não encontrado em: $ECLIPSE_PATH"
            exit 1
        fi
    else
        ECLIPSE_HOME=$(dirname "$ECLIPSE_PATH")
    fi
fi

echo "Eclipse encontrado em: $ECLIPSE_HOME"
echo ""

# Verifica se o projeto está no lugar certo
PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERRO: Projeto não encontrado em: $PROJECT_DIR"
    exit 1
fi

echo "Projeto encontrado em: $PROJECT_DIR"
echo ""

# Procura dependências do Archi
echo "Procurando dependências do Archi..."
ARCHI_MODEL_JAR=$(find ~/.archi /opt /usr -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
ARCHI_EDITOR_JAR=$(find ~/.archi /opt /usr -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)

if [ -z "$ARCHI_MODEL_JAR" ] || [ -z "$ARCHI_EDITOR_JAR" ]; then
    echo "AVISO: Dependências do Archi não encontradas automaticamente."
    echo "Você precisará adicioná-las manualmente no Eclipse."
    echo ""
    echo "Procure por:"
    echo "  - com.archimatetool.model_*.jar"
    echo "  - com.archimatetool.editor_*.jar"
    echo ""
    echo "Em: ~/.archi/plugins/ ou onde o Archi está instalado"
    echo ""
else
    echo "Dependências encontradas:"
    echo "  Model: $ARCHI_MODEL_JAR"
    echo "  Editor: $ARCHI_EDITOR_JAR"
    echo ""
fi

echo "=========================================="
echo "INSTRUÇÕES PARA COMPILAR:"
echo "=========================================="
echo ""
echo "1. Abra o Eclipse:"
echo "   $ECLIPSE_HOME/eclipse"
echo ""
echo "2. Importe o projeto:"
echo "   File → Import → Existing Projects into Workspace"
echo "   → Selecione: $PROJECT_DIR"
echo "   → Finish"
echo ""
if [ -n "$ARCHI_MODEL_JAR" ]; then
    echo "3. Configure dependências:"
    echo "   Properties → Java Build Path → Add External JARs"
    echo "   → Adicione: $ARCHI_MODEL_JAR"
    echo "   → Adicione: $ARCHI_EDITOR_JAR"
    echo ""
    echo "4. Compile:"
else
    echo "3. Configure dependências do Archi (veja FIND_DEPENDENCIES.md)"
    echo ""
    echo "4. Compile:"
fi
echo "   Project → Clean → Build"
echo ""
echo "5. Exporte:"
echo "   File → Export → Deployable plug-ins and fragments"
echo "   → Selecione: com.vhsystem.defaultlabel"
echo "   → Directory → Escolha uma pasta"
echo "   → Finish"
echo ""
echo "=========================================="

