# Installation Guide - Default Label Plugin for Archi

Complete guide to installing the Default Label plugin for Archi.

## Quick Installation (Recommended)

### Requirements
- Archi 4.x or 5.x installed
- Java 11 or higher

### Steps

1. **Download** the plugin JAR file:
   - `com.vhsystem.defaultlabel_1.0.0.qualifier.jar`

2. **Locate** Archi's dropins folder:
   - **Linux/Mac**: `~/.archi/dropins/`
   - **Windows**: `%USERPROFILE%\.archi\dropins\`

3. **Copy** the JAR file to the dropins folder

4. **Restart** Archi completely

5. **Verify** installation:
   - Open Archi
   - Check **Tools → Manage Default Labels** menu

## Detailed Installation Methods

### Method 1: JAR Installation (Easiest)

This is the recommended method for end users.

**Linux/Mac:**
```bash
# Create dropins directory if it doesn't exist
mkdir -p ~/.archi/dropins/

# Copy the plugin
cp com.vhsystem.defaultlabel_1.0.0.qualifier.jar ~/.archi/dropins/

# Restart Archi
```

**Windows:**
```cmd
# Create dropins directory if it doesn't exist
mkdir %USERPROFILE%\.archi\dropins

# Copy the plugin
copy com.vhsystem.defaultlabel_1.0.0.qualifier.jar %USERPROFILE%\.archi\dropins\

# Restart Archi from Start Menu
```

### Method 2: Folder Installation

If you have the unpacked plugin folder:

**Linux/Mac:**
```bash
# Copy the plugin folder
cp -r com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/

# Restart Archi
```

**Windows:**
```cmd
# Copy the plugin folder
xcopy com.vhsystem.defaultlabel_1.0.0.qualifier %USERPROFILE%\.archi\dropins\com.vhsystem.defaultlabel_1.0.0.qualifier\ /E /I

# Restart Archi
```

### Method 3: Build from Source

For developers or those who want to build from source:

See [BUILD_GUIDE.md](BUILD_GUIDE.md) for complete build instructions.

```bash
# Clone repository
git clone <repository-url>
cd archi-auto-label-config

# Build
bash scripts/build_final.sh /path/to/archi

# Install
cp -r final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/
```

## Verification

### Check Installation

After restarting Archi:

1. **Check Menu**:
   - Open Archi
   - Look for **Tools → Manage Default Labels**

2. **Open Dialog**:
   - Click **Tools → Manage Default Labels**
   - A table with all ArchiMate element types should appear

3. **Test Functionality**:
   - Configure a default label (e.g., for "Business Actor": `${name}`)
   - Create a new Business Actor in a diagram
   - The label should be automatically applied

### Check Logs

If the plugin doesn't appear:

1. Open Archi logs:
   - **Help → Show Log** (or **Help → Error Log**)

2. Look for messages containing:
   - `defaultlabel`
   - `com.vhsystem.defaultlabel`

3. Common log messages:
   ```
   [DefaultLabel] Plugin starting...
   [LabelManager] Initializing LabelManager singleton...
   [LabelManager] LabelManager initialized successfully
   ```

### Command-Line Verification

Run Archi with console logging to see debug messages:

**Linux/Mac:**
```bash
/path/to/Archi/Archi -consoleLog
```

**Windows:**
```cmd
"C:\Program Files\Archi\Archi.exe" -consoleLog
```

## Plugin Directory Structure

After installation, the structure should be:

```
~/.archi/dropins/com.vhsystem.defaultlabel_1.0.0.qualifier/
├── META-INF/
│   └── MANIFEST.MF
├── plugin.xml
├── build.properties
└── com/
    └── vhsystem/
        └── defaultlabel/
            ├── DefaultLabelPlugin.class
            ├── LabelManager.class
            ├── StartupHandler.class
            ├── dialogs/
            │   ├── ManageLabelsDialog.class
            │   ├── ManageLabelsDialog$1.class
            │   ├── ManageLabelsDialog$2.class
            │   ├── ManageLabelsDialog$3.class
            │   ├── ManageLabelsDialog$4.class
            │   └── ManageLabelsDialog$LabelEntry.class
            └── handlers/
                └── ManageLabelsHandler.class
