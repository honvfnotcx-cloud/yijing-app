import { Injectable, Logger } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
 
@Injectable() 
export class BillingService { 
  private readonly logger = new Logger(BillingService.name); 
  constructor(private readonly db: PrismaService) {} 
 
  async getEntitlement(userId: string) { 
    const ent = await this.db.entitlement.findFirst({ where: { userId }, orderBy: { createdAt: 'desc' } }); 
    return ent ?? { userId, tier: 'free' as const }; 
  }
 
  // App Store Server Notification v2 (StoreKit) 
  async handleAppStoreNotification(signedPayload: string) { 
    this.logger.log('Received App Store notification'); 
    // TODO: Verify JWS signature using Apple root CA 
    // Decode signedPayload to extract notificationType and subtype 
    // Map to: SUBSCRIBED, DID_RENEW, DID_CHANGE_RENEWAL_STATUS, EXPIRED, etc. 
    this.logger.log('App Store webhook acknowledged (verification pending)'); 
  }
 
  // Google Play RTDN (Real-Time Developer Notification) 
  async handlePlayStoreNotification(body: { message: { data: string } }) { 
    this.logger.log('Received Play Store notification'); 
    // TODO: Decode base64-encoded data from body.message.data 
    // Extract subscriptionNotification: notificationType, purchaseToken 
    // Verify purchaseToken with google.androidpublisher API 
    this.logger.log('Play Store webhook acknowledged (verification pending)'); 
  }
 
  async grantEntitlement(userId: string, productId: string, tier: string, expiresAt?: Date) { 
    return this.db.entitlement.create({ data: { userId, productId, tier, expiresAt } }); 
  } 
 
  async recordPurchase(entitlementId: string, platform: string, transactionId: string, productId: string) { 
    return this.db.purchaseEvent.create({ data: { entitlementId, platform, transactionId, productId } }); 
  } 
 
  async revokeEntitlement(userId: string) { 
    return this.db.entitlement.updateMany({ where: { userId }, data: { tier: 'free', expiresAt: new Date() } }); 
  } 
}
