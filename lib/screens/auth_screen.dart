import 'package:flutter/material.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/services/storage_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final provider = Provider.of<GameProvider>(context, listen: false);
    String? error;
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    print('=== 开始认证 ===');
    print('用户名: $username');
    print('密码长度: ${password.length}');
    print('模式: ${_isLogin ? "登录" : "注册"}');

    if (_isLogin) {
      error = await provider.login(username, password);
    } else {
      error = await provider.register(username, password);
    }

    setState(() => _isLoading = false);

    if (error != null) {
      print('认证失败: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.accentColor),
      );
    } else {
      print('认证成功，用户: ${provider.currentUsername}');
      // 登录成功后合并游客写作数据
      final pending = provider.pendingGuestWritings;
      if (pending.isNotEmpty) {
        await provider.mergeGuestWritings();
      }
      Navigator.pop(context);
    }
  }

  Future<void> _debugClearStorage() async {
    await StorageService.clearAll();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ 存储已清空，请重新注册')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.paperColor,
              AppTheme.lightInkColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 80, color: AppTheme.inkColor),
                  const SizedBox(height: 16),
                  Text(
                    'Poetry Quest',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('诗境闯关', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 48),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              _isLogin ? '登录' : '注册',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: '账号',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? '请输入账号' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: '密码',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return '请输入密码';
                                if (!_isLogin && v.length < 4) return '密码至少4位';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(_isLogin ? '登录' : '注册'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _isLogin = !_isLogin),
                              child: Text(_isLogin ? '没有账号？去注册' : '已有账号？去登录'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onLongPress: _debugClearStorage,
                    child: Container(height: 30, color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
