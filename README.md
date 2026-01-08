# Quiz Master 🎯

**Quiz Master** is a production-grade Flutter application for creating, generating, and playing
quizzes.
It demonstrates **Clean Architecture**, **BLoC state management**, **offline-first design**, *
*AI-powered quiz generation**, and **CI-driven quality checks**.

This project is built as a **portfolio-ready application** showcasing real-world Flutter engineering
practices.

---

## ✨ Features

### 🧠 Quiz Experience

* Create quizzes with multiple-choice questions
* Play quizzes and view instant results
* Quiz history with performance tracking
* Retry quizzes to improve scores
* Offline-first experience using local cache (Hive)

### 🤖 AI Quiz Generation

* Generate quizzes using an **AI-powered Python backend**
* Dynamic question & option creation
* Seamless integration with Flutter frontend

### 🔐 Authentication

* Email & password authentication
* Google Sign-In
* Firebase Authentication integration

### 🎨 UI & UX

* Material 3 design
* Light / Dark theme support
* Centralized theming system
* Reusable UI components

---

## 🏗 Architecture & Technical Highlights

### Clean Architecture (Feature-First)

The app follows **Clean Architecture** with strict separation of concerns:

* **Presentation** → UI + BLoC
* **Domain** → Business logic & entities
* **Data** → Repositories & data sources

### State Management

* **BLoC (flutter_bloc)**
* Event-driven, predictable state transitions
* Testable business logic
* No UI logic inside blocs

### Data Strategy

* **Hive** for local persistence
* **Firestore** for cloud sync
* **Offline-first bootstrapping**
* Explicit sync handling

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/            # App-wide configuration (theme, strings, hive)
│   ├── di/                # Dependency injection (GetIt)
│   ├── firebase/          # Firebase initialization
│   ├── router/            # GoRouter configuration
│   └── ui/                # Shared UI (settings, start screen)
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── quiz/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

---

## 🔗 Backend & External Dependencies

### 🔥 Firebase

* Firebase Authentication
* Cloud Firestore
* Used for authentication and quiz syncing

### 🤖 AI Backend (Python)

Quiz Master integrates with a separate Python-based AI backend responsible for:

* Parsing uploaded documents (PDF / text)
* Generating quiz questions using LLMs
* Returning structured quiz data to Flutter

Repository: [ai-backend](https://github.com/dev-zeb/ai-backend)

> The backend is optional for running the app locally.
> Without it, AI quiz generation will be disabled, but all other features work.

---

## 🧪 Testing Strategy

The project includes **automated tests** to ensure reliability.

### Unit Tests

* Model serialization / deserialization
* Business rules validation

### Widget Tests

* Form validation
* User interaction logic
* UI behavior without real backend

**Tests are designed to be:**

* Fast
* Deterministic
* CI-friendly (no real network calls)

---

## ⚙️ CI / CD

GitHub Actions CI pipeline includes:

* Dependency caching
* Static analysis (`dart analyze`)
* Code formatting validation (`dart format .`)
* Automated tests
* Debug APK build on push

CI runs on:

* `main`
* `develop`
* On Push and Pull requests

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/dev-zeb/quiz_master
cd quiz_master
```

### 2. Set up environment variables

Create a `.env` file in the project root:

```bash
BASE_URL=http://localhost:8000
```

### 3. Install dependencies

```
flutter pub get
```

### 4. Run the app

```
flutter run
```

---

## 🛠 Requirements

* Flutter SDK ≥ 3.27.3
* Dart SDK ≥ 3.1
* Firebase project (for auth & sync)
* Python backend (for AI quiz generation)

---

## 📄 License

This project is licensed under a **custom restrictive license**.

* You may view and study the source code for educational and evaluation purposes only.
* Commercial use, redistribution, or modification without explicit permission is prohibited.

See the **LICENSE** file for full terms.


---

## 👤 Author

### Sufi Aurangzeb Hossain

#### Flutter Developer | Next.js | Python

#### *Crafting beautiful and functional mobile apps with ❤️*

#### LinkedIn: [Sufi Aurangzeb Hossain](https://www.linkedin.com/in/sufiazan49/)

---

⚠️ This project is intended for learning and portfolio demonstration purposes.

