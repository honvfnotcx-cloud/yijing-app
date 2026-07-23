import { Controller, Get, Post, Body, Query } from '@nestjs/common'; 
import { ReflectionsService } from './reflections.service'; 
import { CreateReflectionDto } from './dto/create-reflection.dto'; 
 
@Controller('reflections') 
export class ReflectionsController { 
  constructor(private s: ReflectionsService) {} 
 
  @Get() 
  findByUser(@Query('userId') uid: string) { 
    return this.s.findByUser(uid); 
  } 
 
  @Post() 
  create(@Query('userId') uid: string, @Body() dto: CreateReflectionDto) { 
    return this.s.create(uid, dto); 
  } 
}
