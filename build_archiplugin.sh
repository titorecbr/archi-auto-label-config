#!/bin/bash

# Script para criar arquivo .archiplugin seguindo o formato que FUNCIONOU ANTES
# O .archiplugin é um ZIP contendo: archi-plugin (marcador) + JAR do plugin

set -e

PROJECT_DIR="/home/victor/Projetos/VH System/archi-auto-label-config"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_SOURCE="$PROJECT_DIR/final-plugin/$PLUGIN_NAME"
JAR_FILE="$PROJECT_DIR/final-plugin/${PLUGIN_NAME}.jar"
ARCHIPLUGIN_FILE="$PROJECT_DIR/${PLUGIN_NAME}.archiplugin"

echo "════════════════════════════════════════════════════════════"
echo "🔧 CRIANDO .archiplugin (FORMATO QUE FUNCIONA)"
echo "════════════════════════════════════════════════════════════"
echo ""

# Verificar se diretório do plugin existe
if [ ! -d "$PLUGIN_SOURCE" ]; then
    echo "❌ Erro: Diretório do plugin não encontrado!"
    echo "   Esperado: $PLUGIN_SOURCE"
    echo ""
    echo "Execute primeiro a compilação do plugin!"
    exit 1
fi

echo "1️⃣ Verificando arquivos necessários..."

# Verificar arquivos críticos
if [ ! -f "$PLUGIN_SOURCE/META-INF/MANIFEST.MF" ]; then
    echo "   ❌ MANIFEST.MF não encontrado!"
    exit 1
fi

if [ ! -f "$PLUGIN_SOURCE/com/vhsystem/defaultlabel/DefaultLabelPlugin.class" ]; then
    echo "   ❌ Classes não compiladas!"
    exit 1
fi

echo "   ✅ Arquivos de configuração e classes presentes"
echo ""

echo "2️⃣ Removendo arquivos anteriores..."
rm -f "$ARCHIPLUGIN_FILE" "$JAR_FILE"
echo "   ✅ Removidos"
echo ""

echo "3️⃣ Criando arquivo marcador em $PLUGIN_SOURCE..."
cd "$PLUGIN_SOURCE"
touch archi-plugin
echo "   ✅ Arquivo marcador criado"
echo ""

echo "4️⃣ Criando JAR do plugin com MANIFEST.MF..."
jar cmf META-INF/MANIFEST.MF "$JAR_FILE" -C . . > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "   ❌ Erro ao criar JAR!"
    exit 1
fi

cd "$PROJECT_DIR"
echo "   ✅ JAR criado: $(basename $JAR_FILE)"
echo "   💾 Tamanho: $(ls -lh "$JAR_FILE" | awk '{print $5}')"
echo ""

echo "5️⃣ Criando arquivo marcador temporário..."
cd final-plugin
echo "" > archi-plugin
echo "   ✅ Marcador temporário criado"
echo ""

echo "6️⃣ Criando .archiplugin (ZIP com marcador + JAR)..."
zip "$ARCHIPLUGIN_FILE" archi-plugin "${PLUGIN_NAME}.jar" -q

if [ $? -ne 0 ]; then
    echo "   ❌ Erro ao criar .archiplugin!"
    exit 1
fi

rm -f archi-plugin  # Remove marcador temporário
cd "$PROJECT_DIR"
echo "   ✅ .archiplugin criado"
echo ""

echo "7️⃣ Verificando estrutura..."
STRUCT=$(unzip -l "$ARCHIPLUGIN_FILE" 2>/dev/null)
HAS_MARKER=$(echo "$STRUCT" | grep -c "archi-plugin")
HAS_JAR=$(echo "$STRUCT" | grep -c "${PLUGIN_NAME}.jar")

if [ "$HAS_MARKER" -eq 1 ]; then
    echo "   ✅ Arquivo marcador presente"
else
    echo "   ❌ Arquivo marcador AUSENTE!"
fi

if [ "$HAS_JAR" -eq 1 ]; then
    echo "   ✅ JAR do plugin presente"
else
    echo "   ❌ JAR do plugin AUSENTE!"
fi

echo ""

echo "8️⃣ Verificando integridade..."
unzip -t "$ARCHIPLUGIN_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ✅ Arquivo válido (sem erros)"
else
    echo "   ❌ Arquivo corrompido!"
    exit 1
fi

echo ""

# Estatísticas
SIZE=$(ls -lh "$ARCHIPLUGIN_FILE" | awk '{print $5}')
FILES=$(unzip -l "$ARCHIPLUGIN_FILE" | tail -1 | awk '{print $2}')

echo "════════════════════════════════════════════════════════════"
echo "✅ .archiplugin CRIADO COM SUCESSO!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📦 Arquivo: ${PLUGIN_NAME}.archiplugin"
echo "💾 Tamanho: $SIZE"
echo "📊 Estrutura:"
echo ""
unzip -l "$ARCHIPLUGIN_FILE"
echo ""
echo "🎯 Formato: ZIP contendo marcador + JAR (CORRETO!)"
echo ""
echo "📍 Localização:"
echo "   $ARCHIPLUGIN_FILE"
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🚀 COMO INSTALAR"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "No Archi:"
echo "  1. Help → Manage Plug-ins..."
echo "  2. Clique: Install..."
echo "  3. Selecione: ${PLUGIN_NAME}.archiplugin"
echo "  4. Escolha: Install in user plugins directory"
echo "  5. Confirme e reinicie"
echo ""
echo "✅ O plugin deve:"
echo "  • Instalar sem erro"
echo "  • Aparecer na lista de plugins"
echo "  • Mostrar menu: Tools → Manage Default Labels"
echo "  • Persistir após restart"
echo ""
echo "════════════════════════════════════════════════════════════"
