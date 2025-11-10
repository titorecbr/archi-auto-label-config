#!/bin/bash

# Script automático para compilar - tenta encontrar tudo automaticamente

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
EXPORT_DIR="$PROJECT_DIR/final-plugin"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_OUTPUT="$EXPORT_DIR/$PLUGIN_NAME"

echo "=========================================="
echo "Build Automático do Plugin"
echo "=========================================="
echo ""

# Limpa build anterior
rm -rf "$EXPORT_DIR"
mkdir -p "$PLUGIN_OUTPUT"

# Copia arquivos de configuração
cp -r "$PROJECT_DIR/META-INF" "$PLUGIN_OUTPUT/" 2>/dev/null
cp "$PROJECT_DIR/plugin.xml" "$PLUGIN_OUTPUT/" 2>/dev/null
cp "$PROJECT_DIR/build.properties" "$PLUGIN_OUTPUT/" 2>/dev/null

echo "✓ Estrutura base criada"
echo ""

# Procura Archi de várias formas
echo "Procurando Archi e suas dependências..."

# Lista de locais para procurar
SEARCH_DIRS=(
    "$HOME/.archi/plugins"
    "/opt/archi/plugins"
    "/usr/share/archi/plugins"
    "$HOME/snap/archi/current/.archi/plugins"
    "$HOME/.local/share/archi/plugins"
)

ARCHI_MODEL=""
ARCHI_EDITOR=""

for dir in "${SEARCH_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        ARCHI_MODEL=$(find "$dir" -maxdepth 1 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
        ARCHI_EDITOR=$(find "$dir" -maxdepth 1 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
        
        if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
            echo "✓ Archi encontrado em: $dir"
            break
        fi
    fi
done

# Se não encontrou, tenta procurar AppImage
if [ -z "$ARCHI_MODEL" ]; then
    ARCHI_APPIMAGE=$(find ~ -maxdepth 3 -name "*archi*.AppImage" 2>/dev/null | head -1)
    
    if [ -n "$ARCHI_APPIMAGE" ]; then
        echo "✓ AppImage do Archi encontrado: $ARCHI_APPIMAGE"
        echo "  Extraindo para buscar dependências..."
        
        EXTRACT_DIR="/tmp/archi-extract-$$"
        "$ARCHI_APPIMAGE" --appimage-extract > /dev/null 2>&1
        
        if [ -d "squashfs-root" ]; then
            ARCHI_MODEL=$(find squashfs-root -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
            ARCHI_EDITOR=$(find squashfs-root -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
            
            if [ -n "$ARCHI_MODEL" ]; then
                echo "✓ Dependências encontradas no AppImage"
            fi
        fi
    fi
fi

# Se ainda não encontrou, cria estrutura sem compilar
if [ -z "$ARCHI_MODEL" ] || [ -z "$ARCHI_EDITOR" ]; then
    echo ""
    echo "⚠ Dependências do Archi não encontradas automaticamente"
    echo "  Criando estrutura do plugin (sem compilar classes)"
    echo ""
    echo "Para compilar, você precisa:"
    echo "1. Ter o Archi instalado"
    echo "2. Ou informar onde estão os JARs manualmente"
    echo ""
    echo "Estrutura criada em: $PLUGIN_OUTPUT"
    echo ""
    echo "Para compilar depois, execute:"
    echo "  ./build_final.sh"
    echo ""
    
    # Cria arquivo de instruções
    cat > "$EXPORT_DIR/INSTRUCOES.txt" << 'EOF'
Plugin preparado mas NÃO COMPILADO.

Para compilar, você precisa:
1. Ter o Archi instalado
2. Encontrar os JARs:
   - com.archimatetool.model_*.jar
   - com.archimatetool.editor_*.jar

3. Executar: ./build_final.sh

OU usar o Eclipse:
1. Importe o projeto no Eclipse
2. Configure as dependências
3. Project → Clean → Build
4. File → Export → Deployable plug-ins
EOF
    
    echo "✅ Estrutura do plugin criada (sem classes compiladas)"
    echo "   Localização: $PLUGIN_OUTPUT"
    exit 0
fi

echo "✓ Dependências encontradas:"
echo "  Model: $ARCHI_MODEL"
echo "  Editor: $ARCHI_EDITOR"
echo ""

# Compila
echo "Compilando classes Java..."

CLASSES_DIR="$PLUGIN_OUTPUT/com/vhsystem/defaultlabel"
mkdir -p "$CLASSES_DIR/dialogs" "$CLASSES_DIR/handlers"

CLASSPATH="$ARCHI_MODEL:$ARCHI_EDITOR"

# Tenta adicionar dependências do Eclipse
ECLIPSE_PLUGINS=$(find ~/eclipse ~/Downloads/eclipse /opt/eclipse -name "plugins" -type d 2>/dev/null | head -1)

if [ -n "$ECLIPSE_PLUGINS" ]; then
    CORE_RUNTIME=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.core.runtime_*.jar" 2>/dev/null | head -1)
    [ -n "$CORE_RUNTIME" ] && CLASSPATH="$CLASSPATH:$CORE_RUNTIME"
fi

javac -d "$CLASSES_DIR" \
    -cp "$CLASSPATH" \
    -sourcepath "$PROJECT_DIR/src" \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/dialogs/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/handlers/"*.java 2>&1

if [ $? -eq 0 ] && [ -f "$CLASSES_DIR/DefaultLabelPlugin.class" ]; then
    echo "✓ Compilação concluída com sucesso!"
    echo ""
    echo "=========================================="
    echo "✅ PLUGIN COMPILADO E PRONTO!"
    echo "=========================================="
    echo ""
    echo "Localização: $PLUGIN_OUTPUT"
    echo ""
    echo "Para instalar no Archi:"
    echo "  cp -r \"$PLUGIN_OUTPUT\" ~/.archi/plugins/"
    echo ""
else
    echo "⚠ Erro na compilação"
    echo "  Estrutura criada mas classes não compiladas"
    echo "  Localização: $PLUGIN_OUTPUT"
fi

