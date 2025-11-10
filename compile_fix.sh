#!/bin/bash

# Script de compilação rápida após correção de bug

PROJECT_DIR="/home/victor/Projetos/VH System/archi-auto-label-config"
OUTPUT_DIR="$PROJECT_DIR/final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier"

echo "=========================================="
echo "Compilando correção de bug"
echo "=========================================="
echo ""

# Procura pelo Archi em vários locais
echo "Procurando instalação do Archi..."

SEARCH_LOCATIONS=(
    "$HOME/.archi/plugins"
    "/opt/Archi"
    "/opt/archi"
    "/usr/share/Archi"
    "/usr/local/Archi"
    "$HOME/Archi"
    "$HOME/Downloads/Archi"
    "$HOME/opt/Archi"
    "$HOME/Apps/Archi"
    "$HOME/.local/share/applications/Archi"
)

ARCHI_DIR=""

# Procura em locais conhecidos
for loc in "${SEARCH_LOCATIONS[@]}"; do
    if [ -d "$loc" ]; then
        ARCHI_MODEL=$(find "$loc" -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
        ARCHI_EDITOR=$(find "$loc" -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
        
        if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
            ARCHI_DIR="$loc"
            echo "✓ Archi encontrado em: $ARCHI_DIR"
            break
        fi
    fi
done

# Se não encontrou, procura em todo o home (limitado a 3 níveis)
if [ -z "$ARCHI_DIR" ]; then
    echo "  Buscando em todo o diretório home (pode demorar)..."
    ARCHI_MODEL=$(find ~ -maxdepth 4 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
    ARCHI_EDITOR=$(find ~ -maxdepth 4 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
    
    if [ -n "$ARCHI_MODEL" ]; then
        ARCHI_DIR=$(dirname "$ARCHI_MODEL")
        echo "✓ Archi encontrado em: $ARCHI_DIR"
    fi
fi

if [ -z "$ARCHI_DIR" ] || [ -z "$ARCHI_MODEL" ] || [ -z "$ARCHI_EDITOR" ]; then
    echo ""
    echo "❌ Erro: Não foi possível encontrar o Archi instalado"
    echo ""
    echo "Por favor, informe o diretório onde o Archi está instalado"
    echo "e execute:"
    echo ""
    echo "  ARCHI_HOME=/caminho/do/archi ./compile_fix.sh"
    echo ""
    echo "Exemplos:"
    echo "  ARCHI_HOME=/opt/Archi ./compile_fix.sh"
    echo "  ARCHI_HOME=~/Archi ./compile_fix.sh"
    exit 1
fi

# Verifica se foi passado ARCHI_HOME como variável de ambiente
if [ -n "$ARCHI_HOME" ]; then
    ARCHI_MODEL=$(find "$ARCHI_HOME" -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
    ARCHI_EDITOR=$(find "$ARCHI_HOME" -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
    
    if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
        echo "✓ Usando Archi de ARCHI_HOME: $ARCHI_HOME"
    fi
fi

echo ""
echo "Dependências:"
echo "  Model:  $(basename "$ARCHI_MODEL")"
echo "  Editor: $(basename "$ARCHI_EDITOR")"
echo ""

# Busca dependências adicionais do Eclipse/SWT
SWT_JAR=$(find "$ARCHI_DIR" -name "org.eclipse.swt*.jar" 2>/dev/null | head -1)
JFACE_JAR=$(find "$ARCHI_DIR" -name "org.eclipse.jface*.jar" 2>/dev/null | head -1)
CORE_RUNTIME=$(find "$ARCHI_DIR" -name "org.eclipse.core.runtime*.jar" 2>/dev/null | head -1)
EMF_COMMON=$(find "$ARCHI_DIR" -name "org.eclipse.emf.common*.jar" 2>/dev/null | head -1)
EMF_ECORE=$(find "$ARCHI_DIR" -name "org.eclipse.emf.ecore*.jar" 2>/dev/null | head -1)

# Monta o classpath
CLASSPATH="$ARCHI_MODEL:$ARCHI_EDITOR"
[ -n "$SWT_JAR" ] && CLASSPATH="$CLASSPATH:$SWT_JAR"
[ -n "$JFACE_JAR" ] && CLASSPATH="$CLASSPATH:$JFACE_JAR"
[ -n "$CORE_RUNTIME" ] && CLASSPATH="$CLASSPATH:$CORE_RUNTIME"
[ -n "$EMF_COMMON" ] && CLASSPATH="$CLASSPATH:$EMF_COMMON"
[ -n "$EMF_ECORE" ] && CLASSPATH="$CLASSPATH:$EMF_ECORE"

# Compila
echo "Compilando classes Java..."
mkdir -p "$OUTPUT_DIR/com/vhsystem/defaultlabel/dialogs"
mkdir -p "$OUTPUT_DIR/com/vhsystem/defaultlabel/handlers"

javac -d "$OUTPUT_DIR" \
    -cp "$CLASSPATH" \
    -sourcepath "$PROJECT_DIR/src" \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/dialogs/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/handlers/"*.java 2>&1

COMPILE_STATUS=$?

echo ""
if [ $COMPILE_STATUS -eq 0 ] && [ -f "$OUTPUT_DIR/com/vhsystem/defaultlabel/dialogs/ManageLabelsDialog.class" ]; then
    echo "=========================================="
    echo "✅ COMPILAÇÃO CONCLUÍDA COM SUCESSO!"
    echo "=========================================="
    echo ""
    echo "Plugin atualizado em:"
    echo "  $OUTPUT_DIR"
    echo ""
    echo "Para instalar no Archi:"
    echo "  1. Feche o Archi se estiver aberto"
    echo "  2. Execute:"
    echo "     cp -r \"$OUTPUT_DIR\" ~/.archi/plugins/"
    echo "  3. Reinicie o Archi"
    echo ""
else
    echo "=========================================="
    echo "❌ ERRO NA COMPILAÇÃO"
    echo "=========================================="
    echo ""
    echo "Verifique os erros acima"
    exit 1
fi

