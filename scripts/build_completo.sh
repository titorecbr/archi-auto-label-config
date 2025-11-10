#!/bin/bash

# Build completo - tenta todas as formas possíveis

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
EXPORT_DIR="$PROJECT_DIR/final-plugin"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_OUTPUT="$EXPORT_DIR/$PLUGIN_NAME"

echo "=========================================="
echo "BUILD COMPLETO DO PLUGIN"
echo "=========================================="
echo ""

# Limpa e cria estrutura
rm -rf "$EXPORT_DIR"
mkdir -p "$PLUGIN_OUTPUT/com/vhsystem/defaultlabel/{dialogs,handlers}"

# Copia configuração
cp -r "$PROJECT_DIR/META-INF" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/plugin.xml" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/build.properties" "$PLUGIN_OUTPUT/"

echo "✓ Estrutura criada"
echo ""

# Busca agressiva por dependências
echo "Buscando dependências do Archi..."

# Lista expandida de locais
SEARCH_PATHS=(
    "$HOME/.archi"
    "/opt/archi"
    "/usr/share/archi"
    "$HOME/snap/archi"
    "$HOME/.local/share/Archi"
    "/usr/local/archi"
)

ARCHI_MODEL=""
ARCHI_EDITOR=""

for base_path in "${SEARCH_PATHS[@]}"; do
    if [ -d "$base_path" ]; then
        # Procura recursivamente (mas limitado)
        ARCHI_MODEL=$(find "$base_path" -maxdepth 4 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
        ARCHI_EDITOR=$(find "$base_path" -maxdepth 4 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
        
        if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
            echo "✓ Encontrado em: $base_path"
            break
        fi
    fi
done

# Se não encontrou, tenta busca mais ampla (pode ser lenta)
if [ -z "$ARCHI_MODEL" ]; then
    echo "Buscando em todo o sistema (pode demorar)..."
    ARCHI_MODEL=$(find ~ -maxdepth 8 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
    ARCHI_EDITOR=$(find ~ -maxdepth 8 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
fi

# Compila se encontrou dependências
if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
    echo "✓ Dependências encontradas!"
    echo "  Model: $ARCHI_MODEL"
    echo "  Editor: $ARCHI_EDITOR"
    echo ""
    
    echo "Compilando classes Java..."
    
    CLASSES_DIR="$PLUGIN_OUTPUT/com/vhsystem/defaultlabel"
    CLASSPATH="$ARCHI_MODEL:$ARCHI_EDITOR"
    
    # Tenta adicionar Eclipse se disponível
    for eclipse_dir in ~/eclipse ~/Downloads/eclipse /opt/eclipse; do
        if [ -d "$eclipse_dir/plugins" ]; then
            CORE_RUNTIME=$(find "$eclipse_dir/plugins" -name "org.eclipse.core.runtime_*.jar" 2>/dev/null | head -1)
            [ -n "$CORE_RUNTIME" ] && CLASSPATH="$CLASSPATH:$CORE_RUNTIME" && break
        fi
    done
    
    javac -d "$CLASSES_DIR" \
        -cp "$CLASSPATH" \
        -sourcepath "$PROJECT_DIR/src" \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/"*.java \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/dialogs/"*.java \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/handlers/"*.java 2>&1
    
    if [ $? -eq 0 ] && [ -f "$CLASSES_DIR/DefaultLabelPlugin.class" ]; then
        echo "✓ Compilação bem-sucedida!"
        COMPILED=true
    else
        echo "⚠ Erro na compilação"
        COMPILED=false
    fi
else
    echo "⚠ Dependências do Archi não encontradas"
    echo "  Estrutura criada mas classes NÃO compiladas"
    COMPILED=false
fi

echo ""
echo "=========================================="
if [ "$COMPILED" = true ]; then
    echo "✅ PLUGIN COMPILADO E PRONTO!"
else
    echo "⚠ ESTRUTURA CRIADA (precisa compilar classes)"
fi
echo "=========================================="
echo ""
echo "Localização do plugin:"
echo "$PLUGIN_OUTPUT"
echo ""

if [ "$COMPILED" = true ]; then
    echo "Estrutura completa:"
    find "$PLUGIN_OUTPUT" -type f | sed 's|^|  |'
    echo ""
    echo "Para instalar no Archi:"
    echo "  cp -r \"$PLUGIN_OUTPUT\" ~/.archi/plugins/"
    echo ""
    echo "Depois reinicie o Archi e verifique o menu 'Labels Padrão'"
else
    echo "Para compilar as classes, você precisa:"
    echo "1. Ter o Archi instalado OU"
    echo "2. Informar onde estão os JARs:"
    echo "   - com.archimatetool.model_*.jar"
    echo "   - com.archimatetool.editor_*.jar"
    echo ""
    echo "Depois execute: ./build_final.sh"
    echo ""
    echo "OU use o Eclipse:"
    echo "1. Importe o projeto"
    echo "2. Configure dependências"
    echo "3. Project → Clean → Build"
    echo "4. File → Export → Deployable plug-ins"
fi

echo ""
echo "=========================================="

