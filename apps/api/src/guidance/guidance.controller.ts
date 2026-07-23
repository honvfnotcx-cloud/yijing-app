import { Controller, Get, Query } from '@nestjs/common'; 
import { GuidanceService } from './guidance.service'; 
@Controller('guidance') 
export class GuidanceController { constructor(private service: GuidanceService) {} 
  @Get('today') today(@Query('userId') userId: string) { return this.service.getToday(userId); } 
  @Get('tomorrow') tomorrow(@Query('userId') userId: string) { return this.service.getTomorrow(userId); } 
} 
