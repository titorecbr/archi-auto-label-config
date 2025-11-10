# Distribution Guide - Default Label Plugin for Archi

## 🌍 Ready for Worldwide Distribution!

This plugin has been fully internationalized in English and is ready for distribution to the global Archi community.

## 📦 Package Contents

The distribution package includes:

```
archi-auto-label-config/
├── final-plugin/
│   └── com.vhsystem.defaultlabel_1.0.0.qualifier.jar  ⭐ MAIN PLUGIN FILE
├── README_EN.md                                       📖 English Documentation
├── TRANSLATION_SUMMARY.md                             📝 Translation Details
├── DISTRIBUTION_GUIDE.md                              📦 This file
└── src/                                               💻 Source code (for developers)
```

## 🚀 Quick Start for End Users

### Installation (3 steps)

1. **Download** the plugin JAR file:
   ```
   com.vhsystem.defaultlabel_1.0.0.qualifier.jar (21KB)
   ```

2. **Copy** to Archi's dropins folder:
   - **Linux/Mac**: `~/.archi/dropins/`
   - **Windows**: `%USERPROFILE%\.archi\dropins\`

3. **Restart** Archi completely

### Verification

After restart, you should see:
- A new menu called **"Default Labels"** in the menu bar
- Menu item: **"Manage Default Labels"**

## 📝 Features Summary

- ✅ **Automatic Label Application**: Applies default labels when creating elements
- ✅ **73 Pre-configured Element Types**: All ArchiMate 3.x layers covered
- ✅ **Easy Configuration**: Simple dialog to customize labels
- ✅ **Persistent Settings**: Configuration saved between sessions
- ✅ **Label Expression Support**: `${name}`, `${specialization}`, `${type}`, etc.

## 🌐 Distribution Channels

### Recommended Platforms

1. **Archi Plugin Repository** (if available)
   - Submit to official Archi plugin catalog

2. **GitHub Release**
   - Create GitHub repository
   - Tag release as v1.0.0
   - Attach JAR file
   - Include README_EN.md

3. **Archi Forum**
   - Post in "Plugins & Customisation" section
   - Include screenshots and usage examples
   - Link to GitHub repository

4. **OpenGroup ArchiMate Community**
   - Share in relevant discussion forums
   - Demonstrate use cases

### Package for GitHub Release

Create a release package:

```bash
cd "final-plugin"
zip -r default-label-plugin-v1.0.0.zip \
  com.vhsystem.defaultlabel_1.0.0.qualifier.jar \
  ../README_EN.md \
  ../TRANSLATION_SUMMARY.md
```

## 📸 Screenshots for Distribution

### 1. Menu Location
```
Archi Menu Bar → Default Labels → Manage Default Labels
```

### 2. Configuration Dialog
The dialog shows:
- List of all 73 ArchiMate element types
- Current default label for each type
- Easy editing by double-clicking cells
- Automatic save

### 3. Usage Example
When user creates a new "Business Actor":
- Element appears on diagram
- Label automatically set to: `<<${specialization}>> ${name}`
- User can still customize afterwards

## 📄 Required Documentation

Include these files in distribution:

1. **README.md** - Complete user documentation
2. **docs/** - All documentation files
3. **JAR file** - The plugin itself

## 🔧 For Developers

### Building from Source

```bash
# Clone repository
git clone <repository-url>
cd archi-auto-label-config

# Build
bash scripts/build_final.sh /path/to/archi

# JAR will be in: final-plugin/
```

### Source Code

All source code is in `src/` folder:
- Fully commented in English
- Clean architecture (Singleton pattern)
- Well-structured for maintenance

## 📊 Technical Specifications

- **Plugin ID**: `com.vhsystem.defaultlabel`
- **Version**: 1.0.0
- **Size**: 21KB
- **Requirements**: 
  - Archi 4.x or 5.x
  - Java 11+
- **Language**: English (fully internationalized)
- **Architecture**: Self-initializing Singleton
- **Element Types**: 73 (all ArchiMate 3.x layers)

## 🎯 Target Audience

- Enterprise Architects
- Solution Architects
- System Architects
- ArchiMate practitioners
- Modeling teams working with Archi

## 💡 Use Cases

1. **Standardize Label Formats**: Ensure all team members use consistent labeling
2. **Automate Documentation**: Automatically include type and specialization in labels
3. **Improve Diagram Readability**: Consistent label expressions across models
4. **Template-based Modeling**: Pre-configured labels for faster modeling

## 📞 Support & Community

### For Issues
- GitHub Issues (recommended)
- Archi Forum

### For Questions
- Archi Forum "Plugins & Customisation"
- ArchiMate Community discussions

### For Contributions
- Pull requests welcome on GitHub
- Follow existing code style
- Add tests if possible

## 📜 License

Free to use with Archi. Attribution appreciated.

## 🏷️ Release Notes v1.0.0

**Initial Release** - November 2024

- Automatic default label application
- Configuration dialog for all element types
- Support for 73 ArchiMate element types
- Persistent configuration storage
- Self-initializing architecture
- Fully internationalized in English
- Production-ready and stable

## 🎉 Ready to Distribute!

This plugin is:
- ✅ Fully translated to English
- ✅ Thoroughly tested
- ✅ Well documented
- ✅ Production ready
- ✅ Ready for worldwide use

**Download**: `com.vhsystem.defaultlabel_1.0.0.qualifier.jar`

**Size**: 21KB

**Install**: Copy to `~/.archi/dropins/` and restart Archi

**Enjoy!** 🚀

