import { Injectable, Logger } from '@nestjs/common'; 
import { Cron, CronExpression } from '@nestjs/schedule'; 
import { PrismaService } from '../common/prisma.service'; 
import { GuidanceService } from '../guidance/guidance.service'; 
 
@Injectable() 
export class NotificationScheduler { 
  private readonly logger = new Logger(NotificationScheduler.name); 
 
  constructor( 
    private readonly db: PrismaService, 
    private readonly guidance: GuidanceService, 
  ) {} 

  @Cron(CronExpression.EVERY_5_MINUTES) 
  async processMorningReminders() { 
    this.logger.log('Processing morning reminders...'); 
    const devices = await this.db.device.findMany({ 
      where: { isActive: true }, 
      include: { user: { include: { birthProfile: true } } } 
    }); 
    const now = new Date(); 
    for (const device of devices) { 
      try { 
        const tz = device.timezone || 'UTC'; 
        const hour = parseInt(now.toLocaleString('en-US', { timeZone: tz, hour: 'numeric', hour12: false })); 
        const localDate = now.toLocaleDateString('en-CA', { timeZone: tz }); 
        if (hour < 7 || hour > 8) continue; 
        const existing = await this.db.notificationDelivery.findUnique({ 
          where: { userId_type_localDate: { userId: device.userId, type: 'morning', localDate } } 
        }); 
        if (existing || !device.user.birthProfile) continue;
        const guidance = await this.guidance.getToday(device.userId); 
        if (!guidance) continue; 
        await this.sendPush(device.pushToken, `Today: ${guidance.hexagramName}`, guidance.guidance.substring(0, 120)); 
        await this.db.notificationDelivery.create({ data: { deviceId: device.id, userId: device.userId, type: 'morning', localDate, scheduledAt: now, status: 'sent' } }); 
        this.logger.log(`Morning reminder sent to ${device.userId}`); 
      } catch (err) { 
        this.logger.error(`Morning reminder failed for ${device.id}`, err); 
      } 
    } 
  } 

  @Cron(CronExpression.EVERY_5_MINUTES) 
  async processEveningReminders() { 
    this.logger.log('Processing evening reminders...'); 
    const devices = await this.db.device.findMany({ where: { isActive: true } }); 
    const now = new Date(); 
    for (const device of devices) { 
      try { 
        const tz = device.timezone || 'UTC'; 
        const hour = parseInt(now.toLocaleString('en-US', { timeZone: tz, hour: 'numeric', hour12: false })); 
        const localDate = now.toLocaleDateString('en-CA', { timeZone: tz }); 
        if (hour < 20 || hour > 22) continue; 
        const existing = await this.db.notificationDelivery.findUnique({ 
          where: { userId_type_localDate: { userId: device.userId, type: 'evening', localDate } } 
        }); 
        if (existing) continue;
        await this.sendPush(device.pushToken, 'Evening Reflection', 'How did your daily guidance play out? Take a moment to reflect.'); 
        await this.db.notificationDelivery.create({ data: { deviceId: device.id, userId: device.userId, type: 'evening', localDate, scheduledAt: now, status: 'sent' } }); 
      } catch (err) { 
        this.logger.error(`Evening reminder failed for ${device.id}`, err); 
      } 
    } 
  } 
 
  private async sendPush(token: string, title: string, body: string) { 
    this.logger.log(`Push to ${token.substring(0, 12)}...: ${title}`); 
  } 
}
