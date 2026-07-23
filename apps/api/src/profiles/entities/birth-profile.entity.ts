import { createId } from '../../common/ids'; 
 
export class BirthProfile { 
  id: string; userId: string; birthDateLocal: string; birthTimeLocal: string; 
  precision: 'exact' | 'approximate' | 'unknown'; birthTimezone: string; 
  encryptedPlace: string; engineVersion: number; createdAt: Date; updatedAt: Date; 
  constructor(partial: Partial<BirthProfile>) { this.id = createId('bp'); Object.assign(this, partial); } 
} 
