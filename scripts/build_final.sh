#!/bin/bash

# Script final para compilar o plugin via command line
# Usa o diretório raiz do Archi como base para procurar dependências

set -e

PROJECT_DIR="/home/victor/Projetos/VH System/Archi Plugin"
EXPORT_DIR="$PROJECT_DIR/final-plugin"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_OUTPUT="$EXPORT_DIR/$PLUGIN_NAME"

echo "=========================================="
echo "Build do Plugin - Default Label Plugin"
echo "=========================================="
echo ""

# Verifica se o diretório raiz do Archi foi informado
ARCHI_ROOT=""

# Aceita como parâmetro
if [ -n "$1" ]; then
    ARCHI_ROOT="$1"
elif [ -n "$ARCHI_HOME" ]; then
    # Ou como variável de ambiente
    ARCHI_ROOT="$ARCHI_HOME"
fi

# Se não foi informado, pergunta
if [ -z "$ARCHI_ROOT" ] || [ ! -d "$ARCHI_ROOT" ]; then
    echo "Informe o diretório raiz do Archi:"
    echo "Exemplos:"
    echo "  /opt/archi"
    echo "  /usr/share/archi"
    echo "  ~/Archi"
    echo "  (onde o Archi está instalado)"
    echo ""
    read -p "Diretório raiz do Archi: " ARCHI_ROOT
    
    if [ -z "$ARCHI_ROOT" ] || [ ! -d "$ARCHI_ROOT" ]; then
        echo "❌ ERRO: Diretório inválido ou não informado!"
        echo ""
        echo "Uso: $0 [diretório_raiz_archi]"
        echo "Ou defina: export ARCHI_HOME=/caminho/do/archi"
        exit 1
    fi
fi

# Normaliza o caminho (remove trailing slash e expande ~)
ARCHI_ROOT=$(readlink -f "$ARCHI_ROOT" 2>/dev/null || echo "$ARCHI_ROOT")
ARCHI_ROOT="${ARCHI_ROOT%/}"

echo "✓ Diretório raiz do Archi: $ARCHI_ROOT"
echo ""

# Limpa build anterior
rm -rf "$EXPORT_DIR"
mkdir -p "$PLUGIN_OUTPUT"

echo "✓ Diretório de saída criado: $PLUGIN_OUTPUT"
echo ""

# Copia arquivos de configuração
echo "Copiando arquivos de configuração..."
cp -r "$PROJECT_DIR/META-INF" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/plugin.xml" "$PLUGIN_OUTPUT/"
cp "$PROJECT_DIR/build.properties" "$PLUGIN_OUTPUT/"

echo "✓ Arquivos de configuração copiados"
echo ""

# Procura dependências do Archi no diretório raiz informado
echo "Procurando dependências do Archi em: $ARCHI_ROOT"
ARCHI_MODEL=""
ARCHI_EDITOR=""

# Locais comuns dentro do diretório raiz do Archi
PLUGIN_SEARCH_DIRS=(
    "$ARCHI_ROOT/plugins"
    "$ARCHI_ROOT/configuration/plugins"
    "$ARCHI_ROOT/.archi/plugins"
    "$ARCHI_ROOT"
)

