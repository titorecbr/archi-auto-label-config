# Default Label Plugin for Archi

An Archi plugin that automatically applies configurable label expressions to ArchiMate elements when they are created.

## Features

- **Automatic Label Application**: When a new element is created, the plugin automatically applies the configured default label expression for that element type
- **Label Management Interface**: Graphical interface to configure and manage default labels for all ArchiMate element types
- **Persistent Configuration**: Settings are automatically saved and persist between Archi sessions
- **Support for all ArchiMate 3.x Elements**: Includes 73 element types across all layers (Application, Business, Technology, Physical, Strategy, Motivation, Implementation & Migration)

## Installation

### Quick Install

1. Download the plugin file (`com.vhsystem.defaultlabel_1.0.0.qualifier.jar`)
2. Copy to Archi's dropins folder:
   - **Linux/Mac**: `~/.archi/dropins/`
   - **Windows**: `%USERPROFILE%\.archi\dropins\`
3. Restart Archi
4. Verify "Manage Default Labels" appears in the Tools menu

### Manual Build

If you want to build from source:

```bash
cd archi-auto-label-config
bash scripts/build_final.sh /path/to/archi
```

## Usage

### Configuring Default Labels

1. Open Archi
2. Go to **Tools → Manage Default Labels** menu
3. A dialog will open showing all ArchiMate element types
4. Double-click on any "Default Label" cell to edit
5. Enter your label expression (supports variables like `${name}`, `${specialization}`)
6. Changes are saved automatically

### Label Expression Variables

The plugin supports Archi's label expression syntax:

- `${name}` - Element name
- `${specialization}` - Element specialization
- `${type}` - Element type
- `${documentation}` - Element documentation
- Custom properties: `${property:PropertyName}`

### Example Default Labels

```
<<${specialization}>>
${name}
```

This will display:
```
<<Web Application>>
Customer Portal
```

## Default Configuration

The plugin comes pre-configured with sensible defaults for all 73 ArchiMate element types:

- **Application Layer** (8 elements): Application Component, Collaboration, Interface, Function, Interaction, Process, Service, Event
- **Business Layer** (10 elements): Business Actor, Collaboration, Event, Function, Interaction, Interface, Object, Process, Role, Service
- **Technology Layer** (14 elements): Artifact, Device, Node, System Software, Technology Collaboration, Interface, etc.
- **Physical Layer** (5 elements): Equipment, Facility, Distribution Network, Material, etc.
- **Strategy Layer** (5 elements): Resource, Capability, Course of Action, Value Stream, etc.
- **Motivation Layer** (11 elements): Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, etc.
- **Implementation & Migration Layer** (5 elements): Work Package, Deliverable, Implementation Event, Plateau, Gap
- **Other Elements** (3 elements): Junction, Grouping, Location, etc.

## Technical Details

- **Plugin ID**: `com.vhsystem.defaultlabel`
- **Version**: 1.0.0
- **Requirements**: 
  - Archi 4.x or 5.x
  - Java 11+
- **Architecture**: Self-initializing singleton pattern for automatic startup
- **Configuration File**: `~/.archi/.metadata/.plugins/org.eclipse.core.runtime/.settings/default_labels.properties`

## How It Works

1. The `LabelManager` singleton automatically initializes when Archi starts
2. It loads 73 pre-configured default labels for all ArchiMate element types
3. It registers a model listener to detect when new elements are added to diagrams
4. When a diagram object is created, it automatically applies the configured label expression
5. Users can customize labels through the management dialog at any time

## Troubleshooting

### Plugin doesn't appear in menu

- Check if plugin is in `~/.archi/dropins/`
- Verify Archi was completely restarted
- Look for "Manage Default Labels" in the Tools menu
- Check Archi logs for errors

### Labels not applying automatically

- Open **Tools → Manage Default Labels** to trigger initialization
- Verify default labels are configured for the element types you're using
- Check console output for `[LabelManager]` messages

### Custom labels not persisting

- Ensure Archi has write permissions to its configuration directory
- Check if `default_labels.properties` file exists in Archi's config folder

## Development

### Project Structure

```
archi-auto-label-config/
├── src/
│   └── com/vhsystem/defaultlabel/
│       ├── DefaultLabelPlugin.java       # Main plugin class
│       ├── LabelManager.java             # Label management singleton
│       ├── StartupHandler.java           # Startup initializer
│       ├── handlers/
│       │   └── ManageLabelsHandler.java  # Menu command handler
│       └── dialogs/
│           └── ManageLabelsDialog.java   # Configuration UI
├── META-INF/
│   └── MANIFEST.MF                       # OSGi bundle manifest
├── plugin.xml                            # Eclipse plugin configuration
└── build.properties                      # Build configuration
```

### Building

Requirements:
- Eclipse IDE for RCP and RAP Developers
- Archi SDK or Archi installation with model/editor JARs

Build script:
```bash
bash scripts/build_final.sh /path/to/archi
```

## License

This plugin is provided as-is for free use with Archi.

## Author

VH System - Victor Hugo
- Project: archi-auto-label-config
- Version: 1.0.0

## Changelog

### 1.0.0 (Initial Release)
- Automatic label expression application on element creation
- Configuration dialog for all 73 ArchiMate element types
- Persistent configuration storage
- Self-initializing singleton architecture
- Support for all ArchiMate 3.x layers
- Fully internationalized in English

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For questions, issues, or feature requests, please open an issue on the project repository.

