import 'reflect-metadata'; 
import { ValidationPipe } from '@nestjs/common'; 
import { NestFactory } from '@nestjs/core'; 
import { NestExpressApplication } from '@nestjs/platform-express'; 
import { join } from 'path'; 
import { AppModule } from './app.module'; 
 
async function bootstrap(): Promise<void> { 
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { cors: true }); 
  app.setGlobalPrefix('v1'); 
  app.useStaticAssets(join(__dirname, '..', 'public')); 
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true, forbidNonWhitelisted: true })); 
  const port = Number(process.env.PORT ?? 3000); 
  await app.listen(port); 
} 
void bootstrap();
