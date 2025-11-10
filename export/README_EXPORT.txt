================================================================================
EXPORTED PLUGIN - Default Label Plugin for Archi
================================================================================

STRUCTURE CREATED:
------------------
export/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/

IMPORTANT: This plugin still needs to be COMPILED in Eclipse before
being installed in Archi. The Java classes (.class) have not been generated yet.

NEXT STEPS:
-----------

OPTION 1: Compile in Eclipse (RECOMMENDED)
-------------------------------------------
1. Open Eclipse IDE
2. File → Import → Existing Projects into Workspace
   → Select: "/path/to/archi-auto-label-config"
3. Configure Archi dependencies (see docs/FIND_DEPENDENCIES.md)
4. Project → Clean → Build
5. File → Export → Deployable plug-ins and fragments
   → Select: com.vhsystem.defaultlabel
   → Choose: Directory
   → Choose a folder (e.g., ~/archi-plugin-final)
   → Finish
6. Use the folder exported by Eclipse to install in Archi

OPTION 2: Use this structure directly (ADVANCED)
-------------------------------------------------
If you already have the compiled classes (.class), copy them to:
export/plugins/com.vhsystem.defaultlabel_1.0.0.qualifier/com/vhsystem/defaultlabel/

Required structure:
- DefaultLabelPlugin.class
- LabelManager.class
- StartupHandler.class
- dialogs/ManageLabelsDialog.class
- handlers/ManageLabelsHandler.class

INSTALLATION IN ARCHI:
----------------------
After compiling in Eclipse:

1. Locate Archi's plugins folder:
   Linux:   ~/.archi/dropins/
   Windows: C:\Users\<username>\.archi\dropins\
   macOS:   ~/Library/Application Support/Archi/dropins/

2. Copy the complete folder:
   com.vhsystem.defaultlabel_1.0.0.qualifier/
   
   Into ~/.archi/dropins/

3. Restart Archi

ALTERNATIVE: Use pre-built JAR from final-plugin/ directory

================================================================================
