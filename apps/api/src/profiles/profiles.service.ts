import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class ProfilesService {
  constructor(private readonly db: PrismaService) {}

  async create(dto: any) {
    const userId = crypto.createHash('sha256').update(dto.email.toLowerCase().trim()).digest('hex').substring(0, 24);
    await this.db.user.upsert({ where: { id: userId }, create: { id: userId, email: dto.email.toLowerCase().trim() }, update: { email: dto.email.toLowerCase().trim() } });
    const tz = dto.birthTimezone || 'UTC';
    return this.db.birthProfile.upsert({
      where: { userId },
      create: { userId, birthDateLocal: dto.birthDateLocal, birthTimeLocal: dto.birthTimeLocal, precision: dto.precision, birthTimezone: tz, encryptedPlace: dto.encryptedPlace },
      update: { birthDateLocal: dto.birthDateLocal, birthTimeLocal: dto.birthTimeLocal, precision: dto.precision, birthTimezone: tz, encryptedPlace: dto.encryptedPlace },
    });
  }

  async findByEmail(email: string) {
    const userId = crypto.createHash('sha256').update(email.toLowerCase().trim()).digest('hex').substring(0, 24);
    return this.db.birthProfile.findUnique({ where: { userId } });
  }
}
