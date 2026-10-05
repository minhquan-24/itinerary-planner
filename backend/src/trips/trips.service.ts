import { Injectable, NotFoundException } from '@nestjs/common';

export interface Activity {
  id: string;
  time: string;
  title: string;
  location: string;
  isCompleted: boolean;
}

export interface TripDay {
  dayIndex: number;
  dateTitle: string;
  activities: Activity[];
}

export interface Trip {
  id: string;
  title: string;
  startDate: string;
  endDate: string;
  location: string;
  days: TripDay[];
}

@Injectable()
export class TripsService {
  // Mock data in-memory
  private trips: Trip[] = [
    {
      id: 'trip-01',
      title: 'Đón Gia Đình Thăm Hà Nội & Trải Nghiệm Văn Hóa',
      // Start date set to 5 days from now for realistic countdown testing
      startDate: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 8 * 24 * 60 * 60 * 1000).toISOString(),
      location: 'Hà Nội',
      days: [
        {
          dayIndex: 1,
          dateTitle: 'Ngày 1: Đón tại sân bay & Thăm Phố Cổ',
          activities: [
            {
              id: 'act-101',
              time: '09:00',
              title: 'Đón gia đình tại Sân Bảy Nội Bài',
              location: 'Ga đến T1 - Sân Bảy Nội Bài',
              isCompleted: true,
            },
            {
              id: 'act-102',
              time: '12:00',
              title: 'Thưởng thức Phở Bò Thìn Bờ Hồ',
              location: 'Đinh Tiên Hoàng, Q. Hoàn Kiếm',
              isCompleted: true,
            },
            {
              id: 'act-103',
              time: '15:30',
              title: 'Dạo quanh Hồ Gươm & Thưởng thức Kem Tràng Tiền',
              location: 'Phố đi bộ Hoàn Kiếm',
              isCompleted: false,
            },
          ],
        },
        {
          dayIndex: 2,
          dateTitle: 'Ngày 2: Văn Hóa & Di Tích Lịch Sử',
          activities: [
            {
              id: 'act-201',
              time: '08:30',
              title: 'Thăm Văn Miếu Quốc Tử Giám',
              location: '58 Quốc Tử Giám, Đống Đa',
              isCompleted: false,
            },
            {
              id: 'act-202',
              time: '12:30',
              title: 'Ăn trưa Bún Chả Cửa Đông',
              location: '41 Cửa Đông, Q. Hoàn Kiếm',
              isCompleted: false,
            },
            {
              id: 'act-203',
              time: '18:30',
              title: 'Xem Múa Rối Nước Thăng Long',
              location: '57b Đinh Tiên Hoàng',
              isCompleted: false,
            },
          ],
        },
        {
          dayIndex: 3,
          dateTitle: 'Ngày 3: Mua Sắm Quà Quê & Tiễn Gia Đình',
          activities: [
            {
              id: 'act-301',
              time: '09:00',
              title: 'Mua bánh cốm Hàng Than & Trà Búp Thái Nguyên',
              location: 'Phố Hàng Than, Q. Ba Đình',
              isCompleted: false,
            },
            {
              id: 'act-302',
              time: '16:00',
              title: 'Tiễn gia đình ra Sân Bảy Nội Bài',
              location: 'Sân Bảy Nội Bài',
              isCompleted: false,
            },
          ],
        },
      ],
    },
  ];

  getAllTrips(): Trip[] {
    return this.trips;
  }

  getTripById(id: string): Trip {
    const trip = this.trips.find((t) => t.id === id);
    if (!trip) {
      throw new NotFoundException(`Chuyến đi với ID ${id} không tồn tại`);
    }
    return trip;
  }

  toggleActivityStatus(tripId: string, activityId: string): Trip {
    const trip = this.getTripById(tripId);
    let found = false;

    for (const day of trip.days) {
      const act = day.activities.find((a) => a.id === activityId);
      if (act) {
        act.isCompleted = !act.isCompleted;
        found = true;
        break;
      }
    }

    if (!found) {
      throw new NotFoundException(`Hoạt động với ID ${activityId} không tìm thấy`);
    }

    return trip;
  }

  addActivity(
    tripId: string,
    dayIndex: number,
    activityData: { time: string; title: string; location: string },
  ): Trip {
    const trip = this.getTripById(tripId);
    let day = trip.days.find((d) => d.dayIndex === dayIndex);

    if (!day) {
      day = {
        dayIndex,
        dateTitle: `Ngày ${dayIndex}`,
        activities: [],
      };
      trip.days.push(day);
      trip.days.sort((a, b) => a.dayIndex - b.dayIndex);
    }

    const newActivity: Activity = {
      id: `act-${Date.now()}`,
      time: activityData.time || '10:00',
      title: activityData.title,
      location: activityData.location || 'Địa điểm tự do',
      isCompleted: false,
    };

    day.activities.push(newActivity);
    return trip;
  }
}
