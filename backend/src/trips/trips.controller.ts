import { Controller, Get, Param, Patch, Post, Body } from '@nestjs/common';
import { TripsService, Trip } from './trips.service';

@Controller('api/trips')
export class TripsController {
  constructor(private readonly tripsService: TripsService) {}

  @Get()
  getAllTrips(): Trip[] {
    return this.tripsService.getAllTrips();
  }

  @Get(':id')
  getTripById(@Param('id') id: string): Trip {
    return this.tripsService.getTripById(id);
  }

  @Patch(':tripId/activities/:activityId/toggle')
  toggleActivityStatus(
    @Param('tripId') tripId: string,
    @Param('activityId') activityId: string,
  ): Trip {
    return this.tripsService.toggleActivityStatus(tripId, activityId);
  }

  @Post(':tripId/days/:dayIndex/activities')
  addActivity(
    @Param('tripId') tripId: string,
    @Param('dayIndex') dayIndex: string,
    @Body() body: { time: string; title: string; location: string },
  ): Trip {
    return this.tripsService.addActivity(tripId, parseInt(dayIndex, 10), body);
  }
}
