# Menu Location Fix - Technical Details

## Problem

The plugin was not appearing in the Tools menu as expected.

## Root Cause

The `locationURI` in `plugin.xml` was using an incorrect menu ID:

```xml
<!-- INCORRECT -->
<menuContribution locationURI="menu:com.archimatetool.editor.menu.tools?after=additions">
```

## Solution

After examining Archi's own `plugin.xml` file at:
```
/home/victor/apps/Archi/plugins/com.archimatetool.editor_5.6.0.202505120659/plugin.xml
```

We discovered that Archi uses standard Eclipse menu IDs, not custom namespaced IDs.

The correct syntax is:

```xml
<!-- CORRECT -->
<menuContribution locationURI="menu:tools?after=additions">
```

## Standard Eclipse Menu IDs

For reference, here are the standard Eclipse menu IDs that can be used in Archi plugins:

- `menu:file` - File menu
- `menu:edit` - Edit menu  
- `menu:tools` - Tools menu ✅ (used by this plugin)
- `menu:window` - Window menu
- `menu:help` - Help menu

## How to Add Items to Archi Menus

To add a menu item to any standard Eclipse menu in Archi:

```xml
<extension point="org.eclipse.ui.menus">
   <menuContribution locationURI="menu:tools?after=additions">
      <command
            commandId="your.plugin.command.id"
            id="your.plugin.menu.id"
            label="Your Menu Item Label"
            style="push">
      </command>
   </menuContribution>
</extension>
```

## Files Changed

1. `plugin.xml` - Updated `locationURI` to `menu:tools`
2. Plugin recompiled and reinstalled

## Verification

After the fix, the menu item appears correctly:

**Tools → Manage Default Labels**

This places the plugin's functionality alongside other Archi tools like "Properties" and "Specializations".

## Lesson Learned

When integrating with Eclipse/Archi menus, always use the standard Eclipse menu IDs rather than trying to construct custom namespaced IDs. The best way to find these is to examine how Archi's own plugins define their menu contributions.

