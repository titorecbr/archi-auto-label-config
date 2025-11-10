# Guia Rápido - Default Label Plugin

## ⚡ Instalação Rápida (5 minutos)

### Passo 1: Preparar no Eclipse

1. **Abra o Eclipse IDE**
2. **Importe o projeto**:
   - `File → Import → Existing Projects into Workspace`
   - Navegue até a pasta do plugin
   - Selecione o projeto e clique em `Finish`

3. **Configure as dependências** (IMPORTANTE):
   - Clique com botão direito no projeto → `Properties`
   - `Java Build Path → Libraries → Add External JARs`
   - Você precisa adicionar os JARs do Archi. Localize-os em:
     - Linux: `~/.archi/plugins/` ou `/opt/archi/plugins/`
     - Windows: `C:\Program Files\Archi\plugins\` ou `%USERPROFILE%\.archi\plugins\`
     - macOS: `/Applications/Archi.app/Contents/Eclipse/plugins/` ou `~/Library/Application Support/Archi/plugins/`
   
   **JARs necessários** (procure por versões similares):
   - `com.archimatetool.model_*.jar`
   - `com.archimatetool.editor_*.jar`
   - `org.eclipse.core.runtime_*.jar` (geralmente já disponível)
   - `org.eclipse.ui_*.jar` (geralmente já disponível)
   - `org.eclipse.jface_*.jar` (geralmente já disponível)

4. **Compile o projeto**:
   - `Project → Clean → Build`
   - Verifique se não há erros na aba `Problems`

### Passo 2: Exportar o Plugin

1. **Exporte como plugin deployável**:
   - `File → Export → Plug-in Development → Deployable plug-ins and fragments`
   - Selecione `com.vhsystem.defaultlabel`
   - Escolha `Directory` como destino
   - Selecione uma pasta (ex: `~/archi-plugin-export`)
   - Clique em `Finish`

2. **Localize o plugin exportado**:
   - Vá até a pasta que você escolheu
   - Você verá uma pasta como: `plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/`

### Passo 3: Instalar no Archi

1. **Localize a pasta de plugins do Archi**:
   ```bash
   # Linux
   ~/.archi/plugins/
   
   # Windows
   C:\Users\<seu-usuario>\.archi\plugins\
   
   # macOS
   ~/Library/Application Support/Archi/plugins/
   ```

2. **Copie o plugin**:
   - Copie a pasta `com.vhsystem.defaultlabel_1.0.0.qualifier` para a pasta de plugins do Archi
   - A estrutura final deve ser:
     ```
     ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
     ├── META-INF/
     ├── plugin.xml
     └── com/vhsystem/defaultlabel/...
     ```

3. **Reinicie o Archi**:
   - Feche completamente o Archi
   - Abra novamente

### Passo 4: Verificar Instalação

1. **Verifique o menu**:
   - Deve aparecer um novo menu "Labels Padrão" no menu principal
   - Clique em `Labels Padrão → Gerenciar Labels Padrão`

2. **Configure os labels padrão**:
   - Uma janela abrirá com todos os tipos de elementos
   - Clique duas vezes em qualquer célula "Label Padrão" para editar
   - As alterações são salvas automaticamente

3. **Teste**:
   - Crie um novo elemento no Archi sem definir um nome
   - O plugin deve aplicar automaticamente o label padrão configurado

## 🔧 Solução Rápida de Problemas

### Erro: "Cannot resolve com.archimatetool.*"
- **Solução**: Adicione os JARs do Archi ao Build Path (veja Passo 1.3)

### Plugin não aparece no menu
- Verifique se copiou a pasta completa para `~/.archi/plugins/`
- Verifique os logs: `Help → Show Log`
- Certifique-se de que reiniciou o Archi completamente

### Labels não são aplicados
- Abra `Labels Padrão → Gerenciar Labels Padrão`
- Configure labels padrão para os tipos de elementos que você usa
- Certifique-se de criar elementos sem nome inicial

## 📝 Estrutura Esperada Após Exportação

```
plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
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

## ✅ Checklist de Instalação

- [ ] Projeto importado no Eclipse
- [ ] Dependências do Archi adicionadas ao Build Path
- [ ] Projeto compilado sem erros
- [ ] Plugin exportado via Eclipse
- [ ] Pasta do plugin copiada para `~/.archi/plugins/`
- [ ] Archi reiniciado
- [ ] Menu "Labels Padrão" aparece
- [ ] Dialog de gerenciamento abre corretamente
- [ ] Labels são aplicados automaticamente

## 🆘 Precisa de Ajuda?

Consulte `INSTALL.md` para instruções detalhadas ou `README.md` para documentação completa.

