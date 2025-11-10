# Contributing to Archi Default Label Plugin

Thank you for your interest in contributing to the Archi Default Label Plugin! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear, descriptive title
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Archi version and OS information
   - Plugin version

### Suggesting Enhancements

We welcome suggestions for new features:

1. **Open an issue** labeled "enhancement"
2. Describe the feature and its benefits
3. Provide use cases and examples
4. Discuss implementation approach if possible

### Pull Requests

We're happy to accept pull requests:

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**:
   - Follow existing code style
   - Add comments for complex logic
   - Update documentation if needed
4. **Test thoroughly**:
   - Build the plugin
   - Test in Archi
   - Verify no regressions
5. **Commit with clear messages**:
   ```bash
   git commit -m "Add feature: description of what you added"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create pull request** with:
   - Description of changes
   - Related issue numbers
   - Testing performed

## Development Setup

### Prerequisites

- Eclipse IDE for RCP and RAP Developers
- Archi installation (for dependencies)
- Java JDK 11 or higher
- Git

### Setup Steps

1. **Clone repository**:
   ```bash
   git clone <repository-url>
   cd archi-auto-label-config
   ```

2. **Import into Eclipse**:
   - File → Import → Existing Projects into Workspace
   - Select the cloned directory

3. **Configure dependencies**:
   - See [docs/FIND_DEPENDENCIES.md](docs/FIND_DEPENDENCIES.md)
   - Add Archi JARs to Build Path

4. **Build**:
   - Project → Clean → Build

5. **Test**:
   ```bash
   bash scripts/build_final.sh /path/to/archi
   cp -r final-plugin/com.vhsystem.defaultlabel_1.0.0.qualifier ~/.archi/dropins/
   ```

## Code Style

### Java Code

- **Indentation**: 4 spaces (no tabs)
- **Line length**: 120 characters max
- **Naming**:
  - Classes: PascalCase
  - Methods: camelCase
  - Constants: UPPER_SNAKE_CASE
- **Comments**:
  - JavaDoc for public methods
  - Inline comments for complex logic
  - TODO/FIXME for temporary code

### Example:

```java
/**
 * Applies default label to the given element.
 * 
 * @param element The element to apply label to
 * @param labelExpression The label expression to apply
 * @return true if label was applied successfully
 */
public boolean applyLabel(IArchimateElement element, String labelExpression) {
    // Validate inputs
    if (element == null || labelExpression == null) {
        return false;
    }
    
    // Apply label...
    // TODO: Add support for custom validators
    
    return true;
}
```

## Documentation

### Code Documentation

- Add JavaDoc to all public classes and methods
- Document complex algorithms
- Explain "why" not just "what"

### User Documentation

When adding features:
- Update README.md
- Add/update relevant docs in docs/
- Include usage examples
- Update CHANGELOG

### Commit Messages

Follow conventional commits format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Build/tooling changes

**Examples:**
```
feat(bulk-update): add progress dialog for large models

fix(label-manager): handle null specialization properly

docs(readme): update installation instructions
```

## Testing

### Manual Testing

Before submitting PR:

1. **Build plugin successfully**
2. **Install in Archi**
3. **Test basic functionality**:
   - Open configuration dialog
   - Modify labels
   - Create new elements
   - Verify labels applied
4. **Test bulk update**:
   - Change configuration
   - Confirm bulk update works
   - Check multiple models
5. **Test edge cases**:
   - Elements without names
   - Missing properties
   - Empty configurations
   - Very large models

### Test Checklist

- [ ] Plugin builds without errors
- [ ] Menu appears in Tools
- [ ] Dialog opens and displays element types
- [ ] Can edit labels via double-click
- [ ] Labels save and persist
- [ ] New elements get automatic labels
- [ ] Bulk update detects changes
- [ ] Bulk update updates all elements
- [ ] No duplicate labels
- [ ] Console logs are informative
- [ ] No error messages in Archi log

## Project Structure

```
archi-auto-label-config/
├── src/                              # Java source code
│   └── com/vhsystem/defaultlabel/
│       ├── DefaultLabelPlugin.java   # Main plugin activator
│       ├── LabelManager.java         # Core singleton manager
│       ├── StartupHandler.java       # Early initialization
│       ├── dialogs/
│       │   └── ManageLabelsDialog.java  # Configuration UI
│       └── handlers/
│           └── ManageLabelsHandler.java # Menu command
├── META-INF/
│   └── MANIFEST.MF                   # OSGi manifest
├── plugin.xml                        # Extension points
├── build.properties                  # Build configuration
├── scripts/                          # Build scripts
├── docs/                             # Documentation
└── final-plugin/                     # Build output
```

## Adding New Features

### Example: Adding a New Label Variable

1. **Update LabelManager**:
   ```java
   // Add support for new variable ${custom}
   private String expandLabelExpression(String expression, IArchimateElement element) {
       // ... existing code ...
       expression = expression.replace("${custom}", getCustomValue(element));
       return expression;
   }
   ```

2. **Document in README**:
   ```markdown
   | `${custom}` | Custom value | "CustomValue" |
   ```

3. **Add to dialog helper text**
4. **Test with various elements**
5. **Update CHANGELOG**

## Release Process

1. **Update version numbers**:
   - MANIFEST.MF
   - README.md
   - plugin.xml

2. **Update CHANGELOG**

3. **Build release**:
   ```bash
   bash scripts/build_final.sh /path/to/archi
   ```

4. **Test release build**

5. **Create git tag**:
   ```bash
   git tag -a v1.0.1 -m "Release version 1.0.1"
   git push origin v1.0.1
   ```

6. **Create GitHub release**:
   - Upload JAR file
   - Include changelog
   - Add documentation links

## Questions?

- Open an issue for questions
- Check existing documentation
- Review closed issues for similar topics

## Code of Conduct

- Be respectful and professional
- Welcome newcomers
- Focus on constructive feedback
- Help others learn

## License

By contributing, you agree that your contributions will be licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

Thank you for contributing to make this plugin better! 🎉

