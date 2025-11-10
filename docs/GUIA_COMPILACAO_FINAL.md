# Guia Final de Compilação

## ✅ Status Atual

- ✅ Código do plugin: **COMPLETO**
- ✅ Estrutura do projeto: **PRONTA**
- ✅ Arquivos de configuração: **PRONTOS**
- ⚠️ Compilação: **PRECISA DO ECLIPSE**

## 📍 Localização do Projeto

```
/home/victor/Projetos/VH System/Archi Plugin/
```

## 🚀 Como Compilar (Passo a Passo)

### Opção 1: Usando o Script Interativo

Execute no terminal:
```bash
cd "/home/victor/Projetos/VH System/Archi Plugin"
./execute_compile.sh
```

O script vai perguntar onde está o Eclipse e abrir para você.

### Opção 2: Manual (Recomendado)

#### 1. Abra o Eclipse
- Execute o Eclipse que você baixou
- Escolha um workspace (ex: `/home/victor/Projetos/VH System/eclipse-workspace`)

#### 2. Importe o Projeto
```
File → Import → Existing Projects into Workspace
→ Browse → /home/victor/Projetos/VH System/Archi Plugin
→ Marque o projeto
→ Finish
```

#### 3. Encontre as Dependências do Archi

Execute no terminal para encontrar os JARs:
```bash
find ~ -name "com.archimatetool.model_*.jar" 2>/dev/null
find ~ -name "com.archimatetool.editor_*.jar" 2>/dev/null
```

Ou procure em:
- `~/.archi/plugins/`
- Onde você instalou o Archi
- Se instalou via AppImage, extraia o AppImage e procure dentro

#### 4. Configure as Dependências no Eclipse

1. Clique direito no projeto → **Properties**
2. **Java Build Path** → **Libraries**
3. **Add External JARs...**
4. Selecione:
   - `com.archimatetool.model_*.jar`
   - `com.archimatetool.editor_*.jar`
5. **Apply and Close**

#### 5. Compile

```
Project → Clean...
→ Selecione o projeto
→ Clean
```

O projeto será compilado automaticamente.

#### 6. Verifique Erros

- Aba **Problems** → Não deve haver erros
- Se houver erros sobre `com.archimatetool.*`, volte ao passo 3

#### 7. Exporte o Plugin

```
File → Export
→ Plug-in Development → Deployable plug-ins and fragments
→ Next
→ Selecione: com.vhsystem.defaultlabel
→ Escolha "Directory"
→ Browse → Escolha uma pasta (ex: ~/archi-plugin-final)
→ Finish
```

#### 8. Instale no Archi

```bash
# Copie a pasta exportada
cp -r ~/archi-plugin-final/plugins/com.vhsystem.defaultlabel_* ~/.archi/plugins/

# Reinicie o Archi
```

## 📂 Estrutura Após Exportação

Após exportar, você terá:
```
~/archi-plugin-final/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
├── META-INF/
│   └── MANIFEST.MF
├── plugin.xml
├── build.properties
└── com/
    └── vhsystem/
        └── defaultlabel/
            ├── DefaultLabelPlugin.class
            ├── LabelManager.class
            ├── dialogs/
            │   └── ManageLabelsDialog.class
            └── handlers/
                └── ManageLabelsHandler.class
```

## 🔍 Verificação Final

Após instalar no Archi:

1. ✅ Reinicie o Archi completamente
2. ✅ Verifique se aparece o menu **"Labels Padrão"**
3. ✅ Clique em **"Labels Padrão → Gerenciar Labels Padrão"**
4. ✅ Se a janela abrir, está funcionando!

## 🆘 Problemas Comuns

### Erro: "Cannot resolve com.archimatetool.*"
**Solução**: Adicione os JARs do Archi ao Build Path (passo 3-4)

### Não encontra os JARs do Archi
**Solução**: 
- Se instalou via AppImage, extraia: `./Archi.AppImage --appimage-extract`
- Procure em `squashfs-root/plugins/`
- Ou baixe o Archi novamente e extraia os plugins

### Plugin não aparece no Archi
**Solução**:
- Verifique se copiou a pasta completa
- Verifique `Help → Show Log` no Archi
- Certifique-se de reiniciar completamente

## 📝 Arquivos de Ajuda

- `COMPILAR_AGORA.txt` - Instruções detalhadas
- `QUICK_START.md` - Guia rápido
- `FIND_DEPENDENCIES.md` - Como encontrar dependências

---

**Pronto! Siga os passos acima e seu plugin estará funcionando!** 🎉

