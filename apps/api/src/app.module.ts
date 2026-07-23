import { Module } from '@nestjs/common'; 
import { BillingModule } from './billing/billing.module'; 
import { CommunityModule } from './community/community.module'; 
import { GuidanceModule } from './guidance/guidance.module'; 
import { HealthController } from './health.controller'; 
import { NotificationsModule } from './notifications/notifications.module'; 
import { PrismaModule } from './common/prisma.module'; 
import { ProfilesModule } from './profiles/profiles.module'; 
import { ReflectionsModule } from './reflections/reflections.module'; 
 
@Module({ 
  imports: [PrismaModule, ProfilesModule, GuidanceModule, ReflectionsModule, CommunityModule, NotificationsModule, BillingModule], 
  controllers: [HealthController], 
}) 
export class AppModule {} 
