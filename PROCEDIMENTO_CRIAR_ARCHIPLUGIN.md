# 📦 PROCEDIMENTO CORRETO PARA CRIAR .archiplugin

## 🎯 OBJETIVO

Este documento define o procedimento CORRETO e TESTADO para criar um arquivo `.archiplugin` que funciona perfeitamente no Archi.

## ❌ ERROS COMUNS QUE JÁ FORAM COMETIDOS

### Erro 1: Arquivos Soltos na Raiz
```
ERRADO:
.archiplugin/
├── archi-plugin
├── META-INF/
├── plugin.xml
└── com/
```

### Erro 2: JAR + Arquivos .class Duplicados
```
ERRADO:
.archiplugin/
├── plugin.jar (21 KB)
├── META-INF/
└── com/ (arquivos .class soltos)
```

### Erro 3: Sem Arquivo Marcador
```
ERRADO:
.archiplugin/
└── plugin/
    ├── META-INF/  ❌ Falta archi-plugin
    └── com/
```

## ✅ ESTRUTURA CORRETA

O Archi espera a seguinte estrutura EXATA:

```
.archiplugin/
└── com.vhsystem.defaultlabel_1.0.0.qualifier/  ⭐ DIRETÓRIO DO PLUGIN
    ├── archi-plugin                             ⭐ ARQUIVO MARCADOR
    ├── META-INF/
    │   └── MANIFEST.MF
    ├── plugin.xml
    ├── build.properties
    └── com/
        └── vhsystem/
            └── defaultlabel/
                ├── *.class
                ├── dialogs/*.class
                └── handlers/*.class
```

### Pontos Críticos:

1. **DIRETÓRIO PRINCIPAL**: Todos os arquivos devem estar dentro de um diretório com o nome completo do plugin
2. **ARQUIVO MARCADOR**: Deve existir `archi-plugin` na raiz do diretório do plugin
3. **SEM JAR**: Apenas arquivos .class organizados (não incluir JARs compilados)
4. **NOMES CORRETOS**: Usar exatamente `com.vhsystem.defaultlabel_1.0.0.qualifier`

## 📋 PROCEDIMENTO PASSO A PASSO

### Pré-requisitos

- Plugin compilado em: `final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/`
- Todos os arquivos .class presentes
- META-INF/MANIFEST.MF configurado
- plugin.xml configurado
- build.properties presente

### Passo 1: Criar Arquivo Marcador (se não existir)

```bash
cd '/home/victor/Projetos/VH System/archi-auto-label-config'
echo "1" > final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/archi-plugin
```

**Verificar:**
```bash
ls -la final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/archi-plugin
```

### Passo 2: Remover Arquivo .archiplugin Antigo (se existir)

```bash
rm -f com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
```

### Passo 3: Criar .archiplugin com Estrutura Correta

```bash
cd final-plugin

zip -r ../com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin \
  com.vhsystem.defaultlabel_1.0.0.qualifier/ \
  -x "*.DS_Store" "*.git*" "*.jar"

cd ..
```

**⚠️ IMPORTANTE:**
- Executar o `zip` de DENTRO do diretório `final-plugin/`
- Incluir TODO o diretório `com.vhsystem.defaultlabel_1.0.0.qualifier/`
- Excluir arquivos .jar para evitar duplicação

### Passo 4: Verificar Estrutura

```bash
unzip -l com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin | head -30
```

**Deve mostrar:**
```
Archive:  com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
  Length      Date    Time    Name
---------  ---------- -----   ----
        0                     com.vhsystem.defaultlabel_1.0.0.qualifier/
        2                     com.vhsystem.defaultlabel_1.0.0.qualifier/archi-plugin
        0                     com.vhsystem.defaultlabel_1.0.0.qualifier/META-INF/
      515                     com.vhsystem.defaultlabel_1.0.0.qualifier/META-INF/MANIFEST.MF
     1491                     com.vhsystem.defaultlabel_1.0.0.qualifier/plugin.xml
      105                     com.vhsystem.defaultlabel_1.0.0.qualifier/build.properties
        0                     com.vhsystem.defaultlabel_1.0.0.qualifier/com/
        ...
```

✅ **Primeira linha DEVE ser o diretório do plugin**  
✅ **Segunda linha DEVE ser archi-plugin**  
✅ **Todos os caminhos devem começar com `com.vhsystem.defaultlabel_1.0.0.qualifier/`**

### Passo 5: Verificar Integridade

```bash
unzip -t com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
```

Deve retornar: `No errors detected`

### Passo 6: Verificar Tamanho e Contagem

```bash
ls -lh com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
unzip -l com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin | tail -1
```

**Esperado:**
- Tamanho: ~24-26 KB
- Arquivos: 22-23 files

## 🔍 CHECKLIST DE VALIDAÇÃO

Antes de distribuir o arquivo `.archiplugin`, verificar:

- [ ] Arquivo `.archiplugin` criado
- [ ] Primeira linha do ZIP é o diretório do plugin
- [ ] Arquivo `archi-plugin` presente na raiz do diretório
- [ ] `META-INF/MANIFEST.MF` incluído
- [ ] `plugin.xml` incluído
- [ ] `build.properties` incluído
- [ ] Todos os `.class` incluídos (13 arquivos)
- [ ] Nenhum arquivo `.jar` incluído
- [ ] Teste de integridade passou
- [ ] Tamanho ~24-26 KB
- [ ] Total 22-23 arquivos

