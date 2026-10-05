# Kế hoạch Dự án: Trợ lý Lên lịch Trải nghiệm & Hội ngộ (Local Itinerary Planner)

Xây dựng ứng dụng Full-Stack Mobile dành cho người mới học Flutter/Dart & NestJS, giải quyết bài toán lên lịch trình đón người thân/gia đình từ xa tới thăm, quản lý danh sách địa điểm/hoạt động lồng nhau theo từng ngày, kèm đếm ngược ngày hội ngộ.

---

## 🏗️ Cấu trúc Tổng quan Dự án

```text
First_mobile_app/
├── mobile_app/                  # Flutter Frontend
│   ├── lib/
│   │   ├── models/
│   │   │   └── trip_model.dart  # Data Models: Trip, TripDay, Activity (Nested Structures)
│   │   ├── services/
│   │   │   └── trip_service.dart # Giao tiếp REST API với NestJS Server
│   │   ├── widgets/
│   │   │   ├── countdown_card.dart       # Widget Banner đếm ngược thời gian
│   │   │   └── activity_item_widget.dart # Widget hiển thị hoạt động & Checkbox
│   │   ├── screens/
│   │   │   └── trip_detail_screen.dart   # Màn hình chính (Nested Lists theo ngày)
│   │   └── main.dart            # Khởi chạy Flutter App
│   └── pubspec.yaml             # Khai báo dependency (http, intl)
├── backend/                     # NestJS Backend
│   ├── src/
│   │   ├── trips/
│   │   │   ├── dto/
│   │   │   │   └── create-trip.dto.ts    # DTO dữ liệu đầu vào
│   │   │   ├── trips.controller.ts       # Controller xử lý các đường dẫn REST API
│   │   │   └── trips.service.ts          # Service lưu trữ & xử lý logic dữ liệu
│   │   ├── app.module.ts
│   │   └── main.ts                       # Khởi chạy NestJS (Bật CORS)
│   └── package.json
└── .gitignore                   # Cấu hình lọc file rác Git
```

---

## 🎯 Tính năng Cốt lõi & Luồng Kiến thức

1. **Countdown Timer (Màn hình/Banner Đếm ngược)**:
   - Tính toán khoảng thời gian còn lại (số ngày, số giờ) từ thời điểm hiện tại đến `startDate` của sự kiện hội ngộ.
   - Giúp luyện tập làm quen với xử lý ngày tháng (`DateTime`) trong Dart.

2. **Quản lý Lịch trình lồng nhau (Nested List Data & UI)**:
   - Một **Chuyến đi (Trip)** chứa danh sách nhiều **Ngày (TripDay)**.
   - Mỗi **Ngày (TripDay)** chứa danh sách các **Hoạt động / Địa điểm (Activity)**.
   - Giúp học viên nắm vững kỹ thuật parse dữ liệu JSON lồng nhau (`fromJson`/`toJson`) và render danh sách lồng trong Flutter UI (`ListView` / `ExpansionTile`).

3. **Quản lý Trạng thái & Đồng bộ Checkbox (State Management & Sync)**:
   - Tích hợp Checkbox tại mỗi địa điểm để đánh dấu "Đã trải nghiệm/Đã hoàn thành".
   - Tương tác Checkbox sẽ cập nhật giao diện tức thì (`setState`) và gửi lệnh REST API (`PATCH`) cập nhật trạng thái lên NestJS backend.

---

## 📋 Chi tiết triển khai Mã nguồn (Proposed Changes)

### 1. NestJS Backend (`backend/`)

- Khởi tạo dự án NestJS.
- **REST API Endpoints**:
  - `GET /api/trips`: Lấy chuyến đi hiện tại (bao gồm lịch trình từng ngày và các địa điểm/hoạt động).
  - `POST /api/trips`: Tạo chuyến đi hội ngộ mới (Tên chuyến đi, Ngày bắt đầu, Ngày kết thúc).
  - `PATCH /api/trips/:tripId/activities/:activityId/toggle`: Đánh dấu checkbox đã hoàn thành / chưa hoàn thành cho địa điểm.
  - `POST /api/trips/:tripId/activities`: Thêm hoạt động/địa điểm mới vào một ngày trong chuyến đi.

### 2. Flutter Frontend (`mobile_app/`)

- Khởi tạo dự án Flutter `mobile_app`.
- Thêm thư viện `http` (gọi API) và `intl` (định dạng ngày giờ) trong `pubspec.yaml`.
- **Mã nguồn Dart (`lib/`)**:
  - `models/trip_model.dart`: Định nghĩa 3 class `Trip`, `TripDay`, `Activity` hỗ trợ parse JSON lồng nhau.
  - `services/trip_service.dart`: Xử lý HTTP request tới `http://10.0.2.2:3000/api/trips`.
  - `widgets/countdown_card.dart`: Hiển thị card đếm ngược tới ngày hội ngộ ("Còn X ngày Y giờ").
  - `widgets/activity_item_widget.dart`: Card hiển thị địa điểm (Thời gian, Tên địa điểm, Mô tả, Checkbox).
  - `screens/trip_detail_screen.dart`: Màn hình giao diện chính chứa Countdown Banner và danh sách các Ngày trải nghiệm (ExpansionTile / Accordion).

### 3. Hướng dẫn Version Control & Git / GitLens trên Android Studio

- Cấu hình file `.gitignore` loại bỏ file build.
- Hướng dẫn 3 bước đưa dự án lên GitHub:
  1. `git init`, `git add .`, `git commit -m "feat: Initial Local Itinerary Planner app"`
  2. Tạo GitHub Repository và liên kết `git remote add origin ...`
  3. Push mã nguồn lên GitHub.
- Hướng dẫn thao tác với Git & công cụ GitLens/Git Blame trên giao diện Android Studio.

---

## 🧪 Kế hoạch Kiểm thử & Xáo lỗi (Verification Plan)

1. **Khởi chạy NestJS Server**:
   - Chạy server tại thư mục `backend/` với lệnh `npm run start:dev`.
   - Kiểm tra API trả về dữ liệu chuyến đi mẫu tại `http://localhost:3000/api/trips`.

2. **Chạy ứng dụng trên Android Emulator Pixel 10**:
   - Khởi chạy Flutter app bằng `flutter run` trong `mobile_app/`.
   - Xác nhận Banner hiển thị chính xác số ngày đếm ngược đến thời điểm hội ngộ.
   - Tích chọn Checkbox trên địa điểm -> Kiểm tra trạng thái UI gạch ngang chữ và đồng bộ lên server.
