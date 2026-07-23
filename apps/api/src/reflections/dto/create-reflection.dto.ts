import { IsString, IsOptional } from 'class-validator'; 
export class CreateReflectionDto { @IsString() mood: string; @IsOptional() @IsString() note?: string; } 
