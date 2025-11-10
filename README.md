# Archi Default Label Plugin

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Archi](https://img.shields.io/badge/Archi-5.6+-green.svg)](https://www.archimatetool.com/)
[![Java](https://img.shields.io/badge/Java-21+-orange.svg)](https://www.oracle.com/java/)

An Archi plugin that automatically applies configurable label expressions to ArchiMate elements when they are created in diagrams.

## 🎯 Purpose

When working with large ArchiMate models in Archi, you often want elements to display specific information using label expressions (like `${name}`, `${type}`, or `${specialization}`). Normally, you have to manually set these expressions for each element after creation.

**This plugin automates that process** by allowing you to configure default label expressions for each ArchiMate element type. When you create a new element in a diagram, the plugin automatically applies the appropriate label expression based on the element type.

## ✨ Features

- **🔄 Automatic Label Application**: Automatically applies pre-configured label expressions when new elements are added to diagrams
- **⚙️ Configurable per Element Type**: Set different default labels for all 73 ArchiMate 3.x element types
- **🎨 User-Friendly Interface**: Easy-to-use dialog for managing default labels
- **💾 Persistent Configuration**: Settings are automatically saved and persist between Archi sessions
- **🚀 Startup Initialization**: Plugin activates automatically when Archi starts
- **🌍 Internationalized**: Full English support for worldwide usage

## 📦 Installation

### Option 1: Quick Install (Recommended)

1. Download the latest release: `com.vhsystem.defaultlabel_1.0.0.qualifier.jar`
2. Copy the file to Archi's dropins folder:
   - **Linux/Mac**: `~/.archi/dropins/`
   - **Windows**: `%USERPROFILE%\.archi\dropins\`
3. Restart Archi
4. Verify the plugin is installed by checking **Tools → Manage Default Labels**

### Option 2: Build from Source

```bash
# Clone the repository
git clone <repository-url>
cd archi-auto-label-config

# Build the plugin (requires Archi installation)
bash scripts/build_final.sh /path/to/archi

# Install
cp -r final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/

# Restart Archi
```

## 🚀 Usage

### Configuring Default Labels

1. Open Archi
2. Go to **Tools → Manage Default Labels**
3. A dialog displays all ArchiMate element types with their current default labels
4. **Double-click** any "Default Label" cell to edit
5. Enter your label expression using Archi's syntax
6. Click outside the cell to save
7. Click **OK** to close the dialog

### Supported Label Expression Variables

The plugin supports all of Archi's label expression variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `${name}` | Element name | "Customer Service" |
| `${type}` | Element type | "BusinessProcess" |
| `${specialization}` | Element specialization | "Critical Process" |
| `${documentation}` | Element documentation | First line of docs |
| `${property:key}` | Custom property value | `${property:Status}` |

### Example Configurations

**Display name and type:**
```
${name} (${type})
```

**Display specialization when available:**
```
${name}${specialization: (}${specialization}${specialization:)}
```

**Show custom property:**
```
${name} - ${property:Status}
```

### How It Works

1. You configure default labels for element types (e.g., BusinessActor → `${name}`)
2. When you drag a BusinessActor onto a diagram, the plugin detects the creation
3. The plugin automatically sets the element's label expression to `${name}`
4. The element immediately displays according to your configured expression

## 🏗️ Supported ArchiMate Elements

The plugin supports all **73 ArchiMate 3.x element types** across all layers:

- **Strategy Layer** (6 elements): Resource, Capability, CourseOfAction, ValueStream
- **Business Layer** (13 elements): BusinessActor, BusinessRole, BusinessProcess, BusinessService, etc.
- **Application Layer** (8 elements): ApplicationComponent, ApplicationFunction, ApplicationService, etc.
- **Technology Layer** (10 elements): Node, Device, SystemSoftware, TechnologyService, etc.
- **Physical Layer** (4 elements): Equipment, Facility, DistributionNetwork, Material
- **Motivation Layer** (10 elements): Stakeholder, Driver, Goal, Outcome, Principle, Requirement, etc.
- **Implementation & Migration Layer** (6 elements): WorkPackage, Deliverable, Plateau, Gap
- **Other Elements** (16 elements): Location, Grouping, Junction, AndJunction, OrJunction, etc.

## 🔧 Technical Details

### Architecture

- **Plugin Type**: Eclipse/OSGi plugin for Archi
- **Activation**: Uses `org.eclipse.ui.startup` extension point for early initialization
- **Pattern**: Singleton pattern with static initialization for reliability
- **Event Handling**: Listens to `IEditorModelManager.PROPERTY_ECORE_EVENT` for element creation
- **Storage**: Preferences stored in Archi's plugin preferences system

### Key Components

```
src/com/vhsystem/defaultlabel/
├── DefaultLabelPlugin.java        # Main plugin activator
├── LabelManager.java              # Core logic (singleton)
├── StartupHandler.java            # Early startup initialization
├── dialogs/
│   └── ManageLabelsDialog.java    # Configuration UI
└── handlers/
    └── ManageLabelsHandler.java   # Menu command handler
```

### Requirements

- **Archi**: Version 5.6 or later
- **Java**: Version 21 or later
- **OSGi**: Compatible with Eclipse OSGi framework

## 🛠️ Development

### Project Structure

```
archi-auto-label-config/
├── src/                          # Source code
├── scripts/
│   ├── build_final.sh           # Build script
│   └── ...
├── final-plugin/                # Compiled plugin output
├── META-INF/
│   └── MANIFEST.MF              # OSGi manifest
├── plugin.xml                   # Plugin extension points
└── README.md                    # This file
```

### Building

```bash
# Build the plugin
bash scripts/build_final.sh /path/to/archi

# Output will be in: final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/
```

### Debugging

To see plugin debug messages:

```bash
# Run Archi from terminal
/path/to/Archi/Archi

# Look for messages starting with:
# [DefaultLabel]
# [LabelManager]
```

## 📝 Configuration Files

### Default Labels Storage

Labels are stored in Archi's plugin preferences:
- **Linux/Mac**: `~/.archi/config/org.eclipse.core.runtime/.settings/`
- **Windows**: `%USERPROFILE%\.archi\config\org.eclipse.core.runtime\.settings\`

File: `com.vhsystem.defaultlabel.prefs`

### Menu Integration

The plugin adds a menu item to Archi's Tools menu using the standard Eclipse menu ID:

```xml
<menuContribution locationURI="menu:tools?after=additions">
  <command label="Manage Default Labels" .../>
</menuContribution>
```

## 🐛 Troubleshooting

### Plugin not appearing in Tools menu

1. Verify the plugin file is in the dropins folder
2. Restart Archi completely
3. Check console output for errors:
   ```bash
   /path/to/Archi/Archi -consoleLog
   ```

### Labels not being applied automatically

1. Open **Tools → Manage Default Labels** to trigger initialization
2. Check that you've configured a label for the element type
3. Verify the element is being added to a **diagram** (not just the model tree)

### Plugin not loading on startup

1. Clear OSGi cache:
   ```bash
   rm -rf ~/.archi/config/org.eclipse.osgi/*
   ```
2. Restart Archi

### Still having issues?

Check the console output for messages starting with `[DefaultLabel]` or `[LabelManager]` for diagnostic information.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

### Development Setup

1. Clone the repository
2. Import into Eclipse IDE with PDE (Plugin Development Environment)
3. Set target platform to your Archi installation
4. Make your changes
5. Test with `bash scripts/build_final.sh`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**VH System**

## 🙏 Acknowledgments

- Built for [Archi - ArchiMate Modelling Tool](https://www.archimatetool.com/)
- Uses the [ArchiMate® 3.x specification](https://www.opengroup.org/archimate-forum/archimate-overview)

## 📚 Additional Documentation

- [TRANSLATION_SUMMARY.md](TRANSLATION_SUMMARY.md) - Translation details
- [DISTRIBUTION_GUIDE.md](DISTRIBUTION_GUIDE.md) - Distribution instructions
- [MENU_FIX.md](MENU_FIX.md) - Menu integration technical details
- [README_EN.md](README_EN.md) - Extended English documentation

## 🔄 Version History

### Version 1.0.0
- Initial release
- Support for all 73 ArchiMate 3.x element types
- Automatic label application on element creation
- User-friendly configuration dialog
- Persistent settings
- Full English internationalization
- Integration with Tools menu

---

**Made with ❤️ for the Archi community**
