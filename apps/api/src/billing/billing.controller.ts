import { Controller, Get, Post, Body, Query } from '@nestjs/common'; 
import { BillingService } from './billing.service'; 
import { PRODUCTS } from './products'; 
 
@Controller('billing') 
export class BillingController { 
  constructor(private s: BillingService) {} 
 
  @Get('products') 
  getProducts() { return PRODUCTS; } 
 
  @Get('entitlement') 
  getEntitlement(@Query('userId') uid: string) { return this.s.getEntitlement(uid); } 
 
  @Post('webhooks/app-store') 
  appStoreWebhook(@Body() body: { signedPayload: string }) { return this.s.handleAppStoreNotification(body.signedPayload); } 
 
  @Post('webhooks/google-play') 
  googlePlayWebhook(@Body() body: { message: { data: string } }) { return this.s.handlePlayStoreNotification(body); } 
}
