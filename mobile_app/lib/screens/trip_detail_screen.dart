import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/trip_service.dart';
import '../widgets/countdown_card.dart';
import '../widgets/activity_item_widget.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final TripService _tripService = TripService();
  late Future<Trip> _tripFuture;

  @override
  void initState() {
    super.initState();
    _loadTripData();
  }

  void _loadTripData() {
    setState(() {
      _tripFuture = _tripService.fetchTripDetails('trip-01');
    });
  }

  Future<void> _handleToggleActivity(String tripId, String activityId) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updatedTrip =
          await _tripService.toggleActivityStatus(tripId, activityId);
      setState(() {
        _tripFuture = Future.value(updatedTrip);
      });
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật trạng thái hoạt động!'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật: $e')),
      );
    }
  }

  void _showAddActivityDialog(Trip trip) {
    int selectedDayIndex = trip.days.isNotEmpty ? trip.days.first.dayIndex : 1;
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final timeController = TextEditingController(text: '10:00');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Thêm Địa Điểm / Hoạt Động'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: selectedDayIndex,
                  decoration: const InputDecoration(labelText: 'Chọn Ngày'),
                  items: trip.days.map((day) {
                    return DropdownMenuItem<int>(
                      value: day.dayIndex,
                      child: Text('Ngày ${day.dayIndex}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedDayIndex = val;
                  },
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tên hoạt động/địa điểm (ví dụ: Ăn Phở)',
                  ),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ/Địa điểm',
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Thời gian (ví dụ: 14:00)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(dialogContext);
                try {
                  final updatedTrip = await _tripService.addActivity(
                    tripId: trip.id,
                    dayIndex: selectedDayIndex,
                    title: titleController.text.trim(),
                    location: locationController.text.trim(),
                    time: timeController.text.trim(),
                  );
                  setState(() {
                    _tripFuture = Future.value(updatedTrip);
                  });
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Thêm địa điểm thành công!')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Thất bại: $e')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.explore_outlined, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'Lên Lịch Trải Nghiệm & Hội Ngộ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTripData,
            tooltip: 'Tải lại dữ liệu',
          ),
        ],
      ),
      body: FutureBuilder<Trip>(
        future: _tripFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 12),
                  Text('Đang tải lịch trình từ NestJS Backend...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded,
                        size: 64, color: Colors.orange),
                    const SizedBox(height: 12),
                    const Text(
                      'Chưa kết nối được với NestJS Backend!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadTripData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final trip = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _loadTripData(),
            child: ListView(
              children: [
                // 1. Countdown Widget Banner
                CountdownCard(
                  targetDate: trip.startDate,
                  title: trip.title,
                  location: trip.location,
                ),

                // 2. Section Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        'Danh Sách Lịch Trình Từng Ngày (${trip.days.length} ngày)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Nested List UI (ExpansionTile for each day)
                ...trip.days.map((day) {
                  final completedCount =
                      day.activities.where((a) => a.isCompleted).length;
                  final totalCount = day.activities.length;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: Text(
                            'N${day.dayIndex}',
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          day.dateTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          'Đã hoàn thành $completedCount/$totalCount địa điểm',
                          style: TextStyle(
                            fontSize: 12,
                            color: completedCount == totalCount && totalCount > 0
                                ? Colors.teal
                                : Colors.grey.shade600,
                          ),
                        ),
                        children: [
                          if (day.activities.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Chưa có hoạt động nào trong ngày này',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          else
                            ...day.activities.map((activity) {
                              return ActivityItemWidget(
                                activity: activity,
                                onToggle: (_) => _handleToggleActivity(
                                    trip.id, activity.id),
                              );
                            }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 80), // Padding for FloatingActionButton
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Trip>(
        future: _tripFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _showAddActivityDialog(snapshot.data!),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Thêm địa điểm'),
          );
        },
      ),
    );
  }
}
