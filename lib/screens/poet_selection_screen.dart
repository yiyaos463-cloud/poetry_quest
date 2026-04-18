import 'package:flutter/material.dart';
import 'package:poetry_quest/models/poet.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/screens/poet_detail_screen.dart';
import 'package:poetry_quest/widgets/custom_app_bar.dart';
import 'package:poetry_quest/utils/routes.dart';
import 'package:provider/provider.dart';

class PoetSelectionScreen extends StatelessWidget {
  const PoetSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '诗境 · 寻仙',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, Routes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: poetsData.map((poet) {
            return _buildPoetCard(context, poet);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPoetCard(BuildContext context, Poet poet) {
    return GestureDetector(
      onTap: () {
        Provider.of<GameProvider>(context, listen: false).selectPoet(poet);
        Navigator.pushNamed(context, Routes.poetDetail, arguments: poet);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                poet.imageAsset,
                height: 140,
                fit: BoxFit.contain, // 改为 contain 确保图片完整显示
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    poet.subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: poet.tags
                        .take(2)
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