```

## Troubleshooting

### Plugin Not Appearing in Menu

**Possible Causes:**
1. Plugin not in correct location
2. Archi not fully restarted
3. Plugin activation failed

**Solutions:**

1. **Verify Location:**
   ```bash
   # Linux/Mac
   ls -la ~/.archi/dropins/
   
   # Should show the plugin JAR or folder
   ```

2. **Complete Restart:**
   - Close ALL Archi windows
   - Wait a few seconds
   - Restart Archi

3. **Clear OSGi Cache:**
   ```bash
   # Linux/Mac
   rm -rf ~/.archi/configuration/org.eclipse.osgi/
   
   # Windows
   del /s /q %USERPROFILE%\.archi\configuration\org.eclipse.osgi\
   ```
   Then restart Archi

4. **Check Permissions:**
   ```bash
   # Linux/Mac - ensure plugin is readable
   chmod -R 755 ~/.archi/dropins/com.vhsystem.defaultlabel*
   ```

### Dialog Doesn't Open

**Error Message:** "An error occurred while executing this command"

**Solutions:**

1. Check logs (**Help → Show Log**)
2. Verify all plugin files are present
3. Ensure Java 11+ is being used by Archi
4. Try reinstalling the plugin

### Labels Not Applied Automatically

**Possible Causes:**
1. No default label configured for that element type
2. Element already has a name/label
3. Plugin listener not active

**Solutions:**

1. **Configure Default Labels:**
   - Open **Tools → Manage Default Labels**
   - Set a label for the element type you're creating
   - Click **OK**

2. **Test with Empty Element:**
   - Create a new element WITHOUT typing a name first
   - The plugin only applies labels to elements without existing names

3. **Trigger Plugin Initialization:**
   - Open **Tools → Manage Default Labels** once
   - This ensures the plugin is fully initialized

### Java Version Issues

**Error:** "Unsupported class file major version"

**Solution:** Update Java version
```bash
# Linux
java -version  # Should be 11 or higher

# Update if needed (Ubuntu/Debian)
sudo apt install openjdk-11-jre

# Set Archi to use correct Java
export PATH=/usr/lib/jvm/java-11-openjdk/bin:$PATH
/path/to/Archi
```

## Uninstallation

To remove the plugin:

1. **Close Archi**

2. **Delete Plugin:**
   ```bash
   # Linux/Mac
   rm -rf ~/.archi/dropins/com.vhsystem.defaultlabel*
   
   # Windows
   del /s /q %USERPROFILE%\.archi\dropins\com.vhsystem.defaultlabel*
   ```

3. **Clear Configuration (optional):**
   ```bash
   # Linux/Mac
   rm ~/.archi/.metadata/.plugins/com.vhsystem.defaultlabel.prefs
   
   # Windows
   del %USERPROFILE%\.archi\.metadata\.plugins\com.vhsystem.defaultlabel.prefs
   ```

4. **Restart Archi**

## Configuration

### Default Labels Location

Plugin settings are stored in:

**Linux/Mac:**
```
~/.archi/configuration/.settings/com.vhsystem.defaultlabel.prefs
```

**Windows:**
```
%USERPROFILE%\.archi\configuration\.settings\com.vhsystem.defaultlabel.prefs
```

### Backup Configuration

To backup your label configurations:

```bash
# Linux/Mac
cp ~/.archi/configuration/.settings/com.vhsystem.defaultlabel.prefs ~/backup/

# Windows
copy %USERPROFILE%\.archi\configuration\.settings\com.vhsystem.defaultlabel.prefs C:\backup\
```

### Restore Configuration

```bash
# Linux/Mac
cp ~/backup/com.vhsystem.defaultlabel.prefs ~/.archi/configuration/.settings/

# Windows
copy C:\backup\com.vhsystem.defaultlabel.prefs %USERPROFILE%\.archi\configuration\.settings\
```

## Multiple Archi Installations

If you have multiple Archi installations:

1. Install plugin in each Archi's dropins folder
2. Or use a shared plugin location (advanced):
   ```bash
   # Add to Archi.ini:
   -Dosgi.sharedConfiguration.area=/shared/archi/dropins
   ```

## Network Installation

For enterprise deployments:

1. Build or obtain the plugin JAR
2. Distribute via network share or package manager
3. Use deployment script:
   ```bash
   #!/bin/bash
   PLUGIN_JAR="com.vhsystem.defaultlabel_1.0.0.qualifier.jar"
   DROPINS="$HOME/.archi/dropins"
   
   mkdir -p "$DROPINS"
   cp "$PLUGIN_JAR" "$DROPINS/"
   echo "Plugin installed. Restart Archi."
   ```

## Next Steps

After installation:

1. See [QUICK_START.md](QUICK_START.md) for usage guide
2. See [../README.md](../README.md) for features overview
3. Configure your default labels via **Tools → Manage Default Labels**

## Support

For installation issues:
- Check [BUILD_GUIDE.md](BUILD_GUIDE.md) for build problems
- Review Archi documentation for plugin installation
- Check logs in **Help → Show Log**
