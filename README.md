<div align="center">

# IKillAir

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=for-the-badge&logo=prisma&logoColor=white)](https://www.prisma.io/)
[![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/cloud/)

**ITDS283 Mobile Application Development's Mobile Project - Section 2 Group 8**

</div>

---

## 📝 Description

- **This project is about developing a mobile application that provides real-time air quality information and weather updates for users in their respective countries. using Flutter and Dart in frontend part and Javascript and Node.js in backend part. Also, PostgreSQL and Prisma are used for database management. Oracle Cloud is used for deployment.**

## ✨ Features

- 😷 **Pollution in your country** - Provided pollution data including AQI, CO2, NO2, NH3, and SO2 Level in your current location.
- 🌍 **Pollution Global** - Provided AQI Level from highest to lowest by all countries.
- 🌡️ **Weather in your country** - Provided weather data in your current location.
- 🎨 **Modern UI** - Clean design with Flutter.
- 🔍 **Real-time Search** - Search by API.
- 🗺️ **Geolocator** - Know your location.

---

## 🛠️ Tech Stack

| Category       | Technologies                |
| -------------- | --------------------------- |
| **Frontend**  | Flutter, Dart        |
| **Backend**    | JavaScript, Node.js |
| **Database**        | PostgreSQL, Prisma       |
| **API**         | IQAir, WAQI   |
| **Deployment** | Oracle Cloud, Cloudfare                  |

---

## 🚀 Getting Started

### Prerequisites

- npm

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Saksit-Jittasopee/ITDS283-IKillAir-6787015-6787077.git
   ```

2. **Install dependencies (Backend)**

   ```bash
   cd server
   npm i
   ```

3. **Generate Prisma Client (Backend)**

   ```bash
   npx prisma generate
   ```

4. **Run the server (Backend)**

   ```bash
   npm run dev
   ```

5. **Install Flutter's dependencies (Frontend)**

   ```bash
   flutter pub get
   ```

6. **Create .env file (Frontend)**

   ```env
    AIR_VISUAL_API_KEY=YOUR_AIR_VISUAL_API_KEY
    WAQI_API_KEY=YOUR_WAQI_API_KEY
    JWT_SECRET=YOUR_JWT_SECRET
   ```

7. **Run the flutter app on Mobile Emulator Only** 🎉
   
   ```bash
   flutter run
   ```

---

## 📁 API Endpoints

**Base URL:** `http://`

**Auth Header:** `Authorization: Bearer <token>`

api endpoints later

## 📁 Project Structure

```
ikillair/
📦images
 ┣ 📂news
 ┃ ┣ 📜aa.png
 ┃ ┣ 📜bb.jpg
 ┃ ┣ 📜cc.jpg
 ┃ ┣ 📜dd.jpg
 ┃ ┣ 📜ee.png
 ┃ ┣ 📜ff.png
 ┃ ┣ 📜pm2.5.webp
 ┃ ┗ 📜reduce_energy.jpg
 ┣ 📂payment
 ┃ ┗ 📜Promptpay.jpg
 ┣ 📂Products
 ┃ ┣ 📜airpurifier1.png
 ┃ ┣ 📜airpurifier2.png
 ┃ ┣ 📜carfilter.png
 ┃ ┣ 📜filter1.png
 ┃ ┣ 📜industrial.png
 ┃ ┗ 📜sensor1.png
 ┣ 📂team
 ┃ ┣ 📜Chanasorn.jpg
 ┃ ┣ 📜dummy.png
 ┃ ┗ 📜Saksit.jpg
 ┗ 📂weather
 ┃ ┣ 📜cloudy.jpg
 ┃ ┣ 📜raining.jpg
 ┃ ┗ 📜sunny.jpg
📦lib
 ┣ 📂adminPages
 ┃ ┣ 📜adminHomePage.dart
 ┃ ┣ 📜adminNews.dart
 ┃ ┣ 📜adminNotification.dart
 ┃ ┣ 📜adminOrder.dart
 ┃ ┣ 📜adminProduct.dart
 ┃ ┗ 📜adminUser.dart
 ┣ 📂api
 ┃ ┣ 📜iqair_api.dart
 ┃ ┗ 📜waqi_api.dart
 ┣ 📂pages
 ┃ ┣ 📜cardPayment.dart
 ┃ ┣ 📜cartScreen.dart
 ┃ ┣ 📜createaccount.dart
 ┃ ┣ 📜forgotPassword1.dart
 ┃ ┣ 📜forgotPassword2.dart
 ┃ ┣ 📜homeScreen.dart
 ┃ ┣ 📜loginUser.dart
 ┃ ┣ 📜newsScreen.dart
 ┃ ┣ 📜notification.dart
 ┃ ┣ 📜paymentScreen.dart
 ┃ ┣ 📜pollutionScreen.dart
 ┃ ┣ 📜productScreen.dart
 ┃ ┣ 📜profileScreen.dart
 ┃ ┣ 📜qrCodePayment.dart
 ┃ ┣ 📜team.dart
 ┃ ┣ 📜thankyou.dart
 ┃ ┗ 📜weatherScreen.dart
 ┗ 📜main.dart
📦server
 ┣ 📂config
 ┃ ┗ 📜db.js
 ┣ 📂Controller
 ┃ ┣ 📜authController.js
 ┃ ┣ 📜dashboardController.js
 ┃ ┣ 📜newsController.js
 ┃ ┣ 📜notiController.js
 ┃ ┣ 📜orderController.js
 ┃ ┣ 📜orditemController.js
 ┃ ┣ 📜productController.js
 ┃ ┣ 📜searchController.js
 ┃ ┗ 📜userController.js
 ┣ 📂Images
 ┃ ┗ 📜dummy.png
 ┣ 📂middlewares
 ┃ ┣ 📜authMiddleware.js
 ┃ ┗ 📜rateLimitMiddleware.js
 ┣ 📂node_modules
 ┃ ┗ 📂.cache
 ┃ ┃ ┗ 📂prisma
 ┃ ┃ ┃ ┗ 📂master
 ┃ ┃ ┃ ┃ ┗ 📂75cbdc1eb7150937890ad5465d861175c6624711
 ┃ ┃ ┃ ┃ ┃ ┗ 📂windows
 ┣ 📂prisma
 ┃ ┣ 📂migrations
 ┃ ┃ ┣ 📂20260401160527_ikill_air
 ┃ ┃ ┃ ┗ 📜migration.sql
 ┃ ┃ ┗ 📜migration_lock.toml
 ┃ ┗ 📜schema.prisma
 ┣ 📂routes
 ┃ ┣ 📜authRoutes.js
 ┃ ┣ 📜dashboardRoutes.js
 ┃ ┣ 📜newsRoutes.js
 ┃ ┣ 📜notiRoutes.js
 ┃ ┣ 📜orderRoutes.js
 ┃ ┣ 📜orditemRoutes.js
 ┃ ┣ 📜productRoutes.js
 ┃ ┣ 📜searchRoutes.js
 ┃ ┗ 📜userRoutes.js
 ┣ 📂services
 ┃ ┣ 📜authService.js
 ┃ ┣ 📜dashboardService.js
 ┃ ┣ 📜orderService.js
 ┃ ┣ 📜orditemService.js
 ┃ ┣ 📜productService.js
 ┃ ┗ 📜userService.js
 ┣ 📜.env
 ┣ 📜.gitignore
 ┣ 📜app.js
 ┣ 📜package-lock.json
 ┣ 📜package.json
 ┗ 📜prisma.config.ts
┣ 📜.gitignore
┣ 📜.metadata
┣ 📜analysis_options.yaml
┣ 📜package-lock.json
┣ 📜package.json
┣ 📜pubspec.lock
┣ 📜pubspec.yaml
┗ 📜README.md
```

---

## 🤝 Connect With Us

<div align="center">

**Chanasorn Chirapongsathon**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/chanasorn-chirapongsathon-a493283a6/)
[![GitHub](https://img.shields.io/badge/GitHub-white?style=for-the-badge&logo=github&logoColor=black)](https://github.com/SugguSCH)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/nebu1.su_/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/chanasorn.sugus/)

**Saksit Jittasopee**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/saksit-jittasopee-743981382/)
[![GitHub](https://img.shields.io/badge/GitHub-white?style=for-the-badge&logo=github&logoColor=black)](https://github.com/Saksit-Jittasopee)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/saksitjittasopee/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/saksit.jittasopee.1/)

**⭐ Star this repo if you like it!**

</div>

---

<div align="center">

## 👥 Our Team

| StudentID       | Name                |
| -------------- | --------------------------- |
| **6787015**  | Chanasorn Chirapongsathon        |
| **6787077**    | Saksit Jittasopee |

_2nd Year DST Student Section 2 Group 8 @ Mahidol University_

</div>