================================================================================
PLUGIN EXPORTADO - Default Label Plugin para Archi
================================================================================

ESTRUTURA CRIADA:
-----------------
export/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/

IMPORTANTE: Este plugin ainda precisa ser COMPILADO no Eclipse antes de
ser instalado no Archi. As classes Java (.class) não foram geradas ainda.

PRÓXIMOS PASSOS:
----------------

OPÇÃO 1: Compilar no Eclipse (RECOMENDADO)
-------------------------------------------
1. Abra o Eclipse IDE
2. File → Import → Existing Projects into Workspace
   → Selecione: "/home/victor/Projetos/VH System/Archi Plugin"
3. Configure as dependências do Archi (veja FIND_DEPENDENCIES.md)
4. Project → Clean → Build
5. File → Export → Deployable plug-ins and fragments
   → Selecione: com.vhsystem.defaultlabel
   → Escolha: Directory
   → Escolha uma pasta (ex: ~/archi-plugin-final)
   → Finish
6. Use a pasta exportada pelo Eclipse para instalar no Archi

OPÇÃO 2: Usar esta estrutura diretamente (AVANÇADO)
---------------------------------------------------
Se você já tem as classes compiladas (.class), copie-as para:
export/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/com/vhsystem/defaultlabel/

Estrutura necessária:
- DefaultLabelPlugin.class
- LabelManager.class
- dialogs/ManageLabelsDialog.class
- handlers/ManageLabelsHandler.class

INSTALAÇÃO NO ARCHI:
--------------------
Após compilar no Eclipse:

1. Localize a pasta de plugins do Archi:
   Linux:   ~/.archi/plugins/
   Windows: C:\Users\<usuario>\.archi\plugins\
   macOS:    ~/Library/Application Support/Archi/plugins/

2. Copie a pasta completa:
   com.vhsystem.defaultlabel_1.0.0.qualifier/
   
   Para dentro de ~/.archi/plugins/

3. Reinicie o Archi

================================================================================

