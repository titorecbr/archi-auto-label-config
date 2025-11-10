#!/bin/bash

# Script de instalação rápida do plugin corrigido

PLUGIN_SOURCE="/home/victor/Projetos/VH System/archi-auto-label-config/final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier"
ARCHI_PLUGINS="$HOME/.archi/plugins"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"

echo "========================================"
echo "🔧 Instalador do Plugin Corrigido"
echo "========================================"
echo ""
echo "Este script vai instalar o plugin com a correção do bug"
echo "de inconsistência no cancelamento da atualização."
echo ""

# Verificar se o Archi está rodando
if pgrep -x "Archi" > /dev/null; then
    echo "⚠️  ATENÇÃO: O Archi está em execução!"
    echo ""
    echo "É necessário fechar o Archi antes de instalar o plugin."
    echo ""
    read -p "Deseja que eu tente fechar o Archi automaticamente? (s/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "Fechando o Archi..."
        pkill -x "Archi"
        sleep 2
        
        if pgrep -x "Archi" > /dev/null; then
            echo "❌ Não foi possível fechar o Archi automaticamente."
            echo "   Por favor, feche manualmente e execute o script novamente."
            exit 1
        fi
        echo "✅ Archi fechado com sucesso!"
    else
        echo "Por favor, feche o Archi manualmente e execute o script novamente."
        exit 1
    fi
fi

echo ""

# Verificar se o diretório de plugins existe
if [ ! -d "$ARCHI_PLUGINS" ]; then
    echo "📁 Criando diretório de plugins do Archi..."
    mkdir -p "$ARCHI_PLUGINS"
    echo "✅ Diretório criado: $ARCHI_PLUGINS"
fi

echo ""

# Fazer backup do plugin antigo se existir
if [ -d "$ARCHI_PLUGINS/$PLUGIN_NAME" ]; then
    echo "💾 Fazendo backup do plugin anterior..."
    BACKUP_NAME="${PLUGIN_NAME}_backup_$(date +%Y%m%d_%H%M%S)"
    mv "$ARCHI_PLUGINS/$PLUGIN_NAME" "$ARCHI_PLUGINS/$BACKUP_NAME"
    echo "✅ Backup salvo em: $ARCHI_PLUGINS/$BACKUP_NAME"
    echo ""
fi

# Copiar o plugin
echo "📦 Instalando plugin corrigido..."
cp -r "$PLUGIN_SOURCE" "$ARCHI_PLUGINS/"

if [ $? -eq 0 ]; then
    echo "✅ Plugin instalado com sucesso!"
    echo ""
    echo "========================================"
    echo "🎉 INSTALAÇÃO CONCLUÍDA!"
    echo "========================================"
    echo ""
    echo "📍 Plugin instalado em:"
    echo "   $ARCHI_PLUGINS/$PLUGIN_NAME"
    echo ""
    echo "🚀 PRÓXIMOS PASSOS:"
    echo ""
    echo "1. Abra o Archi"
    echo "2. Teste a correção:"
    echo "   • Tools → Manage Default Labels"
    echo "   • Altere um valor"
    echo "   • Clique OK e escolha 'No'"
    echo "   • ✅ O valor deve voltar ao original!"
    echo ""
    echo "📖 Mais detalhes em: BUG_CORRIGIDO_PRONTO.md"
    echo ""
    
    # Perguntar se quer abrir o Archi
    read -p "Deseja abrir o Archi agora? (s/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "Abrindo o Archi..."
        
        # Tentar encontrar e executar o Archi
        if [ -f "/home/victor/apps/Archi/Archi" ]; then
            /home/victor/apps/Archi/Archi &
            echo "✅ Archi iniciado!"
        elif command -v archi &> /dev/null; then
            archi &
            echo "✅ Archi iniciado!"
        else
            echo "⚠️  Não foi possível encontrar o executável do Archi."
            echo "   Por favor, abra manualmente."
        fi
    fi
    
else
    echo "❌ ERRO ao instalar o plugin!"
    echo "   Verifique se você tem permissões de escrita em: $ARCHI_PLUGINS"
    exit 1
fi

echo ""

