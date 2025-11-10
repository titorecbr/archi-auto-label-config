# How to Find Archi Dependencies

To compile the plugin, you need to add Archi JARs to Eclipse's Build Path.

## Dependency Locations

### Linux

1. **If Archi is installed via package**:
   ```bash
   /opt/archi/plugins/
   # or
   /usr/share/archi/plugins/
   ```

2. **If Archi is in home folder**:
   ```bash
   ~/.archi/plugins/
   ```

3. **If you downloaded Archi**:
   ```bash
   ~/Downloads/archi/plugins/
   # or wherever you extracted it
   ```

### Windows

1. **Standard installation**:
   ```
   C:\Program Files\Archi\plugins\
   ```

2. **User folder**:
   ```
   C:\Users\<username>\.archi\plugins\
   ```

3. **If you downloaded Archi**:
   ```
   C:\Archi\plugins\
   # or wherever you extracted it
   ```

### macOS

1. **Application**:
   ```
   /Applications/Archi.app/Contents/Eclipse/plugins/
   ```

2. **User folder**:
   ```
   ~/Library/Application Support/Archi/plugins/
   ```

## Required JARs

Look for these files (version numbers may vary):

### Mandatory:
- `com.archimatetool.model_*.jar` (e.g., `com.archimatetool.model_5.0.0.jar`)
- `com.archimatetool.editor_*.jar` (e.g., `com.archimatetool.editor_5.0.0.jar`)

### Usually already available in Eclipse:
- `org.eclipse.core.runtime_*.jar`
- `org.eclipse.ui_*.jar`
- `org.eclipse.jface_*.jar`
- `org.eclipse.swt_*.jar`

## How to Add in Eclipse

1. **In Eclipse, open the project**
2. **Right-click → Properties**
3. **Java Build Path → Libraries**
4. **Add External JARs...**
5. **Navigate to Archi's plugins folder**
6. **Select required JARs**:
   - `com.archimatetool.model_*.jar`
   - `com.archimatetool.editor_*.jar`
7. **Apply and Close**

## Script to Find Automatically (Linux/macOS)

Run in terminal:

```bash
# Linux
find ~ -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1

# macOS
find /Applications -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1
```

This will show where the Archi JARs are located.

## Alternative: Download Archi SDK

If you can't find the JARs, you can:

1. Download complete Archi
2. Extract required JARs
3. Or use Archi SDK if available

## Verification

After adding dependencies, verify:

1. **Project → Clean → Build**
2. There should be no compilation errors
3. In "Problems" tab, no errors related to `com.archimatetool.*`

## Tip

If you already have Archi installed and working, the JARs are somewhere on your system. Use the `find` command above to locate them.

## Dependency Details

### com.archimatetool.model

Provides:
- Core ArchiMate model interfaces
- Element type definitions (IBusinessActor, IApplicationComponent, etc.)
- Model structure (IArchimateModel, IFolder, etc.)
- Relationship types

**Required for:** All core plugin functionality

### com.archimatetool.editor

Provides:
- Editor model manager (IEditorModelManager)
- Diagram object interfaces (IDiagramModelArchimateObject)
- Property event notifications
- UI integration points

**Required for:** Event listening, element creation detection, diagram manipulation

### Eclipse Platform JARs

**org.eclipse.core.runtime:**
- Plugin lifecycle management
- Preferences API
- Platform logging

**org.eclipse.ui:**
- Menu contributions
- Command framework
- Handlers

**org.eclipse.jface:**
- Dialog framework
- Table viewer
- UI components

**org.eclipse.swt:**
- Native widgets
- Display management
- Event handling

## Common Issues

### "Cannot find com.archimatetool.model"

**Solution:** 
1. Locate Archi installation directory
2. Find plugins subfolder
3. Add model JAR to Build Path

### "Wrong class file version"

**Solution:**
- Ensure Java 11+ is installed
- Update Eclipse to recent version
- Verify Archi version matches plugin requirements

### "SWT not found"

**Solution:**
- Usually available in Eclipse automatically
- If missing, add from Eclipse installation:
  `<eclipse-dir>/plugins/org.eclipse.swt_*.jar`

## Automated Dependency Resolution

The build script `scripts/build_final.sh` can automatically:
- Locate Archi installation
- Find required JARs
- Set up classpath
- Compile sources

Usage:
```bash
bash scripts/build_final.sh /path/to/archi
```

## For Distribution

When distributing the plugin, you **do not** need to include Archi JARs. The plugin uses OSGi dependency resolution at runtime, automatically finding required bundles from the host Archi installation.

## Development Tips

### Target Platform

For Eclipse PDE development, set up a target platform:
1. Window → Preferences → Plug-in Development → Target Platform
2. Add → Directory → Select Archi installation folder
3. This makes all Archi bundles available

### Source Attachments

To view Archi source code while debugging:
1. Right-click JAR in Build Path
2. Properties → Java Source Attachment
3. Point to Archi source (if available)

## Related Documentation

- [BUILD_GUIDE.md](BUILD_GUIDE.md) - Complete build instructions
- [INSTALL.md](INSTALL.md) - Installation guide
- [EXPORT_INSTRUCTIONS.txt](EXPORT_INSTRUCTIONS.txt) - Eclipse export steps
- [QUICK_START.md](QUICK_START.md) - Quick start guide

## Support

If you can't locate dependencies:
1. Check Archi installation is complete
2. Try automated build script
3. Consult Eclipse PDE documentation
4. Check Archi plugin development guides
