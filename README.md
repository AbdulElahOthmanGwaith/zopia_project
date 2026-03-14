# ZOPIA 🚀

> تطبيق تواصل اجتماعي + سوق إلكتروني مبني بـ Flutter و Firebase

---

## 📱 المميزات

| الميزة | الوصف |
|--------|-------|
| 🔐 المصادقة | تسجيل دخول / إنشاء حساب بالبريد الإلكتروني |
| 📰 الفيد | منشورات النصوص والصور مع القصص |
| ❤️ التفاعل | لايك، تعليق، مشاركة، حفظ |
| 🏷️ الإعلانات | سوق لبيع وشراء المنتجات مع فلترة بالفئة |
| 💬 المحادثات | دردشة مباشرة بين المستخدمين |
| 🔔 الإشعارات | إشعارات فورية (لايك، متابعة، رسائل) |
| 👤 الملف الشخصي | تعديل البيانات، متابعة، إحصائيات |
| 🌙 الوضع الليلي | دعم الوضع الداكن |
| 🌐 متعدد اللغات | عربي / إنجليزي |

---

## 🛠️ التقنيات

- **Flutter** 3.x
- **Firebase** (Auth, Firestore, Storage, Messaging)
- **Provider** — إدارة الحالة
- **Google Fonts** (Cairo)
- **Cached Network Image**
- **TimeAgo** — للتوقيت النسبي

---

## 📂 هيكل المشروع

```
lib/
├── main.dart
├── app.dart
├── config/
│   └── theme.dart
├── models/
│   ├── user_model.dart
│   ├── post_model.dart
│   ├── ad_model.dart
│   ├── message_model.dart
│   └── notification_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── storage_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── theme_provider.dart
│   └── language_provider.dart
├── pages/
│   ├── home/home_page.dart
│   ├── login/login_page.dart
│   ├── feed/feed_page.dart
│   ├── ads/ads_page.dart
│   ├── chat/chat_page.dart
│   ├── profile/profile_page.dart
│   └── notifications/notifications_page.dart
└── widgets/
    ├── post_card.dart
    ├── story_bar.dart
    └── create_post.dart
```

---

## 🚀 تشغيل المشروع

### 1. المتطلبات
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- حساب Firebase

### 2. إعداد Firebase

```bash
# تثبيت FlutterFire CLI
dart pub global activate flutterfire_cli

# تهيئة Firebase في المشروع
flutterfire configure
```

### 3. تثبيت المكتبات

```bash
flutter pub get
```

### 4. تشغيل التطبيق

```bash
flutter run
```

---

## 🔒 قواعد Firestore

موجودة في ملف `firestore.rules` — ارفعها إلى Firebase:

```bash
firebase deploy --only firestore:rules
```

---

## 📦 الإنتاج

```bash
# Android APK
flutter build apk --release

# Android AAB (للمتجر)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🤝 المساهمة

1. Fork المشروع
2. أنشئ branch جديد: `git checkout -b feature/اسم-الميزة`
3. Commit التغييرات: `git commit -m 'إضافة ميزة جديدة'`
4. Push: `git push origin feature/اسم-الميزة`
5. افتح Pull Request

---

## 📄 الترخيص

MIT License — حر الاستخدام والتعديل

---

**صُنع بـ ❤️ لمجتمع المطورين العرب**
