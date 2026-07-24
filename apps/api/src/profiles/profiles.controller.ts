import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { CreateBirthProfileDto } from './dto/create-birth-profile.dto';

@Controller('profiles')
export class ProfilesController {
  constructor(private readonly service: ProfilesService) {}
  @Post() create(@Body() dto: CreateBirthProfileDto) { return this.service.create(dto); }
  @Get(':email') findByUser(@Param('email') email: string) { return this.service.findByEmail(email); }
}
