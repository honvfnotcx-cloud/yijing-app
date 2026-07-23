import 'package:flutter/material.dart'; 
import '../services/api_service.dart'; 
 
class ReflectScreen extends StatefulWidget { 
  const ReflectScreen({super.key}); 
  @override 
  State<ReflectScreen> createState() => _ReflectScreenState(); 
} 
 
class _ReflectScreenState extends State<ReflectScreen> { 
  final _noteController = TextEditingController(); 
  String _mood = 'neutral'; 
  bool _submitting = false; 
  List<Map<String, dynamic>> _pastReflections = []; 
  bool _loadingHistory = true;
 
  @override void initState() { super.initState(); _loadHistory(); } 
  @override void dispose() { _noteController.dispose(); super.dispose(); } 
 
  Future<void> _loadHistory() async { 
    setState(() => _loadingHistory = true); 
    try { 
      final api = ApiService(); 
      final list = await api.getReflections(); 
      setState(() { _pastReflections = list; _loadingHistory = false; }); 
    } catch (_) { 
      setState(() => _loadingHistory = false); 
    } 
  }
 
  Future<void> _submit() async { 
    if (_noteController.text.trim().isEmpty) return; 
    setState(() => _submitting = true); 
    try { 
      final api = ApiService(); 
      await api.submitReflection(_mood, _noteController.text.trim()); 
      _noteController.clear(); 
      setState(() => _submitting = false); 
      _loadHistory(); 
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reflection saved'))); 
    } catch (e) { 
      setState(() => _submitting = false); 
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); 
    } 
  }
 
  static const _moods = ['grateful', 'hopeful', 'neutral', 'anxious', 'confused', 'inspired']; 
  static const _moodIcons = { 'grateful': Icons.favorite, 'hopeful': Icons.sunny, 'neutral': Icons.sentiment_neutral, 'anxious': Icons.thunderstorm, 'confused': Icons.help_outline, 'inspired': Icons.auto_awesome }; 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Scaffold( 
      appBar: AppBar(title: const Text('Evening Reflection'), centerTitle: true), 
      body: ListView(padding: const EdgeInsets.all(16), children: [ 
        _buildMoodPicker(theme), 
        const SizedBox(height: 16), 
        _buildNoteField(theme), 
        const SizedBox(height: 16), 
        _buildSubmitButton(theme), 
        const SizedBox(height: 32), 
        _buildHistorySection(theme), 
      ]), 
    ); 
  }
 
  Widget _buildMoodPicker(ThemeData theme) { 
    return Card( 
      elevation: 0, color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
      child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Text('How are you feeling?', style: theme.textTheme.titleSmall), 
        const SizedBox(height: 12), 
        Wrap(spacing: 8, runSpacing: 8, children: _moods.map((m) => ChoiceChip( 
          selected: _mood == m, label: Row(mainAxisSize: MainAxisSize.min, children: [Icon(_moodIcons[m], size: 16), const SizedBox(width: 4), Text(m[0].toUpperCase() + m.substring(1))]), 
          onSelected: (_) => setState(() => _mood = m), 
          selectedColor: theme.colorScheme.primaryContainer, 
        )).toList()), 
      ])), 
    ); 
  }
 
  Widget _buildNoteField(ThemeData theme) { 
    return Card( 
      elevation: 0, color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
      child: Padding(padding: const EdgeInsets.all(16), child: TextField(controller: _noteController, maxLines: 5, decoration: const InputDecoration(border: InputBorder.none, hintText: 'What happened today? How did the guidance resonate with your experience?'), style: theme.textTheme.bodyLarge)), 
    ); 
  } 
 
  Widget _buildSubmitButton(ThemeData theme) { 
    return SizedBox(width: double.infinity, child: FilledButton.icon( 
      onPressed: _submitting ? null : _submit, 
      icon: _submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send), 
      label: Text(_submitting ? 'Saving...' : 'Save Reflection'), 
    )); 
  }
 
  Widget _buildHistorySection(ThemeData theme) { 
    if (_loadingHistory) return const Center(child: CircularProgressIndicator()); 
    if (_pastReflections.isEmpty) return Card( 
      elevation: 0, 
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
      child: const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No reflections yet.\nYour first one will appear here.', textAlign: TextAlign.center))), 
    ); 
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
      Text('Recent Reflections', style: theme.textTheme.titleMedium), 
      const SizedBox(height: 8), 
      ..._pastReflections.take(5).map((r) => Card( 
        elevation: 0, margin: const EdgeInsets.only(bottom: 8), 
        color: theme.colorScheme.surface, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
        child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
          Row(children: [Icon(_moodIcons[r['mood']] ?? Icons.circle, size: 16, color: theme.colorScheme.primary), const SizedBox(width: 6), Text(r['mood'] ?? '', style: theme.textTheme.labelMedium), const Spacer(), Text(r['localDate'] ?? '', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))]), 
          if (r['note'] != null && r['note'].toString().isNotEmpty) ...[const SizedBox(height: 8), Text(r['note'].toString(), style: theme.textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis)], 
        ])), 
      )), 
    ]); 
  } 
}
