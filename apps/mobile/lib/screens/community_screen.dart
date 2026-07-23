import 'package:flutter/material.dart'; 
import '../services/api_service.dart'; 
 
class CommunityScreen extends StatefulWidget { 
  const CommunityScreen({super.key}); 
  @override 
  State<CommunityScreen> createState() => _CommunityScreenState(); 
} 
 
class _CommunityScreenState extends State<CommunityScreen> { 
  List<Map<String, dynamic>> _posts = []; 
  bool _loading = true; 
  final _contentCtrl = TextEditingController(); 
  bool _isAnonymous = true; 
  int _page = 1; 
  bool _hasMore = true;
 
  @override void initState() { super.initState(); _loadFeed(); } 
  @override void dispose() { _contentCtrl.dispose(); super.dispose(); } 
 
  Future<void> _loadFeed({bool refresh = false}) async { 
    if (refresh) { _page = 1; _hasMore = true; } 
    setState(() => _loading = true); 
    try { 
      final api = ApiService(); 
      final result = await api.getFeed(page: _page); 
      setState(() { 
        if (refresh) { _posts = result; } else { _posts.addAll(result); } 
        _hasMore = result.length >= 20; 
        _loading = false; 
      }); 
    } catch (_) { 
      setState(() => _loading = false); 
    } 
  }
 
  Future<void> _createPost() async { 
    if (_contentCtrl.text.trim().isEmpty) return; 
    try { 
      await ApiService().createPost(_contentCtrl.text.trim(), isAnonymous: _isAnonymous); 
      _contentCtrl.clear(); 
      _loadFeed(refresh: true); 
    } catch (_) {} 
  }
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Scaffold( 
      appBar: AppBar(title: const Text('Community'), centerTitle: true), 
      body: Column(children: [ 
        _buildComposer(theme), 
        const Divider(height: 1), 
        Expanded(child: _buildFeed(theme)), 
      ]), 
    ); 
  }
 
  Widget _buildComposer(ThemeData theme) { 
    return Padding(padding: const EdgeInsets.all(12), child: Row(children: [ 
      Expanded(child: TextField(controller: _contentCtrl, maxLines: 2, minLines: 1, decoration: InputDecoration(hintText: 'Share your thoughts...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [ 
        IconButton(icon: Icon(_isAnonymous ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _isAnonymous = !_isAnonymous), tooltip: _isAnonymous ? 'Anonymous' : 'Visible'), 
        IconButton(icon: const Icon(Icons.send, size: 18), onPressed: _createPost), 
      ])))), 
    ])); 
  }
 
  Widget _buildFeed(ThemeData theme) { 
    if (_loading && _posts.isEmpty) return const Center(child: CircularProgressIndicator()); 
    if (_posts.isEmpty) return ListView(children: [const SizedBox(height: 100), const Icon(Icons.forum_outlined, size: 64, color: Colors.grey), const SizedBox(height: 12), Text('No posts yet', textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)), const SizedBox(height: 8), Text('Be the first to share!', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))]); 
    return RefreshIndicator(onRefresh: () => _loadFeed(refresh: true), child: ListView.builder(itemCount: _posts.length + (_hasMore ? 1 : 0), itemBuilder: (_, i) { 
      if (i >= _posts.length) { 
        if (!_loading) _page++; _loadFeed(); 
        return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())); 
      } 
      return _PostCard(post: _posts[i], theme: theme); 
    })); 
  }
} 
 
class _PostCard extends StatelessWidget { 
  final Map<String, dynamic> post; 
  final ThemeData theme; 
  const _PostCard({required this.post, required this.theme}); 
  @override 
  Widget build(BuildContext context) { 
    final commentCount = post['_count']?['comments'] ?? 0; 
    return Card( 
      elevation: 0, margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), 
      color: theme.colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))), 
      child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Row(children: [CircleAvatar(radius: 14, child: Text((post['isAnonymous'] == true ? 'A' : 'U'), style: const TextStyle(fontSize: 12))), const SizedBox(width: 8), Text(post['isAnonymous'] == true ? 'Anonymous' : 'User', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)), const Spacer(), if (post['moodTag'] != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(8)), child: Text(post['moodTag'], style: theme.textTheme.labelSmall))]), 
        const SizedBox(height: 8), 
        Text(post['content'] ?? '', style: theme.textTheme.bodyLarge), 
        const SizedBox(height: 8), 
        Row(children: [Icon(Icons.chat_bubble_outline, size: 16, color: theme.colorScheme.onSurfaceVariant), const SizedBox(width: 4), Text('$commentCount', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)), const Spacer(), Text(_formatTime(post['createdAt']), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))]), 
      ])), 
    ); 
  }
 
  static String _formatTime(String? iso) { 
    if (iso == null) return ''; 
    try { 
      final dt = DateTime.parse(iso); 
      final now = DateTime.now(); 
      final diff = now.difference(dt); 
      if (diff.inMinutes < 1) return 'just now'; 
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago'; 
      if (diff.inHours < 24) return '${diff.inHours}h ago'; 
      return '${diff.inDays}d ago'; 
    } catch (_) { return ''; } 
  } 
}
