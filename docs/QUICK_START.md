# Quick Start Guide - Default Label Plugin

Get started with the Archi Default Label plugin in 5 minutes!

## ⚡ Installation (2 minutes)

1. **Download** the plugin JAR:
   - `com.vhsystem.defaultlabel_1.0.0.qualifier.jar`

2. **Copy** to Archi's dropins folder:
   ```bash
   # Linux/Mac
   cp com.vhsystem.defaultlabel_1.0.0.qualifier.jar ~/.archi/dropins/
   
   # Windows
   copy com.vhsystem.defaultlabel_1.0.0.qualifier.jar %USERPROFILE%\.archi\dropins\
   ```

3. **Restart** Archi completely

## 🎯 First Use (3 minutes)

### Step 1: Open Configuration Dialog

1. Launch Archi
2. Go to **Tools → Manage Default Labels**
3. A table will show all ArchiMate element types

### Step 2: Configure a Simple Label

Let's configure Business Actor:

1. Find **"Business Actor"** in the table
2. **Double-click** the "Default Label" cell
3. Type: `${name}`
4. Press **Enter** or click outside the cell
5. Click **OK** to close

### Step 3: Test It!

1. Create a new ArchiMate view
2. Drag a **Business Actor** onto the diagram
3. Type a name (e.g., "Customer")
4. Notice: The label automatically displays the name!

## 📋 Common Label Patterns

Try these popular label expressions:

### Simple Name Only
```
${name}
```
Shows just the element name.

### Name with Specialization
```
<<${specialization}>>
${name}
```
Shows specialization above the name (if defined).

### Name and Type
```
${name}
(${type})
```
Shows name with type in parentheses.

### Full Information
```
<<${specialization}>>
${name}
${documentation}
```
Shows specialization, name, and first line of documentation.

## 🚀 Quick Configuration Examples

### For Application Components
```
<<API>>
${name}
```
Result: Shows "<<API>>" above component name.

### For Business Processes
```
${name}
[${property:Status}]
```
Result: Shows name with Status property in brackets.

### For Services
```
${name}
→ ${specialization}
```
Result: Shows name with arrow pointing to specialization.

## ⚙️ Advanced: Bulk Update Feature

The plugin can update ALL existing elements when you change configurations!

### How It Works:

1. Open **Tools → Manage Default Labels**
2. Modify any label configuration
3. Click **OK**
4. Dialog asks: *"Labels have been modified. Update all existing elements?"*
5. Click **Yes** to update everything, or **No** to only affect new elements

### Example Bulk Update:

**Scenario:** You have 50 Application Components showing `${name}`, but want them to show `<<${specialization}>>\n${name}`

1. Open **Tools → Manage Default Labels**
2. Find **"Application Component"**
3. Change label to: `<<${specialization}>>\n${name}`
4. Click **OK**
5. Click **Yes** when prompted
6. Result: All 50 components updated instantly! ✨

## 📊 Supported Element Types

The plugin supports all **73 ArchiMate 3.x element types**:

| Layer | Examples |
|-------|----------|
| **Business** | Business Actor, Business Process, Business Service |
| **Application** | Application Component, Application Function, Data Object |
| **Technology** | Node, Device, System Software, Technology Service |
| **Physical** | Equipment, Facility, Distribution Network, Material |
| **Strategy** | Resource, Capability, Course of Action, Value Stream |
| **Motivation** | Stakeholder, Goal, Requirement, Principle |
| **Implementation** | Work Package, Deliverable, Implementation Event, Plateau |
| **Other** | Location, Grouping, Junction |

## 🎨 Label Expression Variables

All Archi label expression variables are supported:

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `${name}` | Element name | "Customer Service" |
| `${type}` | Element type | "BusinessProcess" |
| `${specialization}` | Specialization | "Critical" |
| `${documentation}` | First line of docs | "Main customer process" |
| `${property:key}` | Custom property | `${property:Owner}` → "John" |

### Conditional Display:

```
${name}${specialization: (}${specialization}${specialization:)}
```
Shows: "Process Name (Specialization)" only if specialization exists.

## ✅ Verification Checklist

- [ ] Plugin JAR copied to dropins folder
- [ ] Archi restarted completely
- [ ] **Tools → Manage Default Labels** menu appears
- [ ] Dialog opens and shows element types table
- [ ] Can edit label cells by double-clicking
- [ ] Created test element shows configured label
- [ ] Bulk update prompt appears when changing labels

## 🐛 Quick Troubleshooting

### Plugin Not Appearing?

```bash
# Check if file is in correct location
ls ~/.archi/dropins/

# Clear cache and restart
rm -rf ~/.archi/configuration/org.eclipse.osgi/
# Then restart Archi
```

### Labels Not Applying?

1. Open **Tools → Manage Default Labels** once (initializes plugin)
2. Configure a label for the element type you're testing
3. Create element WITHOUT pre-typing a name
4. Plugin only applies to elements created without initial names

### Dialog Won't Open?

- Check **Help → Show Log** for errors
- Verify Java version: `java -version` (needs 11+)
- Reinstall plugin

## 🎯 Next Steps

Now that you're set up:

1. **Configure your team's standard labels**
   - Define consistent label patterns
   - Share configurations across team

2. **Use bulk update to standardize existing models**
   - Update all elements in your current models
   - Maintain consistency across projects

3. **Explore advanced label expressions**
   - Conditional display
   - Custom properties
   - Multi-line labels

## 📚 More Information

- [Full README](../README.md) - Complete feature documentation
- [INSTALL.md](INSTALL.md) - Detailed installation guide
- [BUILD_GUIDE.md](BUILD_GUIDE.md) - Build from source
- [BULK_UPDATE_FEATURE.md](BULK_UPDATE_FEATURE.md) - Bulk update details
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [CHANGELOG.md](CHANGELOG.md) - Version history

## 💡 Tips

1. **Start Simple**: Begin with just `${name}` for most elements
2. **Standardize Gradually**: Add specialization and properties over time
3. **Use Bulk Update**: When you change your mind, update everything at once
4. **Test First**: Try configurations on one element type before applying broadly
5. **Backup Models**: Before bulk updates, save your work!

## 🎉 You're Ready!

The plugin is now active and will automatically apply your configured labels to all new elements you create.

Happy modeling! 🚀
