#!/bin/bash

# Script para verificar a estrutura do plugin

echo "=========================================="
echo "Verificação da Estrutura do Plugin"
echo "=========================================="
echo ""

ERRORS=0

# Verifica arquivos essenciais
echo "Verificando arquivos essenciais..."

check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1"
    else
        echo "✗ FALTANDO: $1"
        ERRORS=$((ERRORS + 1))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✓ $1/ (diretório existe)"
    else
        echo "✗ FALTANDO: $1/ (diretório)"
        ERRORS=$((ERRORS + 1))
    fi
}

# Arquivos de configuração
check_file "META-INF/MANIFEST.MF"
check_file "plugin.xml"
check_file "build.properties"

# Arquivos Java fonte
check_file "src/com/vhsystem/defaultlabel/DefaultLabelPlugin.java"
check_file "src/com/vhsystem/defaultlabel/LabelManager.java"
check_file "src/com/vhsystem/defaultlabel/handlers/ManageLabelsHandler.java"
check_file "src/com/vhsystem/defaultlabel/dialogs/ManageLabelsDialog.java"

# Diretórios
check_dir "src/com/vhsystem/defaultlabel"
check_dir "src/com/vhsystem/defaultlabel/dialogs"
check_dir "src/com/vhsystem/defaultlabel/handlers"
check_dir "META-INF"

echo ""
echo "Verificando conteúdo do MANIFEST.MF..."

if grep -q "Bundle-SymbolicName: com.vhsystem.defaultlabel" META-INF/MANIFEST.MF; then
    echo "✓ Bundle-SymbolicName correto"
else
    echo "✗ Bundle-SymbolicName incorreto ou ausente"
    ERRORS=$((ERRORS + 1))
fi

if grep -q "Bundle-Activator: com.vhsystem.defaultlabel.DefaultLabelPlugin" META-INF/MANIFEST.MF; then
    echo "✓ Bundle-Activator correto"
else
    echo "✗ Bundle-Activator incorreto ou ausente"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "Verificando conteúdo do plugin.xml..."

if grep -q "com.archimatetool.editor.archiPlugin" plugin.xml; then
    echo "✓ Extension point do Archi configurado"
else
    echo "✗ Extension point do Archi não encontrado"
    ERRORS=$((ERRORS + 1))
fi

if grep -q "com.vhsystem.defaultlabel.commands.manageLabels" plugin.xml; then
    echo "✓ Comando de menu configurado"
else
    echo "✗ Comando de menu não encontrado"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo "✓ Estrutura do plugin está CORRETA!"
    echo "=========================================="
    echo ""
    echo "Próximos passos:"
    echo "1. Importe o projeto no Eclipse"
    echo "2. Configure as dependências do Archi"
    echo "3. Compile: Project → Clean → Build"
    echo "4. Exporte: File → Export → Deployable plug-ins"
    echo ""
    exit 0
else
    echo "✗ Encontrados $ERRORS problema(s)"
    echo "=========================================="
    echo ""
    echo "Por favor, corrija os problemas acima antes de continuar."
    exit 1
fi