for dir in "${PLUGIN_SEARCH_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  Procurando em: $dir"
        
        # Primeiro tenta encontrar JARs diretamente
        ARCHI_MODEL=$(find "$dir" -maxdepth 2 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
        ARCHI_EDITOR=$(find "$dir" -maxdepth 2 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
        
        # Se não encontrou JARs diretos, procura dentro de diretórios de plugins (formato Eclipse)
        if [ -z "$ARCHI_MODEL" ]; then
            MODEL_DIR=$(find "$dir" -maxdepth 1 -type d -name "com.archimatetool.model_*" 2>/dev/null | head -1)
            if [ -n "$MODEL_DIR" ]; then
                ARCHI_MODEL=$(find "$MODEL_DIR" -name "*.jar" -o -name "com.archimatetool.model.jar" 2>/dev/null | head -1)
            fi
        fi
        
        if [ -z "$ARCHI_EDITOR" ]; then
            EDITOR_DIR=$(find "$dir" -maxdepth 1 -type d -name "com.archimatetool.editor_*" 2>/dev/null | head -1)
            if [ -n "$EDITOR_DIR" ]; then
                ARCHI_EDITOR=$(find "$EDITOR_DIR" -name "*.jar" -o -name "com.archimatetool.editor.jar" 2>/dev/null | head -1)
            fi
        fi
        
        if [ -n "$ARCHI_MODEL" ] && [ -n "$ARCHI_EDITOR" ]; then
            echo "  ✓ Encontrado!"
            break
        fi
    fi
done

# Se não encontrou nos locais comuns, procura recursivamente (mais lento)
if [ -z "$ARCHI_MODEL" ] || [ -z "$ARCHI_EDITOR" ]; then
    echo "  Procurando recursivamente..."
    
    # Procura JARs diretamente
    ARCHI_MODEL=$(find "$ARCHI_ROOT" -maxdepth 5 -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1)
    ARCHI_EDITOR=$(find "$ARCHI_ROOT" -maxdepth 5 -name "com.archimatetool.editor_*.jar" 2>/dev/null | head -1)
    
    # Se não encontrou, procura dentro de diretórios
    if [ -z "$ARCHI_MODEL" ]; then
        MODEL_DIR=$(find "$ARCHI_ROOT" -maxdepth 3 -type d -name "com.archimatetool.model_*" 2>/dev/null | head -1)
        if [ -n "$MODEL_DIR" ]; then
            ARCHI_MODEL=$(find "$MODEL_DIR" -name "*.jar" 2>/dev/null | head -1)
        fi
    fi
    
    if [ -z "$ARCHI_EDITOR" ]; then
        EDITOR_DIR=$(find "$ARCHI_ROOT" -maxdepth 3 -type d -name "com.archimatetool.editor_*" 2>/dev/null | head -1)
        if [ -n "$EDITOR_DIR" ]; then
            ARCHI_EDITOR=$(find "$EDITOR_DIR" -name "*.jar" 2>/dev/null | head -1)
        fi
    fi
fi

if [ -z "$ARCHI_MODEL" ] || [ -z "$ARCHI_EDITOR" ]; then
    echo ""
    echo "❌ ERRO: Dependências do Archi não encontradas em: $ARCHI_ROOT"
    echo ""
    echo "Verifique se:"
    echo "1. O diretório informado está correto"
    echo "2. O Archi está instalado nesse diretório"
    echo "3. Os arquivos com.archimatetool.model_*.jar e com.archimatetool.editor_*.jar existem"
    echo ""
    echo "Estrutura esperada:"
    echo "  $ARCHI_ROOT/plugins/com.archimatetool.model_*.jar"
    echo "  $ARCHI_ROOT/plugins/com.archimatetool.editor_*.jar"
    echo ""
    exit 1
fi

echo "✓ Dependências encontradas:"
echo "  Model: $ARCHI_MODEL"
echo "  Editor: $ARCHI_EDITOR"
echo ""

# Procura dependências do Eclipse no diretório raiz do Archi
echo "Procurando dependências do Eclipse em: $ARCHI_ROOT"
ECLIPSE_PLUGINS=""

# Procura plugins do Eclipse dentro do diretório raiz do Archi
ECLIPSE_SEARCH_DIRS=(
    "$ARCHI_ROOT/plugins"
    "$ARCHI_ROOT/configuration/plugins"
    "$ARCHI_ROOT/eclipse/plugins"
    "$ARCHI_ROOT"
)

for dir in "${ECLIPSE_SEARCH_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        # Verifica se tem plugins do Eclipse
        if find "$dir" -maxdepth 1 -name "org.eclipse.core.runtime_*.jar" 2>/dev/null | head -1 > /dev/null; then
            ECLIPSE_PLUGINS="$dir"
            break
        fi
    fi
done

# Se não encontrou no diretório do Archi, procura em locais padrão do Eclipse
if [ -z "$ECLIPSE_PLUGINS" ]; then
    for eclipse_dir in ~/eclipse ~/Downloads/eclipse ~/Desktop/eclipse /opt/eclipse; do
        if [ -d "$eclipse_dir/plugins" ]; then
            ECLIPSE_PLUGINS="$eclipse_dir/plugins"
            break
        fi
    done
fi

# Monta classpath com todas as dependências necessárias
CLASSPATH="$ARCHI_MODEL:$ARCHI_EDITOR"

# Adiciona dependências do Eclipse se encontradas
if [ -n "$ECLIPSE_PLUGINS" ] && [ -d "$ECLIPSE_PLUGINS" ]; then
    echo "✓ Plugins do Eclipse encontrados em: $ECLIPSE_PLUGINS"
    
    # Dependências essenciais do Eclipse
    CORE_RUNTIME=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.core.runtime_*.jar" 2>/dev/null | head -1)
    ECLIPSE_UI=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.ui_*.jar" 2>/dev/null | head -1)
    ECLIPSE_UI_WORKBENCH=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.ui.workbench_*.jar" 2>/dev/null | head -1)
    ECLIPSE_JFACE=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.jface_*.jar" 2>/dev/null | head -1)
    ECLIPSE_SWT=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.swt.gtk.linux.x86_64_*.jar" 2>/dev/null | head -1)
    ECLIPSE_OSGI=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.osgi_*.jar" 2>/dev/null | head -1)
    ECLIPSE_COMMANDS=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.core.commands_*.jar" 2>/dev/null | head -1)
    ECLIPSE_EQUINOX=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.equinox.common_*.jar" 2>/dev/null | head -1)
    
    # Dependências EMF (necessárias para EObject, EList, etc.)
    EMF_ECORE=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.emf.ecore_*.jar" 2>/dev/null | head -1)
    EMF_COMMON=$(find "$ECLIPSE_PLUGINS" -name "org.eclipse.emf.common_*.jar" 2>/dev/null | head -1)
    
    [ -n "$CORE_RUNTIME" ] && CLASSPATH="$CLASSPATH:$CORE_RUNTIME"
    [ -n "$ECLIPSE_UI" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_UI"
    [ -n "$ECLIPSE_UI_WORKBENCH" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_UI_WORKBENCH"
    [ -n "$ECLIPSE_JFACE" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_JFACE"
    [ -n "$ECLIPSE_SWT" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_SWT"
    [ -n "$ECLIPSE_OSGI" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_OSGI"
    [ -n "$ECLIPSE_COMMANDS" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_COMMANDS"
    [ -n "$ECLIPSE_EQUINOX" ] && CLASSPATH="$CLASSPATH:$ECLIPSE_EQUINOX"
    [ -n "$EMF_ECORE" ] && CLASSPATH="$CLASSPATH:$EMF_ECORE"
    [ -n "$EMF_COMMON" ] && CLASSPATH="$CLASSPATH:$EMF_COMMON"
    
    echo "  Adicionadas dependências do Eclipse ao classpath"
else
    echo "⚠ Plugins do Eclipse não encontrados"
    echo "  Tentando compilar apenas com dependências do Archi..."
fi

echo ""
echo "Compilando classes Java..."
echo ""

# Encontra o javac - precisa ser Java 21 para compatibilidade com Archi
JAVAC_CMD=""
JAVA_VERSION=""

# Verifica a versão do Java do Archi (opcional, apenas informativo)
ARCHI_JAVA="$ARCHI_ROOT/jre/bin/java"
if [ -f "$ARCHI_JAVA" ]; then
    ARCHI_JAVA_VERSION=$("$ARCHI_JAVA" -version 2>&1 | head -1 | sed -n 's/.*version "\([0-9]*\).*/\1/p')
    if [ -n "$ARCHI_JAVA_VERSION" ]; then
        echo "✓ Archi usa Java versão: $ARCHI_JAVA_VERSION"
        echo ""
    fi
fi

# Adiciona SDKMAN ao PATH se existir
if [ -d "$HOME/.sdkman/candidates/java/current/bin" ]; then
    export PATH="$HOME/.sdkman/candidates/java/current/bin:$PATH"
fi

# Tenta encontrar javac Java 21 primeiro (compatível com Archi)
# Procura Java 21 em vários locais
for java_dir in "$HOME/.sdkman/candidates/java" /usr/lib/jvm /opt/java; do
    if [ -d "$java_dir" ]; then
        # Procura por Java 21
        JAVA21_DIR=$(find "$java_dir" -maxdepth 2 -type d -name "*21*" -o -name "*jdk-21*" 2>/dev/null | head -1)
        if [ -n "$JAVA21_DIR" ] && [ -f "$JAVA21_DIR/bin/javac" ]; then
            JAVAC_CMD="$JAVA21_DIR/bin/javac"
            JAVA_VERSION=$("$JAVA21_DIR/bin/java" -version 2>&1 | head -1)
            break
        fi
    fi
done

# Se não encontrou Java 21, tenta outros
if [ -z "$JAVAC_CMD" ]; then
    # Tenta SDKMAN diretamente
    if [ -f "$HOME/.sdkman/candidates/java/current/bin/javac" ]; then
        JAVAC_CMD="$HOME/.sdkman/candidates/java/current/bin/javac"
        JAVA_VERSION=$("$HOME/.sdkman/candidates/java/current/bin/java" -version 2>&1 | head -1)
    elif command -v javac > /dev/null 2>&1; then
        JAVAC_CMD="javac"
        JAVA_VERSION=$(java -version 2>&1 | head -1)
    elif [ -f "/usr/bin/javac" ]; then
        JAVAC_CMD="/usr/bin/javac"
        JAVA_VERSION=$(/usr/bin/java -version 2>&1 | head -1)
    else
        # Procura recursivamente
        JAVAC_CMD=$(find /usr/lib/jvm /opt/java "$HOME/.sdkman" -name "javac" -type f 2>/dev/null | head -1)
        if [ -n "$JAVAC_CMD" ]; then
            JAVA_DIR=$(dirname "$(dirname "$JAVAC_CMD")")
            JAVA_VERSION=$("$JAVA_DIR/bin/java" -version 2>&1 | head -1)
        fi
    fi
fi

if [ -z "$JAVAC_CMD" ] || [ ! -f "$JAVAC_CMD" ]; then
    echo "❌ ERRO: javac não encontrado!"
    echo ""
    echo "O Java JDK precisa estar instalado para compilar o plugin."
    echo "Recomendado: Java 21 (mesma versão do Archi)"
    echo ""
    echo "Soluções:"
    echo "1. Instale o JDK 21:"
    echo "   sudo apt install openjdk-21-jdk"
    echo ""
    echo "2. Ou use SDKMAN:"
    echo "   sdk install java 21.0.1-tem"
    echo ""
    echo "3. Ou use o Eclipse para compilar (não precisa javac)"
    echo ""
    exit 1
fi

echo "✓ Usando javac: $JAVAC_CMD"
if [ -n "$JAVA_VERSION" ]; then
    echo "  Versão: $JAVA_VERSION"
fi
echo ""

# Cria diretório de classes (raiz do plugin)
CLASSES_DIR="$PLUGIN_OUTPUT"
mkdir -p "$CLASSES_DIR/com/vhsystem/defaultlabel/dialogs" "$CLASSES_DIR/com/vhsystem/defaultlabel/handlers"

# Compila com flags de compatibilidade
# Se não for Java 21, tenta compilar mesmo assim (pode funcionar)
echo "Classpath: $CLASSPATH" | tr ':' '\n' | head -10
echo ""

# Tenta compilar - se der erro de versão, avisa mas continua
"$JAVAC_CMD" -d "$CLASSES_DIR" \
    -cp "$CLASSPATH" \
    -sourcepath "$PROJECT_DIR/src" \
    --release 17 \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/dialogs/"*.java \
    "$PROJECT_DIR/src/com/vhsystem/defaultlabel/handlers/"*.java 2>&1 | tee /tmp/compile_errors.log

COMPILE_EXIT_CODE=${PIPESTATUS[0]}

if [ $COMPILE_EXIT_CODE -eq 0 ]; then
    echo "✓ Compilação concluída com sucesso!"
else
    echo "❌ Erro na compilação!"
    echo ""
    
    # Verifica se o erro é de versão do Java
    if grep -q "wrong version" /tmp/compile_errors.log 2>/dev/null; then
        echo "⚠ PROBLEMA DE VERSÃO DO JAVA DETECTADO!"
        echo ""
        echo "Os JARs do Archi foram compilados com Java 21, mas você está usando Java 17."
        echo "Para compilar corretamente, você precisa do Java 21 JDK."
        echo ""
        echo "Soluções:"
        echo "1. Instale Java 21 JDK:"
        echo "   sudo apt install openjdk-21-jdk"
        echo ""
        echo "2. Ou use SDKMAN:"
        echo "   sdk install java 21.0.1-tem"
        echo "   sdk use java 21.0.1-tem"
        echo ""
        echo "3. OU use o Eclipse IDE para compilar (recomendado):"
        echo "   - O Eclipse gerencia as versões automaticamente"
        echo "   - Veja QUICK_START.md para instruções"
        echo ""
    else
        echo "Verifique se:"
        echo "1. As dependências do Archi estão corretas"
        echo "2. O Java está instalado (java -version)"
        echo "3. Todas as dependências estão disponíveis"
        echo ""
        echo "Erros detalhados salvos em: /tmp/compile_errors.log"
    fi
    
    exit 1
fi

echo ""

# Verifica se as classes foram geradas
if [ -f "$CLASSES_DIR/com/vhsystem/defaultlabel/DefaultLabelPlugin.class" ]; then
    echo "✓ Classes compiladas verificadas"
else
    echo "⚠ Classes não encontradas após compilação"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
echo "=========================================="
echo ""
echo "Plugin compilado em:"
echo "$PLUGIN_OUTPUT"
echo ""
echo "Estrutura do plugin:"
find "$PLUGIN_OUTPUT" -type f | sed 's|^|  |'
echo ""
echo "=========================================="
echo "PARA INSTALAR NO ARCHI:"
echo "=========================================="
echo ""
echo "1. Copie a pasta completa para:"
echo "   ~/.archi/plugins/"
echo ""
echo "2. Comando:"
echo "   cp -r \"$PLUGIN_OUTPUT\" ~/.archi/plugins/"
echo ""
echo "3. Reinicie o Archi"
echo ""
echo "4. Verifique o menu 'Labels Padrão'"
echo ""
echo "=========================================="

