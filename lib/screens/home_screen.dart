import 'package:flutter/material.dart';
import 'package:poetry_quest/models/poet.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/screens/poet_detail_screen.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
              const Color(0xFFF5F0E6),
              const Color(0xFFE8DFD0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 标题
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildHeader(),
              ),
              const SizedBox(height: 20),
              // 诗人选择 - 网格布局 (2个一行)
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildPoetGrid(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.inkColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.auto_stories,
              size: 35,
              color: AppTheme.inkColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '诗境闯关',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.inkColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '与诗人共情，深入理解诗意',
            style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPoetGrid() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: poetsData.length,
            itemBuilder: (context, index) {
              return _PoetCard(
                poet: poetsData[index],
                index: index,
              );
            },
          ),
        ),
        // 底部渐变指示器，提示可滚动
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFFE8DFD0).withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PoetCard extends StatefulWidget {
  final Poet poet;
  final int index;

  const _PoetCard({
    required this.poet,
    required this.index,
  });

  @override
  State<_PoetCard> createState() => _PoetCardState();
}

class _PoetCardState extends State<_PoetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getPoetColor(String poetId) {
    switch (poetId) {
      case 'libai':
        return const Color(0xFF5C6BC0);
      case 'dufu':
        return const Color(0xFF8D6E63);
      case 'sushi':
        return const Color(0xFF26A69A);
      case 'liqingzhao':
        return const Color(0xFFEC407A);
      default:
        return AppTheme.accentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPoetColor(widget.poet.id);
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        _onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // 诗人图片
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    color: color.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      widget.poet.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person,
                        size: 60,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              // 诗人信息
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      widget.poet.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.inkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.poet.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.poet.tags.join(' · '),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.lightInkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: const Text(
                        '开始闯关',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    Provider.of<GameProvider>(context, listen: false).selectPoet(widget.poet);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoetDetailScreen(poet: widget.poet),
      ),
    );
  }
}