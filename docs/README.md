# Plugin de Labels Padrão para Archi

Este plugin permite definir labels padrão que serão aplicados automaticamente quando novos elementos são criados no Archi, mantendo um padrão consistente em todo o repositório.

## Funcionalidades

- **Aplicação automática de labels**: Quando um novo elemento é criado sem label, o plugin aplica automaticamente o label padrão configurado para aquele tipo de elemento.
- **Gerenciamento de labels**: Interface gráfica para configurar e gerenciar os labels padrão de todos os tipos de elementos ArchiMate.
- **Persistência**: As configurações são salvas automaticamente e persistem entre sessões do Archi.

## Estrutura do Plugin

```
Archi Plugin/
├── META-INF/
│   └── MANIFEST.MF          # Manifesto do plugin Eclipse
├── src/
│   └── com/vhsystem/defaultlabel/
│       ├── DefaultLabelPlugin.java    # Classe principal do plugin
│       ├── LabelManager.java          # Gerenciador de labels padrão
│       ├── handlers/
│       │   └── ManageLabelsHandler.java  # Handler do comando de menu
│       └── dialogs/
│           └── ManageLabelsDialog.java   # Dialog de gerenciamento
├── plugin.xml               # Configuração de extensões Eclipse
├── build.properties         # Propriedades de build
└── README.md               # Este arquivo
```

## Como Compilar e Instalar

### Pré-requisitos

- Eclipse IDE for RCP and RAP Developers (ou similar)
- Archi SDK (disponível no repositório do Archi)
- Java JDK 11 ou superior

### Passos para Compilação

1. **Importar o projeto no Eclipse**:
   - File → Import → Existing Projects into Workspace
   - Selecione a pasta do plugin
   - Certifique-se de que as dependências do Archi estão configuradas

2. **Configurar Build Path**:
   - Clique com botão direito no projeto → Properties → Java Build Path
   - Adicione as bibliotecas do Archi:
     - `com.archimatetool.model`
     - `com.archimatetool.editor`
   - Adicione também as bibliotecas do Eclipse:
     - `org.eclipse.core.runtime`
     - `org.eclipse.ui`
     - `org.eclipse.jface`

3. **Compilar o plugin**:
   - Project → Clean → Build
   - O plugin será compilado na pasta `bin/`

4. **Exportar como Plugin**:
   - File → Export → Plug-in Development → Deployable plug-ins and fragments
   - Selecione o plugin
   - Escolha "Directory" e especifique uma pasta de destino
   - Clique em Finish

### Instalação no Archi

1. **Copiar o plugin**:
   - Copie a pasta do plugin exportado para a pasta `plugins` do Archi
   - Localização típica:
     - Windows: `C:\Users\<usuario>\.archi\plugins\`
     - Linux: `~/.archi/plugins/`
     - macOS: `~/Library/Application Support/Archi/plugins/`

2. **Reiniciar o Archi**:
   - Feche e abra o Archi novamente
   - O plugin será carregado automaticamente

3. **Verificar instalação**:
   - No menu principal, você deve ver um novo item "Labels Padrão"
   - Se não aparecer, verifique os logs do Archi para erros

## Como Usar

### Configurar Labels Padrão

1. Abra o Archi
2. Vá em **Labels Padrão → Gerenciar Labels Padrão** no menu principal
3. Uma janela será aberta mostrando todos os tipos de elementos ArchiMate
4. Para cada tipo de elemento, você pode:
   - **Editar o label padrão**: Clique duas vezes na célula "Label Padrão" e digite o novo valor
   - **Remover o label padrão**: Deixe a célula em branco
5. As alterações são salvas automaticamente ao fechar a janela

### Aplicação Automática

Quando você criar um novo elemento no Archi:
- Se o elemento não tiver um label definido, o plugin aplicará automaticamente o label padrão configurado
- Se o elemento já tiver um label, ele não será alterado

## Tipos de Elementos Suportados

O plugin suporta todos os tipos de elementos ArchiMate:

- **Application Layer**: Componente, Colaboração, Interface, Função, Interação, Processo, Serviço
- **Business Layer**: Ator, Colaboração, Evento, Função, Interação, Interface, Objeto, Processo, Papel, Serviço
- **Technology Layer**: Artefato, Colaboração, Dispositivo, Evento, Função, Interação, Interface, Rede, Nó, Processo, Serviço
- **Physical Layer**: Artefato, Localização, Caminho, Equipamento, Instalação, Material
- **Data Layer**: Objeto de Dados
- **Relationships**: Acesso, Agregação, Atribuição, Associação, Composição, Fluxo, Influência, Realização, Serviço, Especialização, Disparo
- **Outros**: Junção, Agrupamento, Localização, Nota, Limite

## Configuração Avançada

As configurações são armazenadas em um arquivo `default_labels.properties` na pasta de estado do plugin. Este arquivo pode ser editado manualmente se necessário, mas é recomendado usar a interface gráfica.

## Solução de Problemas

### Plugin não aparece no menu

- Verifique se o plugin foi copiado para a pasta correta
- Verifique os logs do Archi (Help → Show Log)
- Certifique-se de que todas as dependências estão disponíveis

### Labels não são aplicados automaticamente

- Verifique se há labels padrão configurados para os tipos de elementos que você está criando
- Certifique-se de que os elementos estão sendo criados sem label inicial
- Verifique os logs para erros

### Erros de compilação

- Verifique se todas as dependências do Archi estão no classpath
- Certifique-se de estar usando a versão correta do Java (JDK 11+)
- Verifique se a versão do Archi SDK é compatível

## Desenvolvimento

### Estrutura de Classes

- **DefaultLabelPlugin**: Classe principal que inicializa o plugin e registra listeners
- **LabelManager**: Gerencia o armazenamento e recuperação de labels padrão
- **ManageLabelsDialog**: Interface gráfica para gerenciar labels
- **ManageLabelsHandler**: Handler do comando de menu

### Extensibilidade

O plugin pode ser estendido para:
- Adicionar validação de labels
- Suportar templates de labels mais complexos
- Adicionar histórico de mudanças
- Exportar/importar configurações

## Licença

Este plugin foi desenvolvido para uso interno. Consulte a licença do Archi para informações sobre desenvolvimento de plugins.

## Suporte

Para problemas ou sugestões, consulte a documentação do Archi ou a comunidade de desenvolvedores.

