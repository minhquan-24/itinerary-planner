# 🧭 Local Itinerary Planner - Trợ lý Lên lịch Trải nghiệm & Hội ngộ

Ứng dụng **Full-Stack Mobile** thiết kế chuyên biệt cho người mới bắt đầu học lập trình ứng dụng di động với **Flutter (Dart)** và **NestJS (TypeScript)**. 

Dự án giải quyết bài toán thực tế: Lên lịch trình đón người thân, gia đình từ xa tới thăm, tổ chức danh sách địa điểm/hoạt động lồng nhau theo từng ngày, kèm banner đếm ngược đến ngày hội ngộ.

---

## ✨ Tính năng Cốt lõi

- ⏳ **Banner Đếm ngược (Countdown Timer)**: Tính toán thời gian thực (Ngày, Giờ, Phút, Giây) từ hiện tại đến thời điểm hội ngộ.
- 📋 **Quản lý Lịch trình Lồng nhau (Nested List UI)**: Thiết kế danh sách đa cấp `Chuyến đi -> Ngày trải nghiệm -> Các địa điểm & hoạt động`.
- ✅ **Đồng bộ Trạng thái Checkbox (State Management & REST API)**: Đánh dấu "Đã trải nghiệm/Đã hoàn thành", tự động cập nhật UI và gửi yêu cầu `PATCH` đồng bộ tới NestJS server.
- ➕ **Thêm Địa điểm Mới**: Hỗ trợ popup thêm nhanh hoạt động/địa điểm vào từng ngày trong lịch trình.

---

## 🏗️ Cấu trúc Thư mục Dự án

```text
First_mobile_app/
├── mobile_app/                  # Frontend Flutter (Dart)
│   ├── lib/
│   │   ├── models/
│   │   │   └── trip_model.dart  # Data Models (Trip, TripDay, Activity)
│   │   ├── services/
│   │   │   └── trip_service.dart # HTTP Client gọi REST API NestJS
│   │   ├── widgets/
│   │   │   ├── countdown_card.dart       # Widget Banner đếm ngược
│   │   │   └── activity_item_widget.dart # Widget địa điểm & Checkbox
│   │   ├── screens/
│   │   │   └── trip_detail_screen.dart   # Màn hình chính
│   │   └── main.dart            # Điểm khởi chạy Flutter App
│   └── pubspec.yaml
├── backend/                     # Backend NestJS (TypeScript)
│   ├── src/
│   │   ├── trips/
│   │   │   ├── trips.controller.ts       # REST API Endpoints
│   │   │   ├── trips.service.ts          # Logic xử lý & Lưu trữ dữ liệu
│   │   │   └── trips.module.ts
│   │   ├── app.module.ts
│   │   └── main.ts                       # Server Entry point (Port 3000, CORS enabled)
│   └── package.json
├── sprint-0/                    # Tài liệu Quản lý Sprint & Thiết kế
│   └── implementation_plan.md   # Kế hoạch thực hiện dự án Sprint 0
├── .gitignore
└── README.md
```

---

## 🚀 Hướng dẫn Khởi chạy Dự án

### Yêu cầu Tiên quyết
- Node.js (v18+)
- Flutter SDK (v3.0+)
- Android Studio với Android Emulator (Pixel 10 hoặc tương đương)

### 1. Khởi chạy Backend (NestJS)
Mở cửa sổ Terminal 1:
```bash
cd backend
npm install
npm run start:dev
```
Server backend sẽ chạy tại: `http://localhost:3000`

### 2. Khởi chạy Frontend (Flutter) trên Android Emulator
Mở cửa sổ Terminal 2:
```bash
cd mobile_app
flutter run -d emulator-5554
```
*(Lưu ý: Android Emulator tự động kết nối với máy host qua IP `http://10.0.2.2:3000`)*

---

## 🔌 Tài liệu REST API (NestJS Backend)

| Method | Endpoint | Mô tả |
| :--- | :--- | :--- |
| `GET` | `/api/trips` | Lấy danh sách toàn bộ chuyến đi |
| `GET` | `/api/trips/:id` | Lấy chi tiết chuyến đi theo ID (Bao gồm danh sách Ngày & Địa điểm) |
| `PATCH` | `/api/trips/:tripId/activities/:activityId/toggle` | Đánh dấu hoàn thành/chưa hoàn thành địa điểm |
| `POST` | `/api/trips/:tripId/days/:dayIndex/activities` | Thêm hoạt động/địa điểm mới vào một ngày cụ thể |

---

## 🐙 Hướng dẫn Cập nhật Code lên GitHub

Mở Terminal tại thư mục gốc dự án (`First_mobile_app`):

```bash
# 1. Kiểm tra trạng thái và thêm file
git add .
git commit -m "docs: add root README.md and sprint-0 implementation_plan.md"

# 2. Đẩy code lên GitHub (Thay link repo của bạn)
git branch -M main
git remote add origin https://github.com/YourUsername/local-itinerary-planner.git
git push -u origin main
```
