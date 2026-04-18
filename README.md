# Poetry Quest · 诗境闯关

[![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> 一款通过游戏化闯关方式，让青少年沉浸式学习唐诗的移动应用。  
> **从“旁观者”到“同行者”**——跟随李白走完万里远游的起点。

<p align="center">
  <img src="assets/images/demo_banner.png" alt="Poetry Quest Banner" width="800"/>
</p>

## ✨ 核心亮点

- **🎮 三层难度设计**  
  简单·中等·困难，针对不同认知深度逐层递进，同一首《峨眉山月歌》有三种完全不同的学习体验。

- **🧠 五层认知模型**  
  声韵触境 → 境遇共情 → 意象解码 → 风骨抉择 → 生命联结，对应布鲁姆认知目标，形成完整学习闭环。

- **🤖 AI 诗人对话**  
  集成通义千问 API，可与李白、杜甫、苏轼、李清照实时对话。每位诗人拥有独立人设，回答富有诗意与个性。

- **🏆 游戏化成长系统**  
  闯关赚取积分，解锁“蜀地青衫”“大鹏垂天翼”等主题装扮；收集诗卡，积累知识点总结。

- **📝 社区创作平台**  
  “我要写诗”模块支持用户创作、分享、点赞、评论，构建诗歌爱好者交流社区。

- **⚔️ 挑战模式**  
  随机抽题，限时作答，答对得分，巩固诗词知识。

## 🛠️ 技术架构
poetry_quest/
├── lib/
│ ├── models/ # 数据模型（诗词、诗人、关卡、进度）
│ ├── providers/ # 状态管理（GameProvider）
│ ├── services/ # 服务层（本地存储、AI 对话）
│ ├── screens/ # 全屏界面（首页、闯关、个人中心等）
│ ├── widgets/ # 可复用组件 + 五层递进组件
│ ├── data/ # 三种难度的《峨眉山月歌》关卡数据
│ └── utils/ # 主题、路由配置
├── assets/
│ ├── images/ # 诗人立绘、背景、装备图
│ └── audio/ # 背景音乐、音效、朗读音频
└── pubspec.yaml

- **前端框架**：Flutter 3.12+ (Dart 3.0+)
- **状态管理**：Provider
- **本地存储**：Shared Preferences
- **音频播放**：Audioplayers
- **网络请求**：HTTP (通义千问 API)
- **分享功能**：Share Plus

## 🚀 快速开始

### 环境要求
- Flutter SDK ≥ 3.12.0
- Dart ≥ 3.0.0
- Android Studio / VS Code
- iOS 模拟器或 Android 模拟器（或 Chrome 浏览器）

### 安装运行

1. **克隆仓库**
   ```bash
   git clone https://github.com/yiyaos463-cloud/poetry_quest.git
   cd poetry_quest
获取依赖

bash
flutter pub get
配置 API Key
在 lib/services/ai_service.dart 中，将 _apiKey 替换为你自己的通义千问 API Key。

dart
static const String _apiKey = 'sk-你的API-Key';
运行项目

bash
flutter run -d chrome   # Web 端运行
# 或
flutter run -d <device_id>   # 真机/模拟器
📂 资源说明
目录	内容
assets/images/emei/	《峨眉山月歌》背景长卷、李白乘舟、柳枝等素材
assets/images/outfits/	七件李白主题装扮图片
assets/audio/	背景音乐 (hard_bgm.mp3, medium_journey_bgm.mp3)、音效 (correct.mp3, incorrect.mp3)、朗读 (emei_poem.mp3)
图片资源可通过 AI 绘图工具生成，提示词已整理在项目文档中。

🎓 教育理念
认知脚手架：五层设计对应布鲁姆认知目标，逐步撤除支架。

游戏化学习：积分、徽章、排行榜（PBL）模型，激发内在动机。

社会建构主义：社区互动促进知识共建，AI 对话提供个性化支架。

心流体验：挑战与技能平衡的难度设计。

🤝 贡献
欢迎提交 Issue 或 Pull Request！
如需扩展新诗人、新诗词，请参考 lib/data/ 中的关卡数据结构。

📄 许可证
本项目采用 MIT License。

Made with ❤️ for poetry lovers.

### 使用说明

1. **替换截图**：在项目根目录创建 `screenshots/` 文件夹，放入你的 App 界面截图，并确保文件名与 `README.md` 中的引用一致（或自行修改路径）。
2. **添加 Banner 图**（可选）：在 `assets/images/` 中放置一张 `demo_banner.png`，作为顶部展示图。
3. **提交推送**：
   ```bash
   git add README.md
   git commit -m "Add professional README"
   git push
