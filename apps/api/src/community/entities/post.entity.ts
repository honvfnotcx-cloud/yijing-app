import { createId } from '../../common/ids'; 
export class Post { id: string; userId: string; content: string; moodTag: string; isAnonymous: boolean; createdAt: Date; constructor(p: Partial<Post>) { this.id=createId('po'); Object.assign(this,p); } } 
