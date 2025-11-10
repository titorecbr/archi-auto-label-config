# Bulk Update Feature - Default Label Plugin

Complete documentation for the bulk label update functionality.

## Overview

The **Bulk Update Feature** allows you to automatically update labels for ALL existing elements in your ArchiMate models when you change label configurations. This ensures consistency across your entire model with a single click.

## How It Works

### Automatic Change Detection

When you modify label configurations and click **OK**, the plugin:

1. **Compares** current label values with original values
2. **Detects** which element types have been modified
3. **Prompts** you to update existing elements

### Confirmation Dialog

If changes are detected, you'll see a confirmation message:

```
Labels have been modified. Do you want to update all existing 
elements to match the new label configurations?

This will process ALL diagrams in ALL models currently open 
in your workspace, updating all diagram objects of the modified types.
```

**Options:**
- **Yes**: Updates all existing elements in all open models
- **No**: Saves configurations but only affects newly created elements

### Update Process

If you click **Yes**, the plugin:

1. Scans all models open in Archi workspace
2. Processes every diagram in each model
3. Recursively visits all elements in diagrams
4. Applies new labels to matching element types
5. Shows summary of updates performed

## Usage Examples

### Example 1: Simple Name Change

**Scenario:** Change all Business Actors from `${name}` to `${name} (Actor)`

**Steps:**
1. Open **Tools → Manage Default Labels**
2. Find **Business Actor**
3. Change label from `${name}` to `${name} (Actor)`
4. Click **OK**
5. Click **Yes** when prompted
6. All Business Actors in all diagrams updated instantly!

**Result:**
- "Customer" → "Customer (Actor)"
- "Manager" → "Manager (Actor)"
- "System Admin" → "System Admin (Actor)"

### Example 2: Adding Specialization

**Scenario:** Add specialization display to Application Components

**Before:** Components show only `${name}`

**After:** Components show `<<${specialization}>>\n${name}`

**Steps:**
1. Open **Tools → Manage Default Labels**
2. Find **Application Component**
3. Change to: `<<${specialization}>>\n${name}`
4. Click **OK**
5. Click **Yes** for bulk update

**Result:**
```
Before:              After:
Payment Service  →   <<API>>
                     Payment Service

Customer DB     →    <<PostgreSQL>>
                     Customer DB
```

### Example 3: Multiple Element Types

**Scenario:** Standardize all services to show type information

**Element Types to Update:**
- Business Service
- Application Service
- Technology Service

**New Label:** `${name}\n[${type}]`

**Steps:**
1. Open **Tools → Manage Default Labels**
2. Update all three service types with new label
3. Click **OK**
4. Click **Yes** to bulk update
5. All services in all models updated!

**Result:**
```
Customer Service
[BusinessService]

API Gateway
[ApplicationService]

Network Service
[TechnologyService]
```

## Technical Details

### Scope of Updates

The bulk update processes:

✅ **All models** open in current Archi workspace
✅ **All diagrams** within those models
✅ **All elements** in diagrams (including nested/grouped elements)
✅ **All element types** that were modified

❌ **Does NOT update:**
- Models not currently open in Archi
- Elements only in model tree (not placed in diagrams)
- Element types that weren't modified

### Recursive Processing

The plugin processes elements recursively, including:

- Top-level diagram elements
- Elements inside containers
- Nested elements in groups
- Elements in multiple levels of nesting

### Performance

- **Small models** (< 100 elements): Instant
- **Medium models** (100-500 elements): 1-2 seconds
- **Large models** (500-1000 elements): 3-5 seconds
- **Very large models** (1000+ elements): 5-10 seconds

### Logging

The plugin provides detailed console logs during bulk update:

```
[ManageLabelsDialog] Starting bulk update of all elements in workspace...
[ManageLabelsDialog] Found 2 model(s) in workspace
[ManageLabelsDialog] Processing model: Enterprise Architecture Model
[ManageLabelsDialog]   Found 8 diagram(s) in this model
[ManageLabelsDialog]   Processing diagram: Application Layer
[ManageLabelsDialog] ✓ Updated: ApplicationComponent - Payment Service
[ManageLabelsDialog] ✓ Updated: ApplicationComponent - Customer Portal
[ManageLabelsDialog]   Processing diagram: Business Layer
[ManageLabelsDialog] ✓ Updated: BusinessActor - Customer
[ManageLabelsDialog] ✓ Updated: BusinessProcess - Order Management
[ManageLabelsDialog]   Processing diagram: Technology Layer
[ManageLabelsDialog] Processing model: Infrastructure Model
[ManageLabelsDialog]   Found 3 diagram(s) in this model
[ManageLabelsDialog]   Processing diagram: Network Architecture
[ManageLabelsDialog] ✓ Updated: Node - Server01
[ManageLabelsDialog] ✅ Bulk update complete!
[ManageLabelsDialog]   Updated 15 element(s) in 11 diagram(s) across 2 model(s)
```

### Update Summary

After completion, you'll see a success message:

```
Successfully updated 15 element(s) in 11 diagram(s) across 2 model(s).
```

