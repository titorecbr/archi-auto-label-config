# Menu Location Change

## Summary

The plugin menu has been moved from a separate menu to the existing **Tools** menu in Archi.

## Changes

### Before (v1.0.0 - initial)
```
Archi Menu Bar
├── File
├── Edit
├── View
├── ...
├── Default Labels          ← Separate menu (REMOVED)
│   └── Manage Default Labels
└── Help
```

### After (v1.0.1 - current)
```
Archi Menu Bar
├── File
├── Edit
├── View
├── ...
├── Tools
│   ├── (other tools...)
│   └── Manage Default Labels    ← Now here!
└── Help
```

## Benefits

1. **Better Integration**: Follows Eclipse/Archi plugin conventions
2. **Less Menu Clutter**: Doesn't create a separate menu for one item
3. **More Professional**: Standard location for configuration dialogs
4. **Easier to Find**: Users expect tools in the Tools menu

## Technical Details

### Modified Files
- `plugin.xml` - Changed `menuContribution` locationURI

### Before
```xml
<menuContribution locationURI="menu:org.eclipse.ui.main.menu?after=additions">
   <menu id="com.vhsystem.defaultlabel.menu" label="Default Labels">
      <command commandId="com.vhsystem.defaultlabel.commands.manageLabels" 
               label="Manage Default Labels">
      </command>
   </menu>
</menuContribution>
```

### After
```xml
<menuContribution locationURI="menu:com.archimatetool.editor.menu.tools?after=additions">
   <command commandId="com.vhsystem.defaultlabel.commands.manageLabels" 
            id="com.vhsystem.defaultlabel.menu.manageLabels"
            label="Manage Default Labels"
            style="push">
   </command>
</menuContribution>
```

## User Instructions

### How to Access
1. Open Archi
2. Click on **Tools** in the menu bar
3. Select **Manage Default Labels**

### Migration Note
If you were using the old menu location:
- The separate "Default Labels" menu no longer exists
- The same functionality is now in: **Tools → Manage Default Labels**
- All your saved configurations are preserved

## Version History

- **v1.0.0**: Initial release with separate menu
- **v1.0.1**: Moved to Tools menu (current)

