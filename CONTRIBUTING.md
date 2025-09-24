# Contributing to Wheels Car Rental Application

Thank you for your interest in contributing to the Wheels Car Rental Application! We welcome contributions from developers of all skill levels.

## 🚀 Getting Started

### Prerequisites
- Java 11 or higher
- Apache Maven 3.6+
- MySQL Server 8.0+
- Git

### Setting up the Development Environment

1. **Fork and Clone the Repository**
   ```bash
   git clone https://github.com/your-username/Car-rental-Application.git
   cd Car-rental-Application
   ```

2. **Set up the Database**
   ```bash
   mysql -u root -p < database/schema.sql
   ```

3. **Configure Database Connection**
   Update the database credentials in `src/main/java/com/wheels/util/DatabaseSingleton.java`

4. **Build the Project**
   ```bash
   ./scripts/setup.sh
   ```

## 🔧 Development Guidelines

### Code Style
- Follow Java naming conventions
- Use meaningful variable and method names
- Add JavaDoc comments for public methods
- Keep methods focused and concise
- Use proper indentation (4 spaces)

### Commit Messages
Use descriptive commit messages following this format:
```
Type: Brief description

Detailed explanation if necessary

Examples:
- Add: New booking validation feature
- Fix: Database connection timeout issue
- Update: User interface styling improvements
- Remove: Deprecated payment method
```

### Branch Naming
- `feature/feature-name` for new features
- `fix/bug-description` for bug fixes
- `docs/documentation-update` for documentation changes
- `refactor/component-name` for code refactoring

## 🐛 Reporting Issues

When reporting issues, please include:
- **Environment**: OS, Java version, Browser (if applicable)
- **Steps to Reproduce**: Clear steps to reproduce the issue
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Screenshots**: If applicable
- **Error Messages**: Full error messages and stack traces

## 🚀 Submitting Changes

1. **Create a New Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Write clean, well-documented code
   - Add tests if applicable
   - Update documentation if needed

3. **Test Your Changes**
   ```bash
   mvn clean test
   mvn package
   ```

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: Your descriptive commit message"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use a clear and descriptive title
   - Explain the changes made
   - Reference any related issues
   - Include screenshots for UI changes

## 🎯 Areas Where You Can Contribute

### 🌟 High Priority
- **Security Improvements**: Enhanced authentication and authorization
- **Performance Optimization**: Database query optimization
- **Mobile Responsiveness**: Better mobile user experience
- **API Development**: RESTful API for mobile app integration

### 📝 Documentation
- **User Manuals**: Step-by-step user guides
- **API Documentation**: Comprehensive API documentation
- **Code Comments**: Improve code documentation
- **Translation**: Multi-language support

### 🎨 User Interface
- **UI/UX Improvements**: Enhanced user experience
- **Accessibility**: Better accessibility features
- **Themes**: Additional UI themes
- **Icons and Graphics**: Improved visual elements

### 🔧 Technical Improvements
- **Testing**: Unit tests and integration tests
- **CI/CD Pipeline**: Automated testing and deployment
- **Docker Support**: Containerization
- **Database Migrations**: Version-controlled database changes

## 📋 Pull Request Checklist

Before submitting your pull request, make sure:

- [ ] Code follows the established style guidelines
- [ ] All tests pass (`mvn test`)
- [ ] Application builds successfully (`mvn package`)
- [ ] Documentation is updated (if applicable)
- [ ] Commit messages are clear and descriptive
- [ ] No sensitive information (passwords, keys) is committed
- [ ] Screenshots are included for UI changes

## 🤝 Code of Conduct

### Our Pledge
We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Expected Behavior
- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 📞 Getting Help

If you need help or have questions:

1. **Check the Documentation**: Start with the README.md
2. **Search Issues**: Look for existing issues that might answer your question
3. **Create an Issue**: If you can't find an answer, create a new issue
4. **Discussion**: Use GitHub Discussions for general questions

## 🏆 Recognition

Contributors will be recognized in the following ways:
- Listed in the project's contributors section
- Mentioned in release notes for significant contributions
- GitHub contributor statistics

## 📝 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Wheels Car Rental Application! 🚗✨