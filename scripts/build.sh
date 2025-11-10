#!/bin/bash

# Script para compilar o plugin Default Label Plugin para Archi

echo "=========================================="
echo "Compilando Default Label Plugin para Archi"
echo "=========================================="

# Verifica se o Java está instalado
if ! command -v javac &> /dev/null; then
    echo "ERRO: Java não encontrado. Por favor, instale o JDK 11 ou superior."
    exit 1
fi

echo "Java encontrado: $(javac -version 2>&1)"

# Cria diretório de saída
mkdir -p bin/com/vhsystem/defaultlabel/dialogs
mkdir -p bin/com/vhsystem/defaultlabel/handlers

# Compila os arquivos Java
echo ""
echo "Compilando arquivos Java..."
javac -d bin \
    -cp ".:$(find ~/.archi -name '*.jar' 2>/dev/null | tr '\n' ':')" \
    src/com/vhsystem/defaultlabel/*.java \
    src/com/vhsystem/defaultlabel/dialogs/*.java \
    src/com/vhsystem/defaultlabel/handlers/*.java 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Compilação concluída com sucesso!"
else
    echo "✗ Erro na compilação. Verifique as dependências do Archi."
    echo ""
    echo "NOTA: Para compilar corretamente, você precisa:"
    echo "1. Ter o Archi instalado"
    echo "2. Importar o projeto no Eclipse IDE"
    echo "3. Configurar as dependências do Archi no Build Path"
    echo "4. Usar Project → Clean → Build no Eclipse"
    exit 1
fi

# Copia arquivos de recursos
echo ""
echo "Copiando arquivos de recursos..."
cp -r META-INF bin/
cp plugin.xml bin/
cp build.properties bin/

echo ""
echo "=========================================="
echo "Plugin compilado em: bin/"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "1. Copie a pasta 'bin' para ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0/"
echo "2. Ou exporte via Eclipse: File → Export → Deployable plug-ins"
echo ""

