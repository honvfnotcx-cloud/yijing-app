import { Controller, Get, Post, Delete, Body, Query, Param } from '@nestjs/common'; 
import { CommunityService } from './community.service'; 
 
@Controller('community') 
export class CommunityController { 
  constructor(private s: CommunityService) {} 
 
  @Get('feed') feed(@Query('page') page?: string, @Query('limit') limit?: string) { 
    return this.s.getFeed(Number(page) 
  }
 
  @Post('posts') createPost(@Query('userId') uid: string, @Body() dto: any) { 
    return this.s.createPost(uid, dto); 
  } 
 
  @Post('posts/:postId/comments') addComment(@Query('userId') uid: string, @Param('postId') pid: string, @Body() dto: any) { 
    return this.s.addComment(uid, pid, dto.content); 
  } 
 
  @Get('posts/:postId/comments') getComments(@Param('postId') pid: string, @Query('page') page?: string, @Query('limit') limit?: string) { 
    return this.s.getComments(pid, Number(page) 
  }
 
  @Post('follow') follow(@Query('userId') uid: string, @Body() dto: any) { 
    return this.s.followUser(uid, dto.followingId); 
  } 
 
  @Delete('follow') unfollow(@Query('userId') uid: string, @Body() dto: any) { 
    return this.s.unfollowUser(uid, dto.followingId); 
  } 
 
  @Post('block') block(@Query('userId') uid: string, @Body() dto: any) { 
    return this.s.blockUser(uid, dto.blockedId); 
  } 
 
  @Post('report') report(@Query('userId') uid: string, @Body() dto: any) { 
    return this.s.reportPost(uid, dto.postId, dto.reason); 
  } 
}
