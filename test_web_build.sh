#!/bin/bash

echo "================================"
echo "SCToolBox Web 版本测试脚本"
echo "================================"
echo ""

# 检查 Flutter
echo "检查 Flutter 环境..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装"
    exit 1
fi
echo "✅ Flutter 已安装"
echo ""

# 检查依赖
echo "检查项目依赖..."
cd "$(dirname "$0")"
flutter pub get
echo "✅ 依赖检查完成"
echo ""

# 运行代码分析
echo "运行代码分析..."
flutter analyze --no-fatal-infos
if [ $? -eq 0 ]; then
    echo "✅ 代码分析通过"
else
    echo "⚠️  代码分析有警告，但可以继续"
fi
echo ""

# 测试 Web 编译
echo "测试 Web 编译..."
echo "运行: flutter build web --web-renderer canvaskit --release"
echo ""
flutter build web --web-renderer canvaskit --release

if [ $? -eq 0 ]; then
    echo ""
    echo "================================"
    echo "✅ Web 版本构建成功！"
    echo "================================"
    echo ""
    echo "输出目录: build/web/"
    echo ""
    echo "本地测试方法："
    echo "1. 使用 Python: cd build/web && python3 -m http.server 8000"
    echo "2. 使用 PHP: cd build/web && php -S localhost:8000"
    echo "3. 使用 Node.js: cd build/web && npx serve"
    echo ""
    echo "然后访问: http://localhost:8000"
    echo ""
else
    echo ""
    echo "================================"
    echo "❌ Web 版本构建失败"
    echo "================================"
    echo ""
    echo "请检查上面的错误信息"
    exit 1
fi
