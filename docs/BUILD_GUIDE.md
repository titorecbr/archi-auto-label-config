# Build Guide - Default Label Plugin for Archi

This guide explains how to build the Archi Default Label plugin from source.

## Prerequisites

- **Eclipse IDE** for RCP and RAP Developers (or similar)
- **Archi** installation (to obtain dependencies)
- **Java JDK** 11 or higher
- **Git** (optional, for cloning the repository)

## Quick Build (Using Script)

The easiest way to build the plugin is using the provided build script:

```bash
# Navigate to project directory
cd archi-auto-label-config

# Run build script (provide path to your Archi installation)
bash scripts/build_final.sh /path/to/archi

# The compiled plugin will be in:
# final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/
```

The script will:
1. Locate Archi dependencies automatically
2. Compile all Java source files
3. Create the proper plugin structure
4. Copy all necessary files
5. Generate the JAR file

## Manual Build (Eclipse IDE)

### Step 1: Import Project

1. Open Eclipse IDE
2. Go to **File → Import → Existing Projects into Workspace**
3. Select the plugin folder: `/path/to/archi-auto-label-config`
4. Optionally check "Copy projects into workspace"
5. Click **Finish**

### Step 2: Configure Dependencies

The plugin requires Archi libraries to compile:

1. Right-click on project → **Properties**
2. Go to **Java Build Path → Libraries**
3. Click **Add External JARs...**
4. Navigate to Archi's plugins folder (see below for locations)
5. Add these JARs:
   - `com.archimatetool.model_*.jar`
   - `com.archimatetool.editor_*.jar`
6. Click **Apply and Close**

#### Finding Archi Dependencies

**Linux:**
```bash
~/.archi/plugins/
/opt/archi/plugins/
/usr/share/archi/plugins/
```

**Windows:**
```
C:\Program Files\Archi\plugins\
C:\Users\<username>\.archi\plugins\
```

**macOS:**
```
/Applications/Archi.app/Contents/Eclipse/plugins/
~/Library/Application Support/Archi/plugins/
```

**Find automatically (Linux/macOS):**
```bash
find ~ -name "com.archimatetool.model_*.jar" 2>/dev/null | head -1
```

### Step 3: Compile

1. Go to **Project → Clean**
2. Select **Clean all projects**
3. Check **Start a build immediately**
4. Click **OK**
5. Verify no errors in the **Problems** tab

### Step 4: Export Plugin

1. Go to **File → Export**
2. Select **Plug-in Development → Deployable plug-ins and fragments**
3. Select the project: `com.vhsystem.defaultlabel`
4. Choose **Directory** as destination
5. Click **Browse** and select output folder (e.g., `~/archi-plugin-export`)
6. Check **Use class files compiled in the workspace**
7. Click **Finish**

### Step 5: Locate Built Plugin

After export, you'll find:

```
archi-plugin-export/
└── plugins/
    └── com.vhsystem.defaultlabel_1.0.0.qualifier/
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
                    │   └── ManageLabelsDialog.class
                    └── handlers/
                        └── ManageLabelsHandler.class
```

## Installation

After building, install the plugin:

### Linux/Mac:
```bash
cp -r plugins/com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/
```

### Windows:
```cmd
xcopy plugins\com.vhsystem.defaultlabel_1.0.0.qualifier %USERPROFILE%\.archi\dropins\ /E /I
```

Then restart Archi.

## Verification

After installation:

1. Open Archi
2. Check for **Tools → Manage Default Labels** menu
3. Open the dialog to verify it works
4. Create a test element to verify automatic label application

## Troubleshooting

### Compilation Errors

**Error: Cannot resolve com.archimatetool.***
- **Solution:** Add Archi JARs to Build Path (Step 2)

**Error: Class file has wrong version**
- **Solution:** Ensure you're using Java 11 or higher

### Export Issues

**Error: Plugin export fails**
- **Solution:** Clean and rebuild the project first

**Missing classes in export**
- **Solution:** Verify `build.properties` includes all necessary folders

### Installation Issues

**Plugin doesn't appear in menu**
- Verify files were copied to correct location
- Check Archi logs: **Help → Show Log**
- Ensure Archi was completely restarted

## Build Structure

The project structure:

```
archi-auto-label-config/
├── src/                          # Java source files
│   └── com/vhsystem/defaultlabel/
│       ├── DefaultLabelPlugin.java
│       ├── LabelManager.java
│       ├── StartupHandler.java
│       ├── dialogs/
│       │   └── ManageLabelsDialog.java
│       └── handlers/
│           └── ManageLabelsHandler.java
├── META-INF/
│   └── MANIFEST.MF              # OSGi manifest
├── plugin.xml                   # Extension points configuration
├── build.properties             # Build configuration
├── scripts/
│   ├── build_final.sh          # Automated build script
│   └── ...                     # Other utility scripts
├── final-plugin/               # Build output directory
└── docs/                       # Documentation
```

## Advanced Building

### Custom Build Location

To specify a custom build output directory:

```bash
bash scripts/build_final.sh /path/to/archi /custom/output/dir
```

### Clean Build

To perform a clean build:

```bash
# Remove previous builds
rm -rf final-plugin/

# Rebuild
bash scripts/build_final.sh /path/to/archi
```

### Building JAR Only

To create only the JAR file:

```bash
cd final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier
jar cvf ../com.vhsystem.defaultlabel_1.0.0.qualifier.jar *
```

## Development Tips

### Live Testing

During development, you can:
1. Build the plugin
2. Copy to Archi's dropins folder
3. Restart Archi with console to see debug messages:
   ```bash
   /path/to/Archi -consoleLog
   ```

### Debug Messages

The plugin outputs debug messages prefixed with:
- `[DefaultLabel]` - Main plugin messages
- `[LabelManager]` - Label management messages
- `[ManageLabelsDialog]` - Dialog and bulk update messages

### Hot Reload

Archi doesn't support hot reload of plugins. You must:
1. Close Archi completely
2. Replace plugin files
3. Restart Archi

## Next Steps

- See [INSTALL.md](INSTALL.md) for installation instructions
- See [QUICK_START.md](QUICK_START.md) for usage guide
- See [DISTRIBUTION_GUIDE.md](DISTRIBUTION_GUIDE.md) for distribution info

## Support

For build issues or questions:
- Check the [main README](../README.md)
- Review Archi plugin development documentation
- Check Eclipse PDE documentation

