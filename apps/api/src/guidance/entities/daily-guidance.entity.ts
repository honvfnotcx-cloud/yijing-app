import { createId } from '../../common/ids'; 
 
export class DailyGuidance { 
  id: string; userId: string; localDate: string; 
  contentVersion: number; generatedAt: Date; 
  hexagram: string; hexagramName: string; hexagramSymbol: string; 
  theme: string; guidance: string; reflection: string; 
  constructor(p: Partial<DailyGuidance>) { this.id = createId('dg'); Object.assign(this, p); } 
}