## 🚀 COMO INSTALAR

### No Archi:

1. **Help → Manage Plug-ins...**
2. Clique: **"Install..."**
3. Selecione: `com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin`
4. **Escolha**: "Install in user plugins directory"
5. Confirme e reinicie

### Verificar Instalação:

```bash
# Plugin deve estar em:
ls -la ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/

# Verificar que tem os arquivos:
ls ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/*.xml
ls ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/com/vhsystem/defaultlabel/*.class
```

### Verificar no Archi:

- **Menu**: Tools → Manage Default Labels ✅
- **Lista**: Help → About → Installation Details → Plug-ins ✅
  - Procurar: `com.vhsystem.defaultlabel` ✅

## 🔧 SCRIPT AUTOMATIZADO

Criar script `build_archiplugin.sh`:

```bash
#!/bin/bash

PROJECT_DIR="/home/victor/Projetos/VH System/archi-auto-label-config"
PLUGIN_NAME="com.vhsystem.defaultlabel_1.0.0.qualifier"
PLUGIN_DIR="$PROJECT_DIR/final-plugin/$PLUGIN_NAME"
OUTPUT_FILE="$PROJECT_DIR/$PLUGIN_NAME.archiplugin"

echo "════════════════════════════════════════"
echo "🔧 Criando .archiplugin"
echo "════════════════════════════════════════"
echo ""

# Verificar se diretório existe
if [ ! -d "$PLUGIN_DIR" ]; then
    echo "❌ Erro: Diretório do plugin não encontrado!"
    echo "   Esperado: $PLUGIN_DIR"
    exit 1
fi

# Criar arquivo marcador
echo "1" > "$PLUGIN_DIR/archi-plugin"
echo "✓ Arquivo marcador criado"

# Remover arquivo antigo
rm -f "$OUTPUT_FILE"
echo "✓ Arquivo antigo removido"

# Criar .archiplugin
cd "$PROJECT_DIR/final-plugin"
zip -r "../$PLUGIN_NAME.archiplugin" \
  "$PLUGIN_NAME/" \
  -x "*.DS_Store" "*.git*" "*.jar" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Arquivo .archiplugin criado"
    echo ""
    
    # Verificar
    cd "$PROJECT_DIR"
    SIZE=$(ls -lh "$PLUGIN_NAME.archiplugin" | awk '{print $5}')
    FILES=$(unzip -l "$PLUGIN_NAME.archiplugin" | tail -1 | awk '{print $2}')
    
    echo "════════════════════════════════════════"
    echo "✅ SUCESSO!"
    echo "════════════════════════════════════════"
    echo "Arquivo: $PLUGIN_NAME.archiplugin"
    echo "Tamanho: $SIZE"
    echo "Arquivos: $FILES"
    echo ""
    echo "Localização:"
    echo "$OUTPUT_FILE"
    echo ""
else
    echo "❌ Erro ao criar arquivo!"
    exit 1
fi
```

## 📝 NOTAS IMPORTANTES

### 1. Sempre Zipar a Partir do Diretório Pai

❌ ERRADO:
```bash
cd final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/
zip -r ../../plugin.archiplugin .
```

✅ CORRETO:
```bash
cd final-plugin/
zip -r ../plugin.archiplugin com.vhsystem.defaultlabel_1.0.0.qualifier/
```

### 2. Nome do Diretório Deve Corresponder ao Bundle-SymbolicName

No `MANIFEST.MF`:
```
Bundle-SymbolicName: com.vhsystem.defaultlabel;singleton:=true
Bundle-Version: 1.0.0.qualifier
```

Nome do diretório:
```
com.vhsystem.defaultlabel_1.0.0.qualifier
```

Formato: `{Bundle-SymbolicName}_{Bundle-Version}`

### 3. Arquivo Marcador é Obrigatório

O arquivo `archi-plugin` pode conter apenas:
```
1
```

Ou até estar vazio, mas DEVE existir.

### 4. Não Incluir JARs Compilados

O `.archiplugin` deve conter apenas:
- Arquivos de configuração (XML, MF, properties)
- Arquivos `.class` compilados
- Recursos (images, etc se houver)

**NÃO incluir:**
- Arquivos `.jar`
- Código fonte `.java`
- Arquivos de build (`.classpath`, `.project`)

## ✅ RESULTADO ESPERADO

Após seguir este procedimento:

1. ✅ Arquivo `.archiplugin` criado corretamente
2. ✅ Instalação no Archi sem erros
3. ✅ Plugin aparece na lista de plugins gerenciados
4. ✅ Menu "Tools → Manage Default Labels" disponível
5. ✅ Plugin funciona após restart do Archi
6. ✅ Correção do bug aplicada (valores revertem ao cancelar)

---

**Data:** 10/11/2025  
**Versão do Procedimento:** 1.0  
**Testado:** ✅ Sim  
**Status:** ✅ Funcional

