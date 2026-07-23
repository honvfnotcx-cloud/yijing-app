import { createId } from '../../common/ids'; 
export class Reflection { id: string; userId: string; guidanceId: string; localDate: string; mood: string; note: string; submittedAt: Date; constructor(p: Partial<Reflection>) { this.id = createId('rf'); Object.assign(this, p); } } 
