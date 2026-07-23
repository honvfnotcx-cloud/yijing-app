import { Injectable } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
 
@Injectable() 
export class ReflectionsService { 
  constructor(private readonly db: PrismaService) {} 
 
  async create(userId: string, dto: { mood: string; note?: string }) { 
    const localDate = new Date().toISOString().split('T')[0]; 
    const guidance = await this.db.dailyGuidance.findUnique({ where: { userId_localDate: { userId, localDate } } }); 
    if (!guidance) throw new Error('No guidance found for today. Please view your daily guidance first.'); 
    return this.db.reflection.upsert({ 
      where: { guidanceId: guidance.id }, 
      create: { userId, guidanceId: guidance.id, localDate, mood: dto.mood, note: dto.note }, 
      update: { mood: dto.mood, note: dto.note }, 
    }); 
  } 
 
  async findByUser(userId: string) { 
    return this.db.reflection.findMany({ where: { userId }, orderBy: { submittedAt: 'desc' }, take: 90 }); 
  } 
}
