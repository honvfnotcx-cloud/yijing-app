import { Injectable } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
 
@Injectable() 
export class ProfilesService { 
  constructor(private readonly db: PrismaService) {} 
 
  async create(userId: string, dto: any) { 
    return this.db.birthProfile.create({ 
      data: { userId, birthDateLocal: dto.birthDateLocal, birthTimeLocal: dto.birthTimeLocal, precision: dto.precision, birthTimezone: dto.birthTimezone, encryptedPlace: dto.encryptedPlace }, 
    }); 
  } 
 
  async findByUser(userId: string) { 
    return this.db.birthProfile.findUnique({ where: { userId } }); 
  } 
} 
