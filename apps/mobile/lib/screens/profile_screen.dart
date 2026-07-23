import 'package:flutter/material.dart'; 
import '../services/api_service.dart'; 
 
class ProfileScreen extends StatefulWidget { 
  const ProfileScreen({super.key}); 
  @override 
  State<ProfileScreen> createState() => _ProfileScreenState(); 
} 
 
class _ProfileScreenState extends State<ProfileScreen> { 
  Map<String, dynamic>? _profile; 
  Map<String, dynamic> _entitlement = {'tier': 'free'}; 
  bool _loading = true; 
 
  @override void initState() { super.initState(); _loadProfile(); } 
 
  Future<void> _loadProfile() async { 
    setState(() => _loading = true); 
    try { 
      final api = ApiService(); 
      _profile = await api.getProfile(); 
      _entitlement = await api.getEntitlement(); 
    } catch (_) {} 
    setState(() => _loading = false); 
  }
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Scaffold( 
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true), 
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(16), children: [ 
        _buildProfileCard(theme), 
        const SizedBox(height: 16), 
        _buildEntitlementCard(theme), 
        const SizedBox(height: 16), 
        _buildSettingsList(theme), 
      ]), 
    ); 
  }
 
  Widget _buildProfileCard(ThemeData theme) { 
    return Card( 
      elevation: 0, color: theme.colorScheme.primaryContainer.withOpacity(0.3), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
      child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [ 
        CircleAvatar(radius: 36, backgroundColor: theme.colorScheme.primary, child: const Icon(Icons.person, size: 36, color: Colors.white)), 
        const SizedBox(height: 12), 
        if (_profile != null) ...[Text(_profile!['birthDateLocal'] ?? 'Set your birth date', style: theme.textTheme.titleMedium), const SizedBox(height: 4), Text(_profile!['birthTimezone'] ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))], 
        if (_profile == null) Text('Complete your birth profile', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)), 
        const SizedBox(height: 12), 
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: Text(_profile != null ? 'Edit Profile' : 'Create Profile')), 
      ])), 
    ); 
  }
 
  Widget _buildEntitlementCard(ThemeData theme) { 
    final tier = _entitlement['tier'] ?? 'free'; 
    final isPremium = tier == 'premium'; 
    return Card( 
      elevation: 0, color: isPremium ? theme.colorScheme.tertiaryContainer.withOpacity(0.3) : theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isPremium ? theme.colorScheme.tertiary : theme.colorScheme.outlineVariant)), 
      child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [ 
        Icon(isPremium ? Icons.workspace_premium : Icons.star_outline, size: 40, color: isPremium ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant), 
        const SizedBox(width: 16), 
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
          Text(isPremium ? 'Premium Member' : 'Free Plan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)), 
          const SizedBox(height: 4), 
          Text(isPremium ? 'Unlimited access to all features' : 'Upgrade for deeper insights and unlimited history', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)), 
        ])), 
        if (!isPremium) FilledButton(onPressed: () {}, child: const Text('Upgrade')), 
      ])), 
    ); 
  }
 
  Widget _buildSettingsList(ThemeData theme) { 
    return Card( 
      elevation: 0, color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
      child: Column(children: [ 
        ListTile(leading: const Icon(Icons.notifications_outlined), title: const Text('Notifications'), trailing: const Icon(Icons.chevron_right), onTap: () {}), 
        const Divider(height: 1, indent: 56), 
        ListTile(leading: const Icon(Icons.language), title: const Text('Language / Locale'), trailing: const Icon(Icons.chevron_right), onTap: () {}), 
        const Divider(height: 1, indent: 56), 
        ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacy & Data'), trailing: const Icon(Icons.chevron_right), onTap: () {}), 
        const Divider(height: 1, indent: 56), 
        ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & About'), trailing: const Icon(Icons.chevron_right), onTap: () {}), 
      ]), 
    ); 
  } 
}
