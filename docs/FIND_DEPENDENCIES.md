# Como Encontrar as Dependências do Archi

Para compilar o plugin, você precisa adicionar os JARs do Archi ao Build Path do Eclipse.

## Localizações das Dependências

### Linux

1. **Se o Archi está instalado via pacote**:
   ```bash
   /opt/archi/plugins/
   ou
   /usr/share/archi/plugins/
   ```

2. **Se o Archi está na pasta home**:
   ```bash
   ~/.archi/plugins/
   ```

3. **Se você baixou o Archi**:
   ```bash
   ~/Downloads/archi/plugins/
   ou onde você descompactou
   ```

### Windows

1. **Instalação padrão**:
   ```
   C:\Program Files\Archi\plugins\
   ```

2. **Pasta do usuário**:
   ```
   C:\Users\<seu-usuario>\.archi\plugins\
   ```

3. **Se você baixou o Archi**:
   ```
   C:\Archi\plugins\
   ou onde você descompactou
   ```

### macOS

1. **Aplicativo**:
   ```
   /Applications/Archi.app/Contents/Eclipse/plugins/
   ```

2. **Pasta do usuário**:
   ```
   ~/Library/Application Support/Archi/plugins/
   ```

## JARs Necessários

Procure por estes arquivos (os números de versão podem variar):

### Obrigatórios:
- `com.archimatetool.model_*.jar` (ex: `com.archimatetool.model_5.0.0.jar`)
- `com.archimatetool.editor_*.jar` (ex: `com.archimatetool.editor_5.0.0.jar`)

### Geralmente já disponíveis no Eclipse:
- `org.eclipse.core.runtime_*.jar`
- `org.eclipse.ui_*.jar`
- `org.eclipse.jface_*.jar`
- `org.eclipse.swt_*.jar`

## Como Adicionar no Eclipse

1. **No Eclipse, abra o projeto**
2. **Clique com botão direito → Properties**
3. **Java Build Path → Libraries**
4. **Add External JARs...**
5. **Navegue até a pasta de plugins do Archi**
6. **Selecione os JARs necessários**:
   - `com.archimatetool.model_*.jar`
   - `com.archimatetool.editor_*.jar`
7. **Apply and Close**

## Script para Encontrar Automaticamente (Linux/macOS)

Execute no terminal:

```bash
# Linux
find ~ -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1

# macOS
find /Applications -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1
```

Isso mostrará onde estão os JARs do Archi.

## Alternativa: Baixar o Archi SDK

Se você não conseguir encontrar os JARs, você pode:

1. Baixar o Archi completo
2. Extrair os JARs necessários
3. Ou usar o Archi SDK se disponível

## Verificação

Após adicionar as dependências, verifique:

1. **Project → Clean → Build**
2. Não deve haver erros de compilação
3. Na aba "Problems", não deve haver erros relacionados a `com.archimatetool.*`

## Dica

Se você já tem o Archi instalado e funcionando, os JARs estão em algum lugar do seu sistema. Use o comando `find` acima para localizá-los.

