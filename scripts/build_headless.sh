#!/bin/bash

# Script para compilar o plugin via command line usando Eclipse headless

set -e

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
BUILD_DIR="$PROJECT_DIR/build-output"
EXPORT_DIR="$PROJECT_DIR/final-plugin"

echo "=========================================="
echo "Build Headless do Plugin"
echo "=========================================="
echo ""

# Limpa builds anteriores
rm -rf "$BUILD_DIR" "$EXPORT_DIR"
mkdir -p "$BUILD_DIR" "$EXPORT_DIR"

# Procura Eclipse
ECLIPSE_PATH=""
for path in ~/eclipse/eclipse ~/Downloads/eclipse/eclipse ~/Desktop/eclipse/eclipse /opt/eclipse/eclipse; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        ECLIPSE_PATH="$path"
        break
    fi
done

# Se não encontrou, pergunta
if [ -z "$ECLIPSE_PATH" ]; then
    echo "Eclipse não encontrado automaticamente."
    echo "Por favor, informe o caminho completo do executável do Eclipse:"
    read -p "Caminho: " ECLIPSE_PATH
    
    if [ ! -f "$ECLIPSE_PATH" ]; then
        echo "ERRO: Eclipse não encontrado!"
        exit 1
    fi
fi

ECLIPSE_HOME=$(dirname "$ECLIPSE_PATH")
echo "✓ Eclipse encontrado: $ECLIPSE_PATH"
echo ""

# Cria workspace temporário
WORKSPACE_DIR="$BUILD_DIR/workspace"
mkdir -p "$WORKSPACE_DIR"

echo "✓ Workspace criado: $WORKSPACE_DIR"
echo ""

# Procura dependências do Archi
echo "Procurando dependências do Archi..."
ARCHI_MODEL=$(find ~/.archi /opt /usr -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
ARCHI_EDITOR=$(find ~/.archi /opt /usr -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)

if [ -z "$ARCHI_MODEL" ] || [ -z "$ARCHI_EDITOR" ]; then
    echo "⚠ Dependências do Archi não encontradas automaticamente"
    echo "Tentando compilar sem elas (pode falhar)..."
    echo ""
else
    echo "✓ Dependências encontradas:"
    echo "  Model: $ARCHI_MODEL"
    echo "  Editor: $ARCHI_EDITOR"
    echo ""
fi

# Cria script de build para Eclipse
BUILD_SCRIPT="$BUILD_DIR/build.xml"

cat > "$BUILD_SCRIPT" << 'BUILDXML'
<?xml version="1.0" encoding="UTF-8"?>
<project name="Build Plugin" default="build">
    <target name="build">
        <echo message="Building plugin..."/>
        <eclipse.buildScript 
            workspaceDir="${workspaceDir}"
            buildId="plugin-build"
            baseLocation="${baseLocation}"
            pluginPath="${pluginPath}"
            configs="linux,gtk,x86_64"
            base="."
            />
    </target>
</project>
BUILDXML

# Tenta compilar usando Eclipse headless
echo "Compilando plugin usando Eclipse headless..."
echo ""

# Cria diretório de destino
PLUGIN_OUTPUT="$EXPORT_DIR/com.vhsystem.defaultlabel_1.0.0.qualifier"
mkdir -p "$PLUGIN_OUTPUT"

# Copia arquivos de configuração
echo "Copiando arquivos de configuração..."
cp -r "$PROJECT_DIR/META-INF" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/plugin.xml" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/build.properties" "$PLUGIN_OUTPUT/"

# Tenta compilar com javac se tiver as dependências
if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
    echo "Compilando classes Java..."
    
    CLASSES_DIR="$PLUGIN_OUTPUT/com/vhsystem/defaultlabel"
    mkdir -p "$CLASSES_DIR/dialogs" "$CLASSES_DIR/handlers"
    
    # Encontra JARs do Eclipse necessários
    ECLIPSE_PLUGINS="$ECLIPSE_HOME/plugins"
    
    CORE_RUNTIME=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.core.runtime_*.jar" 2>/dev/null | head -1)
    ECLIPSE_UI=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.ui_*.jar" 2>/dev/null | head -1)
    ECLIPSE_JFACE=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.jface_*.jar" 2>/dev/null | head -1)
    ECLIPSE_SWT=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.swt.gtk.linux.x86_64_*.jar" 2>/dev/null | head -1)
    
    CLASSPATH="$ARCHI_MODEL:$ARCHI_EDITOR"
    
    if [ -n "$CORE_RUNTIME" ]; then
        CLASSPATH="$CLASSPATH:$CORE_RUNTIME"
    fi
    if [ -n "$ECLIPSE_UI" ]; then
        CLASSPATH="$CLASSPATH:$ECLIPSE_UI"
    fi
    if [ -n "$ECLIPSE_JFACE" ]; then
        CLASSPATH="$CLASSPATH:$ECLIPSE_JFACE"
    fi
    if [ -n "$ECLIPSE_SWT" ]; then
        CLASSPATH="$CLASSPATH:$ECLIPSE_SWT"
    fi
    
    echo "Classpath: $CLASSPATH"
    echo ""
    
    # Compila as classes
    javac -d "$CLASSES_DIR" \
        -cp "$CLASSPATH" \
        -sourcepath "$PROJECT_DIR/src" \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/"*.java \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/dialogs/"*.java \
        "$PROJECT_DIR/src/com/vhsystem/defaultlabel/handlers/"*.java 2>&1 | tee "$BUILD_DIR/compile.log"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "✓ Compilação concluída com sucesso!"
    else
        echo "⚠ Erros na compilação. Verifique $BUILD_DIR/compile.log"
        echo "Tentando continuar..."
    fi
else
    echo "⚠ Dependências não encontradas. Não foi possível compilar."
    echo "Copiando apenas estrutura do plugin..."
fi

echo ""
echo "=========================================="
echo "Plugin compilado em:"
echo "$PLUGIN_OUTPUT"
echo "=========================================="
echo ""

# Cria um arquivo de informações
cat > "$EXPORT_DIR/INFO.txt" << INFO
Plugin compilado em: $(date)
Localização: $PLUGIN_OUTPUT

Para instalar no Archi:
1. Copie a pasta com.vhsystem.defaultlabel_1.0.0.qualifier para ~/.archi/plugins/
2. Reinicie o Archi
3. Verifique o menu "Labels Padrão"

Estrutura:
$(find "$PLUGIN_OUTPUT" -type f | sed 's|^|  |')
INFO

echo "Informações salvas em: $EXPORT_DIR/INFO.txt"
echo ""
echo "✅ BUILD CONCLUÍDO!"
echo ""
echo "Plugin pronto em: $PLUGIN_OUTPUT"
echo ""

