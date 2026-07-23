import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common'; 
 
@Injectable() 
export class AuthGuard implements CanActivate { 
  canActivate(context: ExecutionContext): boolean { 
    const request = context.switchToHttp().getRequest(); 
    const userId = request.headers['x-user-id'] || request.query.userId; 
    if (!userId) throw new UnauthorizedException('Missing x-user-id header'); 
    request.user = { id: userId }; 
    return true; 
  } 
} 
