import 'package:flutter/material.dart'; 
import '../services/api_service.dart'; 
 
class TodayScreen extends StatefulWidget { 
  const TodayScreen({super.key}); 
  @override 
  State<TodayScreen> createState() => _TodayScreenState(); 
}
 
class _TodayScreenState extends State<TodayScreen> { 
  Map<String, dynamic>? _guidance; 
  bool _loading = true; 
  String? _error; 
 
  @override 
  void initState() { 
    super.initState(); 
    _loadGuidance(); 
  }
 
  Future<void> _loadGuidance() async { 
    setState(() { _loading = true; _error = null; }); 
    try { 
      final api = ApiService(); 
      final result = await api.getTodayGuidance(); 
      setState(() { _guidance = result; _loading = false; }); 
    } catch (e) { 
      setState(() { _error = e.toString(); _loading = false; }); 
    } 
  }
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Daily I Ching'), 
        centerTitle: true, 
      ), 
      body: RefreshIndicator( 
        onRefresh: _loadGuidance, 
        child: _buildBody(theme), 
      ), 
    ); 
  }
 
  Widget _buildBody(ThemeData theme) { 
    if (_loading) { 
      return const Center(child: CircularProgressIndicator()); 
    } 
    if (_error != null) { 
      return _buildError(theme); 
    } 
    if (_guidance == null) { 
      return _buildEmpty(theme); 
    } 
    return _buildGuidanceCard(theme); 
  }
 
  Widget _buildError(ThemeData theme) { 
    return ListView( 
      padding: const EdgeInsets.all(32), 
      children: [ 
        const SizedBox(height: 80), 
        Icon(Icons.cloud_off, size: 64, color: theme.colorScheme.error), 
        const SizedBox(height: 16), 
        Text('Unable to load guidance', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall), 
        const SizedBox(height: 8), 
        Text(_error!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)), 
        const SizedBox(height: 24), 
        Center(child: FilledButton.icon(onPressed: _loadGuidance, icon: const Icon(Icons.refresh), label: const Text('Retry'))), 
      ], 
    ); 
  }
 
  Widget _buildEmpty(ThemeData theme) { 
    return ListView( 
      padding: const EdgeInsets.all(32), 
      children: [ 
        const SizedBox(height: 80), 
        Icon(Icons.person_add, size: 64, color: theme.colorScheme.primary), 
        const SizedBox(height: 16), 
        Text('Set Up Your Profile', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall), 
        const SizedBox(height: 8), 
        Text('Enter your birth date and time to receive your daily I Ching guidance.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)), 
        const SizedBox(height: 24), 
        Center(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Create Profile'))), 
      ], 
    ); 
  }
 
  Widget _buildGuidanceCard(ThemeData theme) { 
    final g = _guidance!; 
    final today = DateTime.now(); 
    final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}'; 
    return ListView( 
      padding: const EdgeInsets.all(16), 
      children: [ 
        Text(dateStr, textAlign: TextAlign.center, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)), 
        const SizedBox(height: 16), 
        _HexagramHeader(g: g, theme: theme), 
        const SizedBox(height: 20), 
        _GuidanceContent(g: g, theme: theme), 
        const SizedBox(height: 20), 
        _ReflectionPrompt(g: g, theme: theme), 
      ], 
    ); 
  } 
}
 
class _HexagramHeader extends StatelessWidget { 
  final Map<String, dynamic> g; 
  final ThemeData theme; 
  const _HexagramHeader({required this.g, required this.theme}); 
  @override 
  Widget build(BuildContext context) { 
    return Card( 
      elevation: 0, 
      color: theme.colorScheme.primaryContainer.withOpacity(0.3), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
      child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [ 
        Text(g['hexagramSymbol'] ?? '', style: const TextStyle(fontSize: 48)), 
        const SizedBox(height: 12), 
        Text('Hexagram ${g['hexagram']}', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)), 
        const SizedBox(height: 4), 
        Text(g['hexagramName'] ?? '', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), 
        const SizedBox(height: 8), 
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(g['theme'] ?? '', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary))), 
      ])), 
    ); 
  } 
}
 
class _GuidanceContent extends StatelessWidget { 
  final Map<String, dynamic> g; 
  final ThemeData theme; 
  const _GuidanceContent({required this.g, required this.theme}); 
  @override 
  Widget build(BuildContext context) { 
    return Card( 
      elevation: 0, 
      color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
      child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Row(children: [Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20), const SizedBox(width: 8), Text('Today\'s Guidance', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))]), 
        const SizedBox(height: 12), 
        Text(g['guidance'] ?? '', style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)), 
      ])), 
    ); 
  } 
}
 
class _ReflectionPrompt extends StatelessWidget { 
  final Map<String, dynamic> g; 
  final ThemeData theme; 
  const _ReflectionPrompt({required this.g, required this.theme}); 
  @override 
  Widget build(BuildContext context) { 
    return Card( 
      elevation: 0, 
      color: theme.colorScheme.tertiaryContainer.withOpacity(0.3), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
      child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Row(children: [Icon(Icons.psychology_outlined, color: theme.colorScheme.tertiary, size: 20), const SizedBox(width: 8), Text('Reflection', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.tertiary))]), 
        const SizedBox(height: 12), 
        Text(g['reflectionQuestion'] ?? '', style: theme.textTheme.bodyLarge?.copyWith(height: 1.6, fontStyle: FontStyle.italic)), 
        const SizedBox(height: 16), 
        Align(alignment: Alignment.centerRight, child: FilledButton.tonalIcon(icon: const Icon(Icons.edit_note, size: 18), label: const Text('Reflect Now'), onPressed: () {})), 
      ])), 
    ); 
  } 
}
