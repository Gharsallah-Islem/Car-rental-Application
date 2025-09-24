#!/bin/bash

# Wheels Car Rental Application Setup Script
# This script helps set up the development environment

echo "🚗 Welcome to Wheels Car Rental Application Setup"
echo "=================================================="

# Check Java version
echo "Checking Java version..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "✓ Java version: $JAVA_VERSION"
    
    # Check if Java 11 or higher
    if [[ $(echo $JAVA_VERSION | cut -d. -f1) -ge 11 ]]; then
        echo "✓ Java version is compatible (11 or higher)"
    else
        echo "❌ Java 11 or higher is required. Current version: $JAVA_VERSION"
        exit 1
    fi
else
    echo "❌ Java is not installed. Please install Java 11 or higher."
    exit 1
fi

# Check Maven
echo "Checking Maven..."
if command -v mvn &> /dev/null; then
    MAVEN_VERSION=$(mvn -version | head -n 1 | awk '{print $3}')
    echo "✓ Maven version: $MAVEN_VERSION"
else
    echo "❌ Maven is not installed. Please install Apache Maven 3.6+."
    exit 1
fi

# Check MySQL
echo "Checking MySQL..."
if command -v mysql &> /dev/null; then
    echo "✓ MySQL is available"
else
    echo "⚠️  MySQL client not found. Please ensure MySQL Server is installed and running."
fi

# Build the project
echo "Building the project..."
mvn clean compile
if [ $? -eq 0 ]; then
    echo "✓ Project compiled successfully"
else
    echo "❌ Project compilation failed"
    exit 1
fi

# Package the application
echo "Packaging the application..."
mvn package
if [ $? -eq 0 ]; then
    echo "✓ Application packaged successfully"
    echo "✓ WAR file created: target/wheels-app.war"
else
    echo "❌ Application packaging failed"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Set up MySQL database:"
echo "   - Create database: wheels_db"
echo "   - Run: mysql -u root -p wheels_db < database/schema.sql"
echo ""
echo "2. Update database configuration in:"
echo "   src/main/java/com/wheels/util/DatabaseSingleton.java"
echo ""
echo "3. Deploy target/wheels-app.war to your application server"
echo ""
echo "4. Access the application at: http://localhost:8080/wheels-app"
echo ""