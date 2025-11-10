#!/bin/bash

# Script para instalar o plugin diretamente no Archi (método mais confiável)

set -e

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
PLUGIN_SOURCE="$PROJECT_DIR/final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
ARCHI_DROPINS="$HOME/.archi/dropins"
PLUGIN_DROPINS="$ARCHI_DROPINS/$PLUGIN_NAME"

echo "=========================================="
echo "Instalador do Plugin - Default Label Plugin"
echo "=========================================="
echo ""

# Verifica se a pasta do plugin existe
if [ ! -d "$PLUGIN_SOURCE" ]; then
    echo "❌ ERRO: Pasta do plugin não encontrada!"
    echo "   Esperado em: $PLUGIN_SOURCE"
    echo ""
    echo "Execute primeiro o build_final.sh para compilar o plugin."
    exit 1
fi

echo "✓ Pasta do plugin encontrada: $PLUGIN_SOURCE"
echo ""

# Verifica se as classes foram compiladas
if [ ! -f "$PLUGIN_SOURCE/com/vhsystem/defaultlabel/DefaultLabelPlugin.class" ]; then
    echo "❌ ERRO: Classes não encontradas!"
    echo "   O plugin precisa estar compilado."
    echo ""
    echo "Execute: ./build_final.sh /home/victor/apps/Archi"
    exit 1
fi

echo "✓ Classes compiladas verificadas"
echo ""

# Cria o diretório dropins se não existir
if [ ! -d "$ARCHI_DROPINS" ]; then
    echo "Criando diretório dropins: $ARCHI_DROPINS"
    mkdir -p "$ARCHI_DROPINS"
fi

echo "✓ Diretório dropins encontrado: $ARCHI_DROPINS"
echo ""

# Remove instalação anterior se existir
if [ -d "$PLUGIN_DROPINS" ]; then
    echo "⚠ Removendo instalação anterior..."
    rm -rf "$PLUGIN_DROPINS"
fi

# Cria diretório do plugin
echo "Criando diretório do plugin em dropins..."
mkdir -p "$PLUGIN_DROPINS"

# Copia todos os arquivos do plugin
echo "Copiando arquivos do plugin..."
cp -r "$PLUGIN_SOURCE"/* "$PLUGIN_DROPINS/"

if [ $? -eq 0 ]; then
    echo "✓ Plugin copiado com sucesso!"
else
    echo "❌ Erro ao copiar plugin"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ PLUGIN INSTALADO COM SUCESSO!"
echo "=========================================="
echo ""
echo "Localização da instalação:"
echo "$PLUGIN_DROPINS"
echo ""
echo "Estrutura instalada:"
find "$PLUGIN_DROPINS" -type f | head -10 | sed 's|^|  |'
echo ""
echo "=========================================="
echo "PRÓXIMOS PASSOS:"
echo "=========================================="
echo ""
echo "1. FECHE o Archi completamente (se estiver aberto)"
echo "2. ABRA o Archi novamente"
echo "3. Verifique se o menu 'Labels Padrão' aparece"
echo "4. Teste: Labels Padrão → Gerenciar Labels Padrão"
echo ""
echo "Se houver problemas, verifique os logs:"
echo "  Help → Show Log"
echo ""
echo "=========================================="

