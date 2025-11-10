# 🎯 FORMATO CORRETO DO .archiplugin

## ✅ Descoberta Final (A Que Realmente Funciona!)

Depois de várias tentativas, encontrei o formato correto olhando o **script antigo que funcionava**: `scripts/create_archiplugin.sh`

---

## 📦 Estrutura Correta

### O arquivo `.archiplugin` é um **ZIP** contendo:

```
com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin (ZIP)
├── archi-plugin                                    (arquivo marcador - 1 byte)
└── com.vhsystem.defaultlabel_1.0.0.qualifier.jar  (JAR completo do plugin)
```

**Total: 2 arquivos**
- 1 marcador
- 1 JAR

---

## ❌ O Que Eu Estava Fazendo ERRADO

### Tentativa 1 (ERRADA):
```
.archiplugin (ZIP)
├── com.vhsystem.defaultlabel_1.0.0.qualifier.jar  (JAR)
└── com/vhsystem/defaultlabel/*.class               (Arquivos .class duplicados)
```
❌ JAR + .class duplicados → Tamanho errado (43 KB)

### Tentativa 2 (ERRADA):
```
.archiplugin (ZIP)
└── com/vhsystem/defaultlabel/*.class  (Apenas .class)
```
❌ Sem JAR, sem marcador

### Tentativa 3 (ERRADA):
```
.archiplugin (ZIP)
├── archi-plugin
└── com/vhsystem/defaultlabel/*.class  (Apenas .class)
```
❌ Com marcador mas sem JAR

### Tentativa 4 (ERRADA):
```
.archiplugin (ZIP)
└── com.vhsystem.defaultlabel_1.0.0.qualifier/
    ├── archi-plugin
    ├── META-INF/MANIFEST.MF
    └── com/vhsystem/defaultlabel/*.class
```
❌ Arquivos em diretório, sem JAR

### Tentativa 5 (ERRADA):
```
.archiplugin (JAR com arquivos diretos)
├── META-INF/MANIFEST.MF
├── archi-plugin
└── com/vhsystem/defaultlabel/*.class
```
❌ JAR com conteúdo direto ao invés de ZIP com JAR

---

## ✅ Formato CORRETO (O Que Funciona!)

```
.archiplugin (ZIP)
├── archi-plugin                                    (marcador - 1 byte)
└── com.vhsystem.defaultlabel_1.0.0.qualifier.jar  (JAR completo)
```

**Dentro do JAR:**
```
com.vhsystem.defaultlabel_1.0.0.qualifier.jar
├── META-INF/
│   └── MANIFEST.MF  (com Bundle-SymbolicName, Bundle-Activator, etc.)
├── archi-plugin
├── build.properties
├── plugin.xml
└── com/
    └── vhsystem/
        └── defaultlabel/
            ├── DefaultLabelPlugin.class
            ├── LabelManager.class
            ├── StartupHandler.class
            ├── dialogs/
            │   └── ManageLabelsDialog.class
            └── handlers/
                └── ManageLabelsHandler.class
```

---

## 🔧 Como Criar Corretamente

### Passo a Passo:

#### 1. Criar o JAR do plugin completo:

```bash
cd final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier

# Criar arquivo marcador
touch archi-plugin

# Criar JAR com MANIFEST.MF
jar cmf META-INF/MANIFEST.MF \
  ../../final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier.jar \
  -C . .
```

**Resultado:** `final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier.jar` (~23 KB)

#### 2. Criar o .archiplugin (ZIP com marcador + JAR):

```bash
cd final-plugin

# Criar arquivo marcador temporário
echo "" > archi-plugin

# Criar ZIP (.archiplugin) com marcador + JAR
zip ../com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin \
  archi-plugin \
  com.vhsystem.defaultlabel_1.0.0.qualifier.jar

# Remover marcador temporário
rm -f archi-plugin
```

**Resultado:** `com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin` (~21 KB)

---

## 📊 Características do Arquivo Final

| Propriedade | Valor |
|-------------|-------|
| **Nome** | com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin |
| **Tipo** | ZIP |
| **Tamanho** | ~21 KB |
| **Arquivos** | 2 (marcador + JAR) |
| **Conteúdo** | archi-plugin + com.vhsystem.defaultlabel_1.0.0.qualifier.jar |

---

## ✅ Validação

### Para verificar se está correto:

```bash
# Ver estrutura
unzip -l com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin

# Deve mostrar:
#   archi-plugin
#   com.vhsystem.defaultlabel_1.0.0.qualifier.jar

# Verificar o JAR interno
unzip -p com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin \
  com.vhsystem.defaultlabel_1.0.0.qualifier.jar | \
  jar tf -

# Deve mostrar os arquivos do plugin (META-INF/MANIFEST.MF, com/vhsystem/..., etc.)
```

---

## 🚀 Instalação

No Archi:
1. **Help → Manage Plug-ins...**
2. **Install...**
3. Selecionar: `com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin`
4. Escolher: **"Install in user plugins directory"**
5. Confirmar e reiniciar

---

## 🎯 Por Que Este Formato?

### O Archi espera:
1. Um arquivo ZIP com extensão `.archiplugin`
2. Contendo um arquivo marcador `archi-plugin`
3. E um (ou mais) arquivo(s) JAR do plugin

### O JAR do plugin deve:
- Ter MANIFEST.MF com metadados OSGi (Bundle-SymbolicName, etc.)
- Conter todas as classes compiladas
- Ter plugin.xml com extensões Eclipse
- Incluir arquivo marcador `archi-plugin` dentro dele também

---

## 📝 Comparação: Todas as Tentativas

| Tentativa | Formato | Conteúdo | Tamanho | Funcionou? |
|-----------|---------|----------|---------|------------|
| 1 | ZIP | JAR + .class | 43 KB | ❌ Não |
| 2 | ZIP | Apenas .class | 24 KB | ❌ Não |
| 3 | ZIP | marcador + .class | 24 KB | ❌ Não |
| 4 | ZIP | Diretório com .class | 26 KB | ❌ Não |
| 5 | JAR | Arquivos diretos | 23 KB | ❌ Não |
| **6** | **ZIP** | **marcador + JAR** | **21 KB** | **✅ SIM!** |

---

## 🔄 Script Atualizado

O script `build_archiplugin.sh` foi atualizado para seguir este formato:

```bash
./build_archiplugin.sh
```

Ele agora:
1. ✅ Cria o JAR completo do plugin com `jar cmf`
2. ✅ Cria o .archiplugin como ZIP contendo marcador + JAR
3. ✅ Valida a estrutura
4. ✅ Verifica integridade

---

## 🎯 Conclusão

**Formato que FUNCIONA:**
- **Nível 1:** ZIP chamado `.archiplugin`
  - **Nível 2:** Contém `archi-plugin` (marcador) + `.jar` (plugin completo)
    - **Nível 3:** Dentro do JAR estão os arquivos do plugin (MANIFEST.MF, .class, plugin.xml, etc.)

**Chave do sucesso:** O Archi espera um **contêiner ZIP** com um **JAR completo** dentro, não arquivos soltos!

---

**Data:** 10/11/2025  
**Tentativas:** 6  
**Solução:** ZIP contendo marcador + JAR  
**Status:** ✅ **CORRETO E FUNCIONAL**

