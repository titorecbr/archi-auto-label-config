#!/bin/bash

# Script para ajudar a encontrar onde o Archi está instalado

echo "=========================================="
echo "🔍 Procurando instalação do Archi"
echo "=========================================="
echo ""

found=0

# 1. Verificar se está no PATH
echo "1️⃣ Verificando se 'archi' está no PATH..."
if command -v archi &> /dev/null; then
    ARCHI_PATH=$(which archi)
    echo "   ✅ Encontrado: $ARCHI_PATH"
    ARCHI_DIR=$(dirname "$ARCHI_PATH")
    echo "   Diretório: $ARCHI_DIR"
    found=1
else
    echo "   ❌ Não encontrado no PATH"
fi
echo ""

# 2. Procurar em diretórios comuns
echo "2️⃣ Procurando em diretórios comuns..."
COMMON_DIRS=(
    "/opt/Archi"
    "/opt/archi"
    "/usr/local/Archi"
    "/usr/share/Archi"
    "$HOME/Archi"
    "$HOME/Downloads/Archi"
    "$HOME/.local/share/Archi"
    "$HOME/Apps/Archi"
    "$HOME/opt/Archi"
)

for dir in "${COMMON_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "   ✅ Encontrado: $dir"
        found=1
        
        # Verificar se tem os JARs necessários
        if ls "$dir"/**/com.archimatetool.model_*.jar &> /dev/null; then
            echo "      🎯 ESTE É O DIRETÓRIO CORRETO!"
            echo ""
            echo "      Para compilar, execute:"
            echo "      ARCHI_HOME=\"$dir\" ./compile_fix.sh"
            echo ""
        fi
    fi
done

if [ $found -eq 0 ]; then
    echo "   ❌ Não encontrado em diretórios comuns"
fi
echo ""

# 3. Procurar AppImage
echo "3️⃣ Procurando por Archi AppImage..."
APPIMAGES=$(find ~ ~/Downloads ~/Desktop -maxdepth 2 -name "*Archi*.AppImage" -o -name "*archi*.AppImage" 2>/dev/null)

if [ -n "$APPIMAGES" ]; then
    echo "$APPIMAGES" | while read -r appimage; do
        echo "   ✅ Encontrado: $appimage"
        found=1
    done
    echo ""
    echo "   ℹ️  Para usar AppImage, você precisa extraí-lo primeiro:"
    echo "   1. chmod +x ArchiAppImage.AppImage"
    echo "   2. ./ArchiAppImage.AppImage --appimage-extract"
    echo "   3. ARCHI_HOME=\"./squashfs-root\" ./compile_fix.sh"
else
    echo "   ❌ Nenhum AppImage encontrado"
fi
echo ""

# 4. Procurar por processos do Archi em execução
echo "4️⃣ Verificando se o Archi está em execução..."
ARCHI_PROCESS=$(ps aux | grep -i archi | grep -v grep | grep -v "ONDE_ESTA" | head -1)

if [ -n "$ARCHI_PROCESS" ]; then
    echo "   ✅ Archi está em execução!"
    echo "   Processo: $ARCHI_PROCESS"
    
    # Tentar extrair o caminho do processo
    ARCHI_PID=$(echo "$ARCHI_PROCESS" | awk '{print $2}')
    if [ -n "$ARCHI_PID" ]; then
        ARCHI_EXE=$(readlink -f /proc/$ARCHI_PID/exe 2>/dev/null)
        if [ -n "$ARCHI_EXE" ]; then
            ARCHI_DIR=$(dirname "$ARCHI_EXE")
            echo "   Executável: $ARCHI_EXE"
            echo "   Diretório: $ARCHI_DIR"
            
            if ls "$ARCHI_DIR"/**/com.archimatetool.model_*.jar &> /dev/null 2>&1; then
                echo "   🎯 ESTE É O DIRETÓRIO CORRETO!"
                echo ""
                echo "   Para compilar, execute:"
                echo "   ARCHI_HOME=\"$ARCHI_DIR\" ./compile_fix.sh"
            fi
        fi
    fi
else
    echo "   ❌ Archi não está em execução"
fi
echo ""

# 5. Procurar JARs do Archi em todo o home (pode demorar)
echo "5️⃣ Procurando JARs do Archi no diretório home (pode demorar)..."
ARCHI_JARS=$(find ~ -maxdepth 5 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -3)

if [ -n "$ARCHI_JARS" ]; then
    echo "   ✅ JARs do Archi encontrados:"
    echo "$ARCHI_JARS" | while read -r jar; do
        jar_dir=$(dirname "$jar")
        echo "   📦 $jar"
        echo "      Diretório: $jar_dir"
        echo ""
        echo "      Para compilar, execute:"
        echo "      ARCHI_HOME=\"$jar_dir\" ./compile_fix.sh"
        echo ""
    done
else
    echo "   ❌ Nenhum JAR do Archi encontrado"
fi
echo ""

# 6. Verificar instalação via snap
echo "6️⃣ Verificando instalação via Snap..."
if command -v snap &> /dev/null; then
    if snap list 2>/dev/null | grep -i archi &> /dev/null; then
        echo "   ✅ Archi instalado via Snap!"
        SNAP_DIR="$HOME/snap/archi/current/.archi"
        echo "   Diretório: $SNAP_DIR"
        
        if [ -d "$SNAP_DIR" ]; then
            echo "   🎯 Verifique os plugins em: $SNAP_DIR/plugins"
        fi
    else
        echo "   ❌ Archi não instalado via Snap"
    fi
else
    echo "   ❌ Snap não disponível"
fi
echo ""

# 7. Verificar instalação via Flatpak
echo "7️⃣ Verificando instalação via Flatpak..."
if command -v flatpak &> /dev/null; then
    if flatpak list 2>/dev/null | grep -i archi &> /dev/null; then
        echo "   ✅ Archi instalado via Flatpak!"
    else
        echo "   ❌ Archi não instalado via Flatpak"
    fi
else
    echo "   ❌ Flatpak não disponível"
fi
echo ""

# Resumo final
echo "=========================================="
echo "📋 RESUMO"
echo "=========================================="
echo ""

if [ $found -eq 1 ]; then
    echo "✅ Encontrei algumas possíveis instalações do Archi acima."
    echo ""
    echo "Para compilar o plugin com a correção do bug:"
    echo "1. Escolha um dos diretórios encontrados acima"
    echo "2. Execute: ARCHI_HOME=/caminho/escolhido ./compile_fix.sh"
    echo ""
    echo "Exemplo:"
    echo "  ARCHI_HOME=/opt/Archi ./compile_fix.sh"
else
    echo "❌ Não consegui encontrar o Archi instalado."
    echo ""
    echo "Você pode:"
    echo "1. Baixar o Archi de: https://www.archimatetool.com/download/"
    echo "2. Instalar em um dos diretórios comuns (/opt/Archi ou ~/Archi)"
    echo "3. Depois executar: ARCHI_HOME=/caminho/instalado ./compile_fix.sh"
    echo ""
    echo "OU"
    echo ""
    echo "Usar o Eclipse para compilar:"
    echo "1. Importe o projeto no Eclipse"
    echo "2. Configure as dependências do Archi"
    echo "3. Build automaticamente"
fi
echo ""

