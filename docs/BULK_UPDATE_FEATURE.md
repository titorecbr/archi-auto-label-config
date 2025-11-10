# Funcionalidade de Atualização em Lote de Labels

## O Que Foi Implementado

A dialog de gerenciamento de labels agora possui uma funcionalidade de atualização em lote que permite atualizar automaticamente todos os elementos existentes no modelo quando você modifica as configurações de labels.

## Como Funciona

### 1. Detecção Automática de Alterações

Quando você clica em **OK** na dialog de gerenciamento de labels, o plugin:

1. **Compara** os valores originais dos labels com os valores atuais
2. **Detecta** se houve qualquer alteração em qualquer tipo de elemento
3. **Pergunta** se você deseja atualizar todos os elementos existentes

### 2. Diálogo de Confirmação

Se houver alterações, você verá uma mensagem:

```
Labels have been modified. Do you want to update all existing 
elements to match the new label configurations?

This will process ALL diagrams in ALL models currently open 
in your workspace, updating all diagram objects of the modified types.
```

**Opções:**
- **Yes**: Atualiza todos os elementos do modelo
- **No**: Salva as configurações mas não atualiza os elementos existentes

### 3. Atualização em Massa

Se você escolher **Yes**, o plugin:

1. **Percorre** todos os modelos carregados no workspace do Archi
2. **Visita** TODOS os diagramas em cada modelo (não apenas os diagramas visualmente abertos)
3. **Processa** recursivamente todos os elementos em cada diagrama
4. **Aplica** o novo label configurado a cada elemento que corresponda ao tipo modificado
5. **Exibe** uma mensagem detalhada informando:
   - Quantos elementos foram atualizados
   - Em quantos diagramas
   - Quantos modelos foram processados

## Exemplo de Uso

### Cenário

Você tem um modelo com 50 elementos do tipo "Application Component" que atualmente exibem apenas o nome. Você quer que todos mostrem também a especialização.

### Passos

1. Abra o menu **Labels Padrão** → **Gerenciar Labels Padrão**
2. Localize a linha **Application Component**
3. Modifique o label de `${name}` para `<<${specialization}>>\n${name}`
4. Clique em **OK**
5. O plugin detecta a alteração e pergunta se você quer atualizar os elementos existentes
6. Clique em **Yes**
7. Todos os 50 elementos são atualizados automaticamente!
8. Você verá uma mensagem: "Successfully updated 50 element(s)..."

## Benefícios

### 🎯 Consistência
Mantém todos os elementos do seu modelo com o mesmo padrão de labels

### ⚡ Rapidez
Atualiza dezenas ou centenas de elementos em segundos

### 🔄 Facilidade
Não precisa editar elemento por elemento manualmente

### 🛡️ Segurança
Pede confirmação antes de fazer alterações em massa

## Detalhes Técnicos

### Processamento Recursivo

O plugin processa elementos de forma recursiva, incluindo:
- Elementos em diagramas principais
- Elementos dentro de containers
- Elementos aninhados em múltiplos níveis

### Tipos Suportados

Funciona com todos os tipos de elementos ArchiMate, incluindo:
- Application Layer (8 tipos)
- Business Layer (10 tipos)
- Technology Layer (14 tipos)
- Physical Layer (5 tipos)
- Data Layer (1 tipo)
- Strategy Layer (5 tipos)
- Motivation Layer (11 tipos)
- Implementation & Migration Layer (5 tipos)
- Outros elementos (3 tipos)

### Logs

O plugin gera logs detalhados no console do Archi:

```
[ManageLabelsDialog] Starting bulk update of all elements in workspace...
[ManageLabelsDialog] Found 1 model(s) in workspace
[ManageLabelsDialog] Processing model: My ArchiMate Model
[ManageLabelsDialog]   Found 5 diagram(s) in this model
[ManageLabelsDialog]   Processing diagram: Application Layer
[ManageLabelsDialog] ✓ Updated: IApplicationComponent - My App
[ManageLabelsDialog] ✓ Updated: IApplicationComponent - Another App
[ManageLabelsDialog]   Processing diagram: Business Layer
[ManageLabelsDialog]   Processing diagram: Technology Layer
...
[ManageLabelsDialog] ✅ Bulk update complete!
[ManageLabelsDialog]   Updated 50 element(s) in 3 diagram(s)
```

## Arquivo Modificado

**ManageLabelsDialog.java**

Adições principais:
1. Campo `originalLabels` para rastrear valores originais
2. Método `okPressed()` - detecta alterações e coordena atualização
3. Método `detectChanges()` - compara valores originais com atuais
4. Método `updateAllElementsInModel()` - coordena atualização em todos os modelos
5. Método `processDiagram()` - processa todos os elementos de um diagrama
6. Método `processElement()` - aplica labels recursivamente

## Notas

- A funcionalidade só é ativada se houver alterações nos labels
- Você sempre tem a opção de recusar a atualização em massa
- Os elementos são atualizados respeitando a estrutura hierárquica do modelo
- A atualização é feita usando a mesma API que o plugin usa para novos elementos

## Próximos Passos

Para testar:

1. Reinicie o Archi
2. Abra um modelo existente
3. Abra **Labels Padrão** → **Gerenciar Labels Padrão**
4. Modifique algum label
5. Clique em **OK** e confirme a atualização
6. Observe os elementos sendo atualizados!

---

**Implementado em:** 10 de Novembro de 2025
**Versão do Plugin:** 1.0.0.qualifier