## Best Practices

### 1. Test First

Before bulk updating a large model:
1. Create a test diagram
2. Add a few elements of the type you're changing
3. Test the label configuration
4. Verify it looks correct
5. Then apply to full model

### 2. Backup Before Major Changes

```bash
# Create backup before bulk update
cp ~/Documents/ArchiModel.archimate ~/Documents/ArchiModel-backup.archimate
```

### 3. Review Changes

After bulk update:
1. Open a few representative diagrams
2. Verify labels look correct
3. Check edge cases (elements with/without specialization, etc.)
4. Use Archi's undo if needed

### 4. Staged Updates

For large changes, update in stages:
1. Update Business layer elements first
2. Review results
3. Update Application layer next
4. Continue layer by layer

### 5. Team Coordination

When working with a team:
1. Agree on label standards first
2. Communicate before bulk updates
3. Update models during quiet periods
4. Document the standard in project wiki

## Common Use Cases

### 1. Initial Standardization

You've inherited a model with inconsistent labeling:

- **Solution:** Define standard labels for all element types, then bulk update

### 2. Rebranding

Your organization changes naming conventions:

- **Before:** "IT Service"
- **After:** "Technology Service"
- **Solution:** Update label pattern and bulk update all affected elements

### 3. Documentation Enhancement

Add more information to existing elements:

- **Before:** `${name}`
- **After:** `${name}\n${property:Owner}`
- **Solution:** Bulk update to show owner on all elements

### 4. Specialization Standardization

Make specializations visible across all diagrams:

- **Before:** Specializations hidden
- **After:** `<<${specialization}>>\n${name}`
- **Solution:** Bulk update all element types to show specialization

### 5. Multi-Model Consistency

Maintain consistency across multiple related models:

- **Scenario:** Multiple models open (Infrastructure, Application, Business)
- **Solution:** One bulk update applies to all models simultaneously

## Limitations

### What Cannot Be Updated

1. **Closed models**: Only processes currently open models
2. **Model tree elements**: Only updates elements placed in diagrams
3. **Locked models**: Read-only models cannot be updated
4. **External references**: Elements from other files

### Undo Support

- Archi's built-in undo works for bulk updates
- Press **Ctrl+Z** (Cmd+Z on Mac) to undo changes
- Or use **Edit → Undo**

## Troubleshooting

### No Prompt Appears

**Cause:** No label changes detected

**Solution:**
- Verify you actually modified labels
- Try modifying a different element type
- Check that you clicked a label cell and changed the value

### Some Elements Not Updated

**Possible Causes:**
1. Elements not in any diagram
2. Model not currently open
3. Element type doesn't match exactly

**Solution:**
- Ensure all relevant models are open
- Check element is placed in a diagram
- Verify element type name matches configuration

### Update Seems Slow

**For very large models:**
1. Close unnecessary models first
2. Close other applications to free memory
3. Consider updating layer by layer
4. Check console for progress messages

### Update Failed with Error

**Steps:**
1. Check **Help → Show Log** for error details
2. Try updating fewer elements (test with one element type)
3. Ensure models are not read-only
4. Restart Archi and try again

## Advanced Features

### Selective Updates

To update only certain element types:

1. Only modify labels for types you want to update
2. Leave other types unchanged
3. Click **OK**
4. Only modified types will be updated

### Cross-Model Updates

The bulk update is workspace-aware:

- Updates ALL models open in workspace
- Maintains consistency across related models
- Perfect for multi-model architectures

### Label Expression Validation

Before bulk update:

1. Test expression on one element
2. Verify conditional logic works
3. Check for undefined properties
4. Then apply to all

## Code Implementation

The bulk update feature is implemented in `ManageLabelsDialog.java`:

**Key Methods:**
- `detectChanges()` - Compares original vs. current labels
- `okPressed()` - Triggers update flow with confirmation
- `updateAllElementsInModel()` - Coordinates bulk update
- `processDiagram()` - Processes all elements in a diagram
- `processElement()` - Recursively updates individual elements

## Version History

### Version 1.0.0 (Current)
- ✅ Automatic change detection
- ✅ Confirmation dialog
- ✅ Bulk update across all open models
- ✅ Recursive element processing
- ✅ Detailed logging
- ✅ Update summary

### Future Enhancements (Planned)
- Preview changes before applying
- Selective model updates
- Update statistics and reporting
- Dry-run mode

## Related Documentation

- [QUICK_START.md](QUICK_START.md) - Quick start guide including bulk update
- [README.md](../README.md) - Main documentation
- [INSTALL.md](INSTALL.md) - Installation guide
- [CHANGELOG.md](CHANGELOG.md) - Version history

## Summary

The bulk update feature is a powerful tool for:
- ✅ Maintaining consistency across large models
- ✅ Quickly standardizing existing elements
- ✅ Saving time on manual updates
- ✅ Ensuring team-wide label standards
- ✅ Managing multiple models simultaneously

Use it wisely, test first, and enjoy consistent, professional-looking ArchiMate diagrams! 🎯
