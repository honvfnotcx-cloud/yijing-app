import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart'; 
 
class ApiService { 
  static const _baseUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/v1'); 
  String? _userId;
 
  Future<String> get userId async { 
    _userId ??= (await SharedPreferences.getInstance()).getString('user_id') ?? 'demo-user'; 
    return _userId!; 
  } 
 
  Future<Map<String, dynamic>?> getTodayGuidance() async { 
    final uid = await userId; final res = await http.get(Uri.parse('$_baseUrl/guidance/today?userId=$uid')); 
    if (res.statusCode == 200) return jsonDecode(res.body); return null; 
  }
 
  Future<List<Map<String, dynamic>>> getFeed({int page = 1, int limit = 20}) async { 
    final res = await http.get(Uri.parse('$_baseUrl/community/feed?page=$page&limit=$limit')); 
    if (res.statusCode == 200) { final data = jsonDecode(res.body); return (data['posts'] as List).cast<Map<String, dynamic>>(); } 
    return []; 
  } 
 
  Future<void> createPost(String content, {String? moodTag, bool isAnonymous = true}) async { 
    final uid = await userId; 
    await http.post(Uri.parse('$_baseUrl/community/posts?userId=$uid'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'content': content, 'moodTag': moodTag, 'isAnonymous': isAnonymous})); 
  } 
 
  Future<void> submitReflection(String mood, String note) async { 
    final uid = await userId; 
    await http.post(Uri.parse('$_baseUrl/reflections?userId=$uid'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'mood': mood, 'note': note})); 
  }
 
  Future<List<Map<String, dynamic>>> getReflections() async { 
    final uid = await userId; final res = await http.get(Uri.parse('$_baseUrl/reflections?userId=$uid')); 
    if (res.statusCode == 200) return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>(); 
    return []; 
  } 
 
  Future<Map<String, dynamic>?> getProfile() async { 
    final uid = await userId; final res = await http.get(Uri.parse('$_baseUrl/profiles/$uid')); 
    if (res.statusCode == 200) return jsonDecode(res.body); return null; 
  } 
 
  Future<void> createProfile(Map<String, dynamic> data) async { 
    await http.post(Uri.parse('$_baseUrl/profiles'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data)); 
  } 
 
  Future<Map<String, dynamic>> getEntitlement() async { 
    final uid = await userId; final res = await http.get(Uri.parse('$_baseUrl/billing/entitlement?userId=$uid')); 
    if (res.statusCode == 200) return jsonDecode(res.body); return {'tier': 'free'}; 
  } 
 
  Future<void> registerDevice(String pushToken, String platform, String timezone) async { 
    final uid = await userId; 
    await http.post(Uri.parse('$_baseUrl/notifications/devices?userId=$uid'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'pushToken': pushToken, 'platform': platform, 'timezone': timezone})); 
  } 
}
