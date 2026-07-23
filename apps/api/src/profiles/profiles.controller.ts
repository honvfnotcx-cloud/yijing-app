import { Controller, Get, Post, Body, Param } from '@nestjs/common'; 
import { ProfilesService } from './profiles.service'; 
import { CreateBirthProfileDto } from './dto/create-birth-profile.dto'; 
 
@Controller('profiles') 
export class ProfilesController { 
  constructor(private readonly service: ProfilesService) {} 
  @Post() create(@Body() dto: CreateBirthProfileDto) { return this.service.create('demo-user', dto); } 
  @Get(':userId') findByUser(@Param('userId') userId: string) { return this.service.findByUser(userId); } 
}
