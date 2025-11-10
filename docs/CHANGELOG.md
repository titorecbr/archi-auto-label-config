# Changelog

All notable changes to the Archi Default Label Plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-10

### Added
- ✨ Initial release of Default Label Plugin for Archi
- 🔄 Automatic label application when new elements are created
- ⚡ **Bulk update feature** to update all existing elements when configurations change
- ⚙️ Configuration dialog for all 73 ArchiMate 3.x element types
- 🎨 User-friendly table interface with inline editing (double-click to edit)
- 💾 Persistent configuration using Eclipse preferences API
- 🚀 Automatic startup initialization using startup extension point
- 🔍 Smart change detection that prompts for bulk updates
- 📊 Detailed logging and feedback for all operations
- 🌍 Full English internationalization
- 🛡️ Safe bulk updates with confirmation dialogs

### Features

#### Core Functionality
- Automatic detection of new element creation in diagrams
- Application of pre-configured label expressions based on element type
- Support for all Archi label expression variables (`${name}`, `${type}`, `${specialization}`, etc.)
- Integration with Tools menu via command contribution

#### Configuration Management
- Table-based configuration interface showing all element types
- Double-click editing for quick label updates
- Automatic save on dialog close
- Load/save from Eclipse preferences
- Configuration persists between Archi sessions

#### Bulk Update System
- Automatic detection of configuration changes
- Confirmation prompt before applying updates
- Processing of all models in current workspace
- Recursive element processing in diagrams
- Support for nested and grouped elements
- Detailed progress logging to console
- Summary message showing elements, diagrams, and models updated

#### Supported Elements
- **Application Layer** (8 types): Component, Collaboration, Interface, Function, Interaction, Process, Service, Event
- **Business Layer** (13 types): Actor, Collaboration, Event, Function, Interaction, Interface, Object, Process, Product, Representation, Role, Service
- **Technology Layer** (10 types): Artifact, Communication Network, Device, Node, Path, System Software, Technology Collaboration, Technology Function, Technology Interface, Technology Process, Technology Service, Technology Event
- **Physical Layer** (4 types): Equipment, Facility, Distribution Network, Material
- **Data Layer** (1 type): Data Object
- **Strategy Layer** (4 types): Resource, Capability, Course of Action, Value Stream
- **Motivation Layer** (10 types): Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, Constraint, Meaning, Value
- **Implementation & Migration Layer** (6 types): Work Package, Deliverable, Implementation Event, Plateau, Gap
- **Other Elements** (17 types): Location, Grouping, Junction, And Junction, Or Junction, Sketch Model, Sketch Model Actor, Sketch Model Sticky, Canvas Model, Canvas Model Block, Canvas Model Image, Canvas Model Sticky, Diagram Model Reference, Diagram Model Group

### Technical Details
- Implemented using Eclipse RCP plugin architecture
- Uses OSGi bundle system for modular design
- Singleton pattern for LabelManager ensures single initialization
- Event-driven architecture using IEditorModelManager listeners
- Preference-based configuration storage
- Early startup using org.eclipse.ui.startup extension point

### Documentation
- Comprehensive README with feature overview
- Quick Start guide (5-minute setup)
- Complete installation guide
- Build from source instructions
- Dependency location guide
- Eclipse export procedures
- Bulk update feature documentation
- Contributing guidelines
- MIT License

### Files Included
- `com.vhsystem.defaultlabel_1.0.0.qualifier.jar` - Plugin JAR (ready to install)
- Complete source code in `src/` directory
- Build scripts for automated compilation
- Comprehensive documentation in `docs/` directory
- Screenshot of plugin interface

### Requirements
- Archi 4.x or 5.x
- Java 11 or higher
- Eclipse IDE (for building from source)

### Installation
Simply copy JAR to `~/.archi/dropins/` and restart Archi.

### Known Issues
None at this time.

### Migration Notes
This is the initial release, no migration needed.

---

## [Unreleased]

### Planned Features
- Preview mode for bulk updates (see changes before applying)
- Export/import label configurations
- Templates for common label patterns
- Batch operations for multiple element types
- Label validation and syntax checking
- Custom label variable plugins
- Support for relationship labels
- Integration with Archi model exchange format

### Under Consideration
- Conditional label expressions (if/else logic)
- Label formatting options (font, color, size)
- Per-model configuration overrides
- Label history and undo beyond Archi's default
- Integration with Archi scripts
- REST API for programmatic configuration

---

## Version History Summary

- **1.0.0** (2024-11-10) - Initial release with automatic labels and bulk update

---

**Note:** This plugin follows semantic versioning:
- **Major** version for incompatible API changes
- **Minor** version for backwards-compatible new features
- **Patch** version for backwards-compatible bug fixes

For detailed information about each release, see the sections above.

