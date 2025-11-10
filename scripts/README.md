# Build and Utility Scripts

Collection of shell scripts for building, installing, and managing the Archi Default Label Plugin.

## 🚀 Main Scripts

### Build Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `build_final.sh` | **Main build script** - Automated compilation | `bash scripts/build_final.sh /path/to/archi` |
| `build_archiplugin.sh` | Build .archiplugin format | `bash scripts/build_archiplugin.sh` |
| `compile_fix.sh` | Quick compilation with fixes | `bash scripts/compile_fix.sh` |

### Installation Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `install_plugin.sh` | Install compiled plugin to Archi | `bash scripts/install_plugin.sh` |
| `install.sh` | Alternative installation script | `bash scripts/install.sh` |

### Utility Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `find_archi.sh` | Locate Archi installation | `bash scripts/find_archi.sh` |
| `restart_archi.sh` | Restart Archi with plugin | `bash scripts/restart_archi.sh` |
| `check_plugin_logs.sh` | Check Archi logs for plugin messages | `bash scripts/check_plugin_logs.sh` |
| `verify_structure.sh` | Verify plugin structure | `bash scripts/verify_structure.sh` |

### Eclipse Build Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `compile_with_eclipse.sh` | Compile using Eclipse | `bash scripts/compile_with_eclipse.sh` |
| `setup_eclipse.sh` | Setup Eclipse environment | `bash scripts/setup_eclipse.sh` |

### Development Scripts (Legacy/Alternative)

| Script | Description | Notes |
|--------|-------------|-------|
| `build.sh` | Basic build script | Alternative to build_final.sh |
| `build_auto.sh` | Automated build | Development version |
| `build_complete.sh` | Complete build | Full build process |
| `build_headless.sh` | Headless build | For CI/CD |
| `compile_quick.sh` | Quick compile | Fast compilation |
| `create_archiplugin.sh` | Create archiplugin file | For distribution |
| `execute_compile.sh` | Execute compilation | Helper script |

## 📖 Detailed Usage

### Building the Plugin

**Recommended method:**

```bash
# Automated build (finds Archi automatically)
bash scripts/build_final.sh /path/to/archi

# Example:
bash scripts/build_final.sh ~/apps/Archi
bash scripts/build_final.sh /opt/Archi
```

**Output:** Compiled plugin in `final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier/`

### Installing the Plugin

After building:

```bash
# Install to Archi dropins
bash scripts/install_plugin.sh

# Or manually:
cp -r final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/
```

### Finding Archi Installation

If you don't know where Archi is installed:

```bash
bash scripts/find_archi.sh
```

This will search common locations and show you the path.

### Checking Logs

To see plugin messages and debug output:

```bash
bash scripts/check_plugin_logs.sh
```

Or view Archi console directly:

```bash
tail -f ~/.archi/configuration/*.log
```

### Restarting Archi

To quickly restart Archi after plugin changes:

```bash
bash scripts/restart_archi.sh
```

## 🔧 Script Requirements

### Prerequisites

- **bash** shell
- **Java** 11 or higher (for compilation)
- **Archi** installation
- **Standard Unix tools**: find, grep, sed, cp, mv

### Platform Support

- ✅ **Linux** - All scripts tested
- ✅ **macOS** - Compatible (minor path adjustments may be needed)
- ⚠️ **Windows** - Use WSL or Git Bash

## 📝 Common Workflows

### Initial Build

```bash
# 1. Find Archi
bash scripts/find_archi.sh

# 2. Build plugin
bash scripts/build_final.sh /path/to/archi

# 3. Install plugin
bash scripts/install_plugin.sh

# 4. Restart Archi
bash scripts/restart_archi.sh
```

### Development Cycle

```bash
# 1. Make code changes in src/

# 2. Quick recompile
bash scripts/compile_fix.sh

# 3. Reinstall
bash scripts/install_plugin.sh

# 4. Check logs
bash scripts/check_plugin_logs.sh
```

### Creating Distribution Package

```bash
# Build plugin
bash scripts/build_final.sh /path/to/archi

# Create .archiplugin file
bash scripts/build_archiplugin.sh

# Verify structure
bash scripts/verify_structure.sh
```

## 🐛 Troubleshooting

### Script Won't Run

```bash
# Make script executable
chmod +x scripts/script-name.sh

# Or run with bash
bash scripts/script-name.sh
```

### Can't Find Archi

```bash
# Use find_archi.sh to locate
bash scripts/find_archi.sh

# Or specify full path
bash scripts/build_final.sh /full/path/to/Archi
```

### Build Fails

```bash
# Check Java version
java -version  # Should be 11+

# Verify Archi path has plugins/
ls /path/to/archi/plugins/*.jar

# Check for required JARs
ls /path/to/archi/plugins/com.archimatetool.*.jar
```

### Plugin Not Installing

```bash
# Check dropins directory exists
mkdir -p ~/.archi/dropins

# Verify plugin structure
bash scripts/verify_structure.sh

# Check permissions
ls -la ~/.archi/dropins/
```

## 📚 Related Documentation

- [BUILD_GUIDE.md](../docs/BUILD_GUIDE.md) - Complete build instructions
- [INSTALL.md](../docs/INSTALL.md) - Installation guide
- [FIND_DEPENDENCIES.md](../docs/FIND_DEPENDENCIES.md) - Dependency locations
- [QUICK_START.md](../docs/QUICK_START.md) - Quick start guide

## ⚙️ Script Maintenance

### Adding New Scripts

1. Create script in `scripts/` directory
2. Make executable: `chmod +x scripts/new-script.sh`
3. Add entry to this README
4. Test on Linux and macOS if possible
5. Document any dependencies

### Best Practices

- Use `#!/bin/bash` shebang
- Add descriptive comments
- Include error handling
- Use absolute paths with `$HOME` or `$(pwd)`
- Test with shellcheck if available
- Follow existing naming conventions

## 📊 Script Statistics

- **Total scripts:** 18
- **Main build scripts:** 6
- **Utility scripts:** 5
- **Installation scripts:** 2
- **Development scripts:** 5
- **Languages:** Bash (shell)
- **Platform:** Linux/macOS (WSL for Windows)

## 💡 Tips

1. **Always use `bash scripts/`** prefix to run scripts
2. **Check logs** after building with `check_plugin_logs.sh`
3. **Use `find_archi.sh`** first if unsure about Archi location
4. **Restart Archi completely** after plugin installation
5. **Verify structure** with `verify_structure.sh` before distribution

---

Return to [Main README](../README.md) | [Build Guide](../docs/BUILD_GUIDE.md)

