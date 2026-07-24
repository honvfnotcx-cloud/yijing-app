import { IsString, IsIn, IsOptional, IsEmail } from 'class-validator';

export class CreateBirthProfileDto {
  @IsEmail() email: string;
  @IsString() birthDateLocal: string;
  @IsString() birthTimeLocal: string;
  @IsIn(['exact', 'approximate', 'unknown']) precision: string;
  @IsString() birthTimezone: string;
  @IsOptional() @IsString() encryptedPlace?: string;
  @IsOptional() @IsString() password?: string;
}
