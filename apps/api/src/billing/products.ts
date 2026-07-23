export const PRODUCTS = { 
  'premium_monthly': { id: 'premium_monthly', tier: 'premium', name: 'Premium Monthly', price: '$4.99', period: 'month', features: ['Unlimited history', 'Deeper daily insights', 'Priority community features', 'Ad-free experience'] }, 
  'premium_yearly': { id: 'premium_yearly', tier: 'premium', name: 'Premium Yearly', price: '$39.99', period: 'year', features: ['All monthly features', 'Save 33%', 'Annual I Ching life reading'] }, 
  'premium_lifetime': { id: 'premium_lifetime', tier: 'premium', name: 'Premium Lifetime', price: '$99.99', period: 'lifetime', features: ['All yearly features', 'One-time payment', 'Lifetime access and updates'] }, 
}; 
 
export type ProductId = keyof typeof PRODUCTS;
