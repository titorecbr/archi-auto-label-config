#!/bin/bash

echo "======================================"
echo "Verificador de Logs do Plugin"
echo "======================================"
echo ""
echo "Este script ajuda a capturar os logs do plugin ao iniciar o Archi."
echo ""
echo "Para verificar se o plugin foi carregado:"
echo "1. Feche o Archi completamente"
echo "2. Abra um terminal"
echo "3. Execute: /home/victor/apps/Archi/Archi 2>&1 | grep -i defaultlabel"
echo ""
echo "Você deve ver mensagens como:"
echo "  [DefaultLabel] 🚀 StartupHandler.earlyStartup() chamado!"
echo "  [DefaultLabel] 🚀 Plugin.start() chamado!"
echo "  [DefaultLabel] Inicializando labels padrão..."
echo "  [DefaultLabel] ✓ Labels inicializados: 73 tipos configurados"
echo ""
echo "======================================"
echo ""
echo "Pressione ENTER para executar o Archi com captura de logs..."
read

echo "Iniciando Archi com captura de logs..."
echo "CTRL+C para sair"
echo ""

/home/victor/apps/Archi/Archi 2>&1 | tee /tmp/archi-plugin-log.txt | grep --line-buffered -E "\[DefaultLabel\]|error|Error|ERROR"

