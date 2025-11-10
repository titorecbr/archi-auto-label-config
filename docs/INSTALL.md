# Guia de Instalação - Default Label Plugin para Archi

## Método 1: Instalação via Eclipse (Recomendado)

### Pré-requisitos
- Eclipse IDE for RCP and RAP Developers
- Archi instalado (para obter as dependências)
- Java JDK 11 ou superior

### Passo a Passo

1. **Obter as dependências do Archi**:
   - Abra o Archi
   - Localize a pasta de instalação do Archi
   - Copie os seguintes JARs para uma pasta de referência:
     - `com.archimatetool.model_*.jar`
     - `com.archimatetool.editor_*.jar`
     - Outras dependências necessárias

2. **Importar o projeto no Eclipse**:
   ```
   File → Import → Existing Projects into Workspace
   → Selecione a pasta do plugin
   → Finish
   ```

3. **Configurar Build Path**:
   - Clique com botão direito no projeto → Properties
   - Java Build Path → Libraries → Add External JARs
   - Adicione os JARs do Archi copiados anteriormente
   - Adicione também as bibliotecas do Eclipse (devem estar disponíveis automaticamente):
     - `org.eclipse.core.runtime`
     - `org.eclipse.ui`
     - `org.eclipse.jface`

4. **Compilar o projeto**:
   ```
   Project → Clean → Build
   ```

5. **Exportar o plugin**:
   ```
   File → Export → Plug-in Development → Deployable plug-ins and fragments
   → Selecione "com.vhsystem.defaultlabel"
   → Escolha "Directory" como destino
   → Selecione uma pasta (ex: ~/archi-plugin-export)
   → Finish
   ```

6. **Instalar no Archi**:
   - Localize a pasta de plugins do Archi:
     - **Linux**: `~/.archi/plugins/`
     - **Windows**: `C:\Users\<usuario>\.archi\plugins\`
     - **macOS**: `~/Library/Application Support/Archi/plugins/`
   
   - Copie a pasta do plugin exportado para a pasta de plugins do Archi
   - A estrutura deve ser: `~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/`

7. **Reiniciar o Archi**:
   - Feche completamente o Archi
   - Abra novamente
   - Verifique se o menu "Labels Padrão" aparece no menu principal

## Método 2: Instalação Manual (Avançado)

Se você já tem o plugin compilado:

1. **Criar estrutura de diretórios**:
   ```bash
   mkdir -p ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier
   ```

2. **Copiar arquivos**:
   ```bash
   cp -r bin/* ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
   cp META-INF/MANIFEST.MF ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/META-INF/
   cp plugin.xml ~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
   ```

3. **Verificar estrutura**:
   A pasta do plugin deve conter:
   ```
   com.vhsystem.defaultlabel_1.0.0.qualifier/
   ├── META-INF/
   │   └── MANIFEST.MF
   ├── plugin.xml
   ├── com/
   │   └── vhsystem/
   │       └── defaultlabel/
   │           ├── DefaultLabelPlugin.class
   │           ├── LabelManager.class
   │           ├── dialogs/
   │           │   └── ManageLabelsDialog.class
   │           └── handlers/
   │               └── ManageLabelsHandler.class
   ```

4. **Reiniciar o Archi**

## Verificação da Instalação

Após instalar e reiniciar o Archi:

1. **Verificar menu**:
   - O menu "Labels Padrão" deve aparecer no menu principal
   - Clique em "Labels Padrão → Gerenciar Labels Padrão"

2. **Verificar logs** (se houver problemas):
   - Help → Show Log
   - Procure por erros relacionados ao plugin

3. **Testar funcionalidade**:
   - Crie um novo elemento no Archi sem definir um nome
   - O plugin deve aplicar automaticamente o label padrão configurado

## Solução de Problemas

### Plugin não aparece no menu
- Verifique se a pasta foi copiada para o local correto
- Verifique se o MANIFEST.MF está correto
- Verifique os logs do Archi (Help → Show Log)
- Certifique-se de que todas as dependências estão disponíveis

### Erro ao abrir o diálogo de gerenciamento
- Verifique se todas as classes foram compiladas corretamente
- Verifique se as dependências do Eclipse (org.eclipse.jface, org.eclipse.ui) estão disponíveis

### Labels não são aplicados automaticamente
- Verifique se há labels padrão configurados
- Abra "Labels Padrão → Gerenciar Labels Padrão" e configure os labels
- Verifique os logs para erros

### Erros de compilação
- Certifique-se de que todas as dependências do Archi estão no classpath
- Use o Eclipse IDE para compilar (método recomendado)
- Verifique se está usando Java 11 ou superior

## Desinstalação

Para remover o plugin:

1. Feche o Archi
2. Delete a pasta do plugin:
   ```bash
   rm -rf ~/.archi/plugins/com.vhsystem.defaultlabel_*
   ```
3. Reinicie o Archi

## Estrutura Final do Plugin

Após a instalação, a estrutura deve ser:

```
~/.archi/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/
├── META-INF/
│   └── MANIFEST.MF
├── plugin.xml
├── build.properties (opcional)
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

