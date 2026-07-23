import { Module } from '@nestjs/common'; 
import { GuidanceController } from './guidance.controller'; 
import { GuidanceService } from './guidance.service'; 
import { ProfilesModule } from '../profiles/profiles.module'; 
@Module({ imports: [ProfilesModule], controllers: [GuidanceController], providers: [GuidanceService], exports: [GuidanceService] }) 
export class GuidanceModule {} 
