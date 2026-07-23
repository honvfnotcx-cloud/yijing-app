import { Injectable } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
 
@Injectable() 
export class NotificationsService { 
  constructor(private readonly db: PrismaService) {} 
 
  async registerDevice(userId: string, dto: any) { 
    return this.db.device.create({ data: { userId, pushToken: dto.pushToken, platform: dto.platform, timezone: dto.timezone } }); 
  } 
} 
