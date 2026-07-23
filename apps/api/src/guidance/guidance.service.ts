import { Injectable } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
import { generateGuidance, GuidanceResult } from './engine/yijing-engine'; 
import { localDateForTimeZone } from '../common/dates'; 
 
@Injectable() 
export class GuidanceService { 
  constructor(private readonly db: PrismaService) {} 
 
  async getToday(userId: string): Promise<GuidanceResult | null> { 
    const profile = await this.db.birthProfile.findUnique({ where: { userId } }); 
    if (!profile) return null; 
    const today = localDateForTimeZone(profile.birthTimezone); 
    const existing = await this.db.dailyGuidance.findUnique({ where: { userId_localDate: { userId, localDate: today } } }); 
    if (existing) return { hexagram: existing.hexagram, hexagramName: existing.hexagramName, hexagramSymbol: existing.hexagramSymbol, theme: existing.theme, guidance: existing.guidance, reflectionQuestion: existing.reflectionQuestion }; 
    const result = generateGuidance(profile.birthDateLocal, today); 
    await this.db.dailyGuidance.create({ data: { userId, localDate: today, ...result, contentVersion: 1 } }); 
    return result; 
  } 
 
  async getTomorrow(userId: string): Promise<GuidanceResult | null> { 
    const profile = await this.db.birthProfile.findUnique({ where: { userId } }); 
    if (!profile) return null; 
    const tomorrow = localDateForTimeZone(profile.birthTimezone); 
    const result = generateGuidance(profile.birthDateLocal, tomorrow + 'T12:00:00'); 
    return result; 
  } 
} 
