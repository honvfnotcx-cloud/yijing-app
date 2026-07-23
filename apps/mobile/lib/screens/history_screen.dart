import 'package:flutter/material.dart'; 
import '../services/api_service.dart'; 
 
class HistoryScreen extends StatefulWidget { 
  const HistoryScreen({super.key}); 
  @override 
  State<HistoryScreen> createState() => _HistoryScreenState(); 
} 
 
class _HistoryScreenState extends State<HistoryScreen> { 
  List<Map<String, dynamic>> _reflections = []; 
  bool _loading = true; 
 
  @override void initState() { super.initState(); _loadHistory(); } 
 
  Future<void> _loadHistory() async { 
    setState(() => _loading = true); 
    try { 
      _reflections = await ApiService().getReflections(); 
    } catch (_) {} 
    setState(() => _loading = false); 
  }
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Scaffold( 
      appBar: AppBar(title: const Text('Reflection History'), centerTitle: true), 
      body: _loading ? const Center(child: CircularProgressIndicator()) : _reflections.isEmpty ? ListView(children: [const SizedBox(height: 100), const Icon(Icons.history, size: 64, color: Colors.grey), const SizedBox(height: 12), Text('No reflections yet', textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)), const SizedBox(height: 8), Text('Your daily reflections will appear here.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))]) : RefreshIndicator(onRefresh: _loadHistory, child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: _reflections.length, itemBuilder: (_, i) => _ReflectionTile(data: _reflections[i], theme: theme))), 
    ); 
  } 
}
 
class _ReflectionTile extends StatelessWidget { 
  final Map<String, dynamic> data; 
  final ThemeData theme; 
  const _ReflectionTile({required this.data, required this.theme}); 
  static const _moodIcons = {'grateful': Icons.favorite, 'hopeful': Icons.sunny, 'neutral': Icons.sentiment_neutral, 'anxious': Icons.thunderstorm, 'confused': Icons.help_outline, 'inspired': Icons.auto_awesome}; 
  @override 
  Widget build(BuildContext context) { 
    final mood = data['mood'] ?? ''; 
    return Card( 
      elevation: 0, margin: const EdgeInsets.only(bottom: 8), 
      color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant)), 
      child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Row(children: [Icon(_moodIcons[mood] ?? Icons.circle, size: 20, color: theme.colorScheme.primary), const SizedBox(width: 8), Text(mood.isNotEmpty ? mood[0].toUpperCase() + mood.substring(1) : 'Unknown', style: theme.textTheme.titleSmall), const Spacer(), Text(data['localDate'] ?? '', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))]), 
        if (data['note'] != null && data['note'].toString().isNotEmpty) ...[const SizedBox(height: 8), Text(data['note'].toString(), style: theme.textTheme.bodyMedium, maxLines: 5, overflow: TextOverflow.ellipsis)], 
      ])), 
    ); 
  } 
}
