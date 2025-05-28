# 📷 Image Reorder & Delete Interaction

This app allows users to interact with a gallery of images using intuitive gestures.

---

## 📦 Download

Try it out:

- [📱 Download v1.0.0 APK](https://github.com/Execlandry/personal_image_gallery_app/releases/download/v1.0.0/app-release.apk)

---

## 🎥 Demo

### 🔁 Reorder Demo  
[🔗 Watch Demo](https://github.com/user-attachments/assets/b4d3965c-e54c-4c38-8123-6991c7510a94)

### 📤 Upload Images (Personalized Screen)  
[🔗 Watch Upload Demo](https://github.com/user-attachments/assets/9f1c38b0-8674-4ec7-8ac2-39ca3072d58d)

---

## 🖼 Screenshots

| ![](https://github.com/user-attachments/assets/ae0e2203-91fe-40b7-b003-117ed4daba12) | ![](https://github.com/user-attachments/assets/91e76d09-ed68-47d3-be3b-89b791df38d7) |
| --- | --- |
| ![](https://github.com/user-attachments/assets/6c5372ee-3e38-4554-94bc-4aaa537f28a0) | ![](https://github.com/user-attachments/assets/2fb735d4-db86-4615-bcbf-ba92c8030723) |
| ![](https://github.com/user-attachments/assets/4d57bbbe-5a58-4efc-8a28-f656b2eac7a7) | ![](https://github.com/user-attachments/assets/85d87c75-dce1-4070-b1af-76e37380bcd5) |
| ![](https://github.com/user-attachments/assets/6b863921-4e2c-4c23-9ea7-d0e0da5b957b) | ![](https://github.com/user-attachments/assets/278fb0d1-07b8-49ae-a561-2b759b917e0f) |

---

## 🛠 Features

- **🌀 Long Press & Drag to Reorder**  
  Easily reorder your images by long pressing and dragging them to the desired position.

- **🗑 Tap to Delete**  
  Tap once on any image to open a confirmation dialog for deletion.

---

## ⚠️ Known Issues

- Images uploaded by one user ID are retained in the current session.
- Logging in with another user ID without restarting the app will still show the previous user’s images due to shared state.

### ✅ Suggested Fixes

- Implement a **backend** to manage user sessions and persist image data per user.
- Alternatively, use **SharedPreferences** or similar local storage to isolate state between user sessions.

---
