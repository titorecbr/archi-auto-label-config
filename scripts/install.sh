#!/bin/bash

# Script de instalação do plugin Default Label Plugin no Archi

echo "=========================================="
echo "Instalador - Default Label Plugin para Archi"
echo "=========================================="
echo ""

# Detecta o sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ARCHI_PLUGINS_DIR="$HOME/.archi/plugins"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ARCHI_PLUGINS_DIR="$HOME/Library/Application Support/Archi/plugins"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    ARCHI_PLUGINS_DIR="$HOME/.archi/plugins"
else
    echo "Sistema operacional não reconhecido. Tente instalação manual."
    exit 1
fi

echo "Diretório de plugins do Archi: $ARCHI_PLUGINS_DIR"
echo ""

# Verifica se o diretório existe
if [ ! -d "$ARCHI_PLUGINS_DIR" ]; then
    echo "Criando diretório de plugins..."
    mkdir -p "$ARCHI_PLUGINS_DIR"
fi

# Verifica se o plugin já está compilado
if [ ! -d "bin" ] || [ ! -f "bin/com/vhsystem/defaultlabel/DefaultLabelPlugin.class" ]; then
    echo "ERRO: Plugin não compilado!"
    echo ""
    echo "Por favor, compile o plugin primeiro:"
    echo "1. Importe o projeto no Eclipse"
    echo "2. Configure as dependências do Archi"
    echo "3. Execute: Project → Clean → Build"
    echo "4. Exporte via: File → Export → Deployable plug-ins"
    echo ""
    echo "Ou consulte INSTALL.md para mais detalhes."
    exit 1
fi

# Nome do plugin
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_DIR="$ARCHI_PLUGINS_DIR/$PLUGIN_NAME"

# Remove instalação anterior se existir
if [ -d "$PLUGIN_DIR" ]; then
    echo "Removendo instalação anterior..."
    rm -rf "$PLUGIN_DIR"
fi

# Cria diretório do plugin
echo "Criando diretório do plugin..."
mkdir -p "$PLUGIN_DIR"

# Copia arquivos
echo "Copiando arquivos..."
cp -r bin/* "$PLUGIN_DIR/"
cp META-INF/MANIFEST.MF "$PLUGIN_DIR/META-INF/" 2>/dev/null || mkdir -p "$PLUGIN_DIR/META-INF" && cp META-INF/MANIFEST.MF "$PLUGIN_DIR/META-INF/"
cp plugin.xml "$PLUGIN_DIR/"

echo ""
echo "=========================================="
echo "Plugin instalado com sucesso!"
echo "=========================================="
echo ""
echo "Localização: $PLUGIN_DIR"
echo ""
echo "Próximos passos:"
echo "1. Feche o Archi se estiver aberto"
echo "2. Abra o Archi novamente"
echo "3. Verifique se o menu 'Labels Padrão' aparece"
echo "4. Teste criando um novo elemento sem nome"
echo ""

