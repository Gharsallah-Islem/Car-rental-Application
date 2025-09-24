# 🚀 Quick Start Guide - Wheels Car Rental Application

Get your Wheels Car Rental Application up and running in minutes!

## ⚡ Prerequisites Check

Before starting, ensure you have:
- ✅ Java 11+ installed (`java -version`)
- ✅ Maven 3.6+ installed (`mvn -version`)
- ✅ MySQL Server running
- ✅ Git installed

## 🏃‍♂️ 5-Minute Setup

### 1. Clone & Navigate
```bash
git clone https://github.com/Gharsallah-Islem/Car-rental-Application.git
cd Car-rental-Application
```

### 2. Database Setup
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE wheels_db;"

# Import schema
mysql -u root -p wheels_db < database/schema.sql
```

### 3. Configure Database Connection
Edit `src/main/java/com/wheels/util/DatabaseSingleton.java`:
```java
private static final String USER = "your_mysql_username";
private static final String PASSWORD = "your_mysql_password";
```

### 4. Build & Run
```bash
# Automated setup (recommended)
chmod +x scripts/setup.sh
./scripts/setup.sh

# OR manual build
mvn clean package
```

### 5. Deploy
- Copy `target/wheels-app.war` to your application server
- Start your server (Tomcat 10+, GlassFish, etc.)
- Access: `http://localhost:8080/wheels-app`

## 🎯 First Steps After Installation

### 1. Explore the Dashboard
- Navigate to the main dashboard
- Review revenue metrics and statistics
- Check available cars and bookings

### 2. Set Up Your Fleet
1. **Add Parking Locations** (Parcs)
   - Go to "Parcs" section
   - Add your parking facilities

2. **Add Vehicles** (Units)
   - Go to "Units" section
   - Add your car inventory
   - Assign to parking locations

### 3. Manage Users
1. **Add Clients**
   - Register customers who will rent cars

2. **Add Drivers** (Optional)
   - Add professional drivers for full-service rentals

### 4. Start Taking Bookings
- Create new bookings through the "Bookings" section
- Assign cars and drivers
- Track booking status and payments

## 🔧 Troubleshooting

### Common Issues

**Build Fails**
```bash
# Check Java version
java -version
# Should be 11 or higher

# Clean and rebuild
mvn clean compile
```

**Database Connection Error**
- Verify MySQL is running: `service mysql status`
- Check credentials in `DatabaseSingleton.java`
- Ensure database `wheels_db` exists

**Application Won't Start**
- Check server logs for errors
- Verify WAR file deployment
- Ensure port 8080 is available

**UI Not Loading**
- Clear browser cache
- Check for JavaScript errors in browser console
- Verify all CSS/JS resources are loading

## 📚 Next Steps

1. **Read the Full Documentation**: Check the main README.md
2. **Explore Features**: Try each module (Bookings, Units, Clients, etc.)
3. **Customize**: Modify styling and business logic as needed
4. **Contribute**: See CONTRIBUTING.md for ways to help improve the project

## 🆘 Getting Help

- **Issues**: [GitHub Issues](https://github.com/Gharsallah-Islem/Car-rental-Application/issues)
- **Documentation**: Full README.md file
- **Contributing**: CONTRIBUTING.md file

---

🎉 **Congratulations!** Your Wheels Car Rental Application is ready to go! 🚗