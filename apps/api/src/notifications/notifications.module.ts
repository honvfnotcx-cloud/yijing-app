import { Module } from '@nestjs/common'; 
import { ScheduleModule } from '@nestjs/schedule'; 
import { NotificationsController } from './notifications.controller'; 
import { NotificationsService } from './notifications.service'; 
import { NotificationScheduler } from './notification-scheduler'; 
import { GuidanceModule } from '../guidance/guidance.module'; 
 
@Module({ 
  imports: [ScheduleModule.forRoot(), GuidanceModule], 
  controllers: [NotificationsController], 
  providers: [NotificationsService, NotificationScheduler], 
}) 
export class NotificationsModule {}
