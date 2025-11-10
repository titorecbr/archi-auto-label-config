#!/bin/bash

# Script para criar arquivo .archiplugin para instalação via interface visual do Archi
# O formato .archiplugin é um ZIP contendo um arquivo JAR do plugin

set -e

# Detecta o diretório do projeto automaticamente
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
PLUGIN_SOURCE="$PROJECT_DIR/final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier"
OUTPUT_DIR="$PROJECT_DIR"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
JAR_FILE="$PROJECT_DIR/final-plugin/${PLUGIN_NAME}.jar"
ARCHIPLUGIN_FILE="$OUTPUT_DIR/${PLUGIN_NAME}.archiplugin"

echo "=========================================="
echo "Gerador de Arquivo .archiplugin"
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

# Remove arquivos anteriores se existirem
if [ -f "$ARCHIPLUGIN_FILE" ]; then
    echo "⚠ Removendo arquivo .archiplugin anterior..."
    rm -f "$ARCHIPLUGIN_FILE"
fi

if [ -f "$JAR_FILE" ]; then
    echo "⚠ Removendo arquivo JAR anterior..."
    rm -f "$JAR_FILE"
fi

# Cria o arquivo marcador obrigatório
echo "Criando arquivo marcador 'archi-plugin'..."
cd "$PLUGIN_SOURCE"
touch archi-plugin

# Verifica se o MANIFEST.MF existe
if [ ! -f "META-INF/MANIFEST.MF" ]; then
    echo "❌ ERRO: META-INF/MANIFEST.MF não encontrado!"
    exit 1
fi

# Cria o arquivo JAR do plugin usando o MANIFEST.MF existente
echo "Criando arquivo JAR do plugin com MANIFEST.MF..."
jar cmf META-INF/MANIFEST.MF "$JAR_FILE" -C . .

if [ $? -ne 0 ]; then
    echo "❌ Erro ao criar arquivo JAR"
    exit 1
fi

echo "✓ Arquivo JAR criado: $JAR_FILE"
echo ""

# Cria o arquivo .archiplugin (ZIP) contendo o arquivo marcador e o JAR
echo "Criando arquivo .archiplugin..."
cd "$PROJECT_DIR/final-plugin"
echo "" > archi-plugin
zip "$ARCHIPLUGIN_FILE" archi-plugin "${PLUGIN_NAME}.jar" -q

if [ $? -eq 0 ]; then
    echo "✓ Arquivo .archiplugin criado com sucesso!"
    rm -f archi-plugin  # Remove o arquivo marcador temporário
else
    echo "❌ Erro ao criar arquivo .archiplugin"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ ARQUIVO .archiplugin GERADO!"
echo "=========================================="
echo ""
echo "Arquivo gerado:"
echo "$ARCHIPLUGIN_FILE"
echo ""
echo "Tamanho: $(du -h "$ARCHIPLUGIN_FILE" | cut -f1)"
echo ""
echo "Estrutura do arquivo:"
unzip -l "$ARCHIPLUGIN_FILE" | head -5
echo ""
echo "=========================================="
echo "COMO INSTALAR NO ARCHI:"
echo "=========================================="
echo ""
echo "1. Abra o Archi"
echo "2. Vá em: Help → Manage Plugins..."
echo "3. Clique em: Install Plugin... ou Add Plugin..."
echo "4. Selecione o arquivo:"
echo "   $ARCHIPLUGIN_FILE"
echo "5. Confirme a instalação"
echo "6. Reinicie o Archi"
echo ""
echo "OU (Instalação Manual):"
echo ""
echo "Extraia o JAR do arquivo .archiplugin e copie para:"
echo "  mkdir -p ~/.archi/dropins"
echo "  unzip -j \"$ARCHIPLUGIN_FILE\" -d ~/.archi/dropins/"
echo ""
echo "=========================================="
