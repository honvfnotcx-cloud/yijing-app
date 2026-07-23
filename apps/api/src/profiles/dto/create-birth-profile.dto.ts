import { IsString, IsIn, IsOptional, IsNumber } from 'class-validator'; 
 
export class CreateBirthProfileDto { 
  @IsString() birthDateLocal: string; 
  @IsString() birthTimeLocal: string; 
  @IsIn(['exact', 'approximate', 'unknown']) precision: string; 
  @IsString() birthTimezone: string; 
  @IsOptional() @IsString() encryptedPlace?: string; 
} 
