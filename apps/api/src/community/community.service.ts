import { Injectable } from '@nestjs/common'; 
import { PrismaService } from '../common/prisma.service'; 
 
@Injectable() 
export class CommunityService { 
  constructor(private readonly db: PrismaService) {} 

  async getFeed(page: number = 1, limit: number = 20) { 
    const skip = (page - 1) * limit; 
    const [posts, total] = await Promise.all([ 
      this.db.post.findMany({ 
        where: { isHidden: false }, 
        orderBy: { createdAt: 'desc' }, 
        skip, take: limit, 
        include: { _count: { select: { comments: true } } } 
      }), 
      this.db.post.count({ where: { isHidden: false } }), 
    ]);
    return { posts, total, page, totalPages: Math.ceil(total / limit) }; 
  } 
 
  async createPost(userId: string, dto: { content: string; moodTag?: string; isAnonymous?: boolean }) { 
    return this.db.post.create({ data: { userId, content: dto.content, moodTag: dto.moodTag, isAnonymous: dto.isAnonymous ?? true } }); 
  }
 
  async addComment(userId: string, postId: string, content: string) { 
    return this.db.comment.create({ data: { userId, postId, content } }); 
  } 
 
  async getComments(postId: string, page: number = 1, limit: number = 30) { 
    return this.db.comment.findMany({ where: { postId }, orderBy: { createdAt: 'asc' }, skip: (page - 1) * limit, take: limit }); 
  }
 
  async followUser(followerId: string, followingId: string) { 
    if (followerId === followingId) throw new Error('Cannot follow yourself'); 
    return this.db.follow.upsert({ where: { followerId_followingId: { followerId, followingId } }, create: { followerId, followingId }, update: {} }); 
  } 
 
  async unfollowUser(followerId: string, followingId: string) { 
    return this.db.follow.deleteMany({ where: { followerId, followingId } }); 
  } 
 
  async getFollowers(userId: string) { 
    return this.db.follow.count({ where: { followingId: userId } });
  } 
 
  async getFollowing(userId: string) { 
    return this.db.follow.count({ where: { followerId: userId } }); 
  } 
 
  async blockUser(blockerId: string, blockedId: string) { 
    return this.db.block.create({ data: { blockerId, blockedId } }); 
  } 
 
  async reportPost(reporterId: string, postId: string, reason: string) { 
    return this.db.report.create({ data: { reporterId, postId, reason } }); 
  } 
 
  async hidePost(postId: string) { 
    return this.db.post.update({ where: { id: postId }, data: { isHidden: true } }); 
  } 
}
