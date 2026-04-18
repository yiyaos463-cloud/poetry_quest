import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // 通义千问 DashScope API 配置
  // 兼容 OpenAI 格式的国际端点（新加坡）
  static const String _baseUrl = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';

  // TODO: 请在此处填入你从阿里云百炼平台获取的 API Key (以 sk- 开头)
  static const String _apiKey = 'sk-8512e64e97024b5e9697de18b114cf6a';

  // 默认使用的千问模型
  static const String _defaultModel = 'qwen-plus';

  // 存储对话历史
  final List<Map<String, String>> _conversationHistory = [];

  // 诗人风格提示词配置
  static const Map<String, String> _poetStyles = {
    'libai': '李白是唐代伟大诗人，被誉为“诗仙”。他性格豪放飘逸，热爱自由，酷爱饮酒，游历名山大川。他的诗歌想象丰富，语言流转自然，表现出浪漫主义风格。请以李白的口吻和风格回应用户，回答要富有诗意，可适当引用或化用李白的名句。',
    'dufu': '杜甫是唐代伟大诗人，被誉为“诗圣”。他性格忧国忧民，关注百姓疾苦，诗歌风格沉郁顿挫。他的诗歌深刻反映社会现实，被称为“诗史”。请以杜甫的口吻和风格回应用户，回答要体现对家国和民生的关切。',
    'sushi': '苏轼是北宋著名文学家、书法家、画家，号东坡居士。他性格旷达超然，乐观豁达，虽几经贬谪却始终保持积极心态。他的诗词题材广阔，清新豪健。请以苏轼的口吻和风格回应用户，回答要展现出一种豁达与通透。',
    'liqingzhao': '李清照是宋代女词人，号易安居士。她是婉约词派代表，前期词作清新婉约，后期词作悲叹身世，语言清丽。请以李清照的口吻和风格回应用户，回答要细腻、含蓄，富有才情。',
  };

  /// 获取指定诗人的系统提示词
  static String getPoetSystemPrompt(String poetId) {
    return _poetStyles[poetId] ?? '你是一位中国古代诗人，请以诗人的口吻回应用户。';
  }

  /// 与诗人对话
  Future<String> chatWithPoet({
    required String poetId,
    required String userMessage,
    String model = _defaultModel,
  }) async {
    try {
      // 构建系统提示词
      final systemPrompt = getPoetSystemPrompt(poetId);

      // 构建消息列表
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': systemPrompt},
        ..._conversationHistory,
        {'role': 'user', 'content': userMessage},
      ];

      // 发送请求
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String? ?? '诗人沉默不语...';
        
        // 将本轮对话存入历史
        _conversationHistory.add({'role': 'user', 'content': userMessage});
        _conversationHistory.add({'role': 'assistant', 'content': reply});
        
        return reply;
      } else if (response.statusCode == 401) {
        return '与诗人缘悭一面... (API Key 无效或已过期，请检查密钥)';
      } else if (response.statusCode == 429) {
        return '拜访诗人的游客太多了，请稍后再来... (请求过于频繁，触发限流)';
      } else {
        return '诗人此刻正在神游天外... (请求失败: ${response.statusCode})';
      }
    } catch (e) {
      return '山高路远，音信难通... (网络请求失败: $e)';
    }
  }

  /// 清空对话历史 (切换诗人时调用)
  void clearHistory() {
    _conversationHistory.clear();
  }
}