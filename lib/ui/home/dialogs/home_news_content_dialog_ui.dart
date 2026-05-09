import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material;
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html;
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeNewsContentDialogUI extends StatelessWidget {
  static const _gap1em = "\u0000NEWS_GAP_1EM\u0000";
  static const _gap2em = "\u0000NEWS_GAP_2EM\u0000";

  final String title;
  final String author;
  final String pubDate;
  final String tag;
  final String link;
  final String description;
  final List<String> detailedDescription;

  const HomeNewsContentDialogUI({
    super.key,
    required this.title,
    required this.author,
    required this.pubDate,
    required this.tag,
    required this.link,
    required this.description,
    required this.detailedDescription,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildMarkdownContent();
    final size = MediaQuery.of(context).size;

    return Material(
      child: ContentDialog(
        constraints: BoxConstraints(
          maxWidth: size.width * .72,
          maxHeight: size.height * .82,
        ),
        title: Text(title),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * .62),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      if (author.trim().isNotEmpty) _MetaText(author.trim()),
                      if (tag.trim().isNotEmpty) _MetaText(tag.trim()),
                      if (pubDate.trim().isNotEmpty) _MetaText(pubDate.trim()),
                    ],
                  ),
                  if (content.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ..._buildContentWidgets(content),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          if (link.trim().isNotEmpty)
            Button(
              onPressed: () => launchUrlString(link),
              child: const Text("打开原文"),
            ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 2,
                bottom: 2,
              ),
              child: Text(S.current.action_close),
            ),
          ),
        ],
      ),
    );
  }

  String _buildMarkdownContent() {
    final source = detailedDescription
        .where((e) => e.trim().isNotEmpty)
        .join("\n\n");
    final body = source.trim().isNotEmpty ? source : description;
    final markdown = _htmlToMarkdown(body).trim();
    if (markdown.isNotEmpty) return markdown;
    return description.trim();
  }

  String _htmlToMarkdown(String input) {
    if (input.trim().isEmpty) return "";
    final fragment = html.parseFragment(_cleanupNewsHtml(input));
    final buffer = StringBuffer();
    for (final node in fragment.nodes) {
      _writeNode(buffer, node);
    }
    return buffer
        .toString()
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .trim();
  }

  String _cleanupNewsHtml(String input) {
    var htmlText = input;
    htmlText = htmlText.replaceAll(
      RegExp(
        r"""<div\b[^>]*class=["'][^"']*\bvideo_src_wrapper\b[^"']*["'][^>]*>.*?</div>""",
        caseSensitive: false,
        dotAll: true,
      ),
      '<p>贴吧视频需在原帖观看</p>',
    );
    htmlText = htmlText.replaceAll(
      RegExp(
        r'<br\s*/?>\s*作者：.*?<br\s*/?>\s*楼层：.*?楼\s*<br\s*/?>',
        caseSensitive: false,
        dotAll: true,
      ),
      '',
    );
    for (final noise in ['本楼含有高级字体', '来自iPhone客户端', '作者：灬灬G灬灬', '楼层：1楼']) {
      htmlText = htmlText.replaceAll(noise, '');
    }
    htmlText = htmlText.replaceAll(
      RegExp(r'(<br\s*/?>\s*){2,}', caseSensitive: false),
      '<br>',
    );
    htmlText = htmlText.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '<div style="margin-bottom: 1em;"></div>',
    );
    htmlText = htmlText.replaceAll(
      RegExp(
        r"""<div\s+style=["']margin-bottom:\s*1em;?["']\s*>\s*</div>\s*\.\s*<div\s+style=["']margin-bottom:\s*1em;?["']\s*>\s*</div>""",
        caseSensitive: false,
      ),
      '<div style="margin-bottom: 2em;"></div><div style="margin-bottom: 2em;"></div>',
    );
    return htmlText;
  }

  List<Widget> _buildContentWidgets(String content) {
    final widgets = <Widget>[];
    final gapPattern = RegExp(
      '(${RegExp.escape(_gap1em)}|${RegExp.escape(_gap2em)})',
    );
    var cursor = 0;
    for (final match in gapPattern.allMatches(content)) {
      final text = content.substring(cursor, match.start);
      _addContentPart(widgets, text);
      _addContentPart(widgets, match.group(0) ?? "");
      cursor = match.end;
    }
    _addContentPart(widgets, content.substring(cursor));
    return widgets;
  }

  void _addContentPart(List<Widget> widgets, String part) {
    if (part.isEmpty) return;
    if (part == _gap1em) {
      widgets.add(const SizedBox(height: 14));
    } else if (part == _gap2em) {
      widgets.add(const SizedBox(height: 28));
    } else if (part.trim().isNotEmpty) {
      widgets.addAll(makeMarkdownView(part.trim()));
    }
  }

  void _writeNode(StringBuffer buffer, html_dom.Node node) {
    if (node is html_dom.Text) {
      buffer.write(node.text);
      return;
    }
    if (node is! html_dom.Element) return;

    switch (node.localName) {
      case "br":
        buffer.write(_gap1em);
        return;
      case "img":
        final src = node.attributes["src"]?.trim() ?? "";
        if (src.isNotEmpty) {
          buffer.write("\n\n![]($src)\n\n");
        }
        return;
      case "iframe":
        final src = node.attributes["src"]?.trim() ?? "";
        if (src.isNotEmpty) {
          buffer.write("\n\n[播放视频]($src)\n\n");
        }
        return;
      case "h1":
        _writeBlockText(buffer, node, "# ");
        return;
      case "h2":
        _writeBlockText(buffer, node, "## ");
        return;
      case "h3":
        _writeBlockText(buffer, node, "### ");
        return;
      case "a":
        final href = node.attributes["href"]?.trim() ?? "";
        final text = node.text.trim();
        if (href.isNotEmpty && text.isNotEmpty) {
          buffer.write("[$text]($href)");
        } else {
          _writeChildren(buffer, node);
        }
        return;
      case "li":
        buffer.write("\n- ");
        _writeChildren(buffer, node);
        return;
      case "p":
      case "div":
        if (_writeMarginDiv(buffer, node)) return;
        buffer.write("\n");
        _writeChildren(buffer, node);
        buffer.write("\n");
        return;
      case "section":
      case "article":
        buffer.write("\n");
        _writeChildren(buffer, node);
        buffer.write("\n");
        return;
      default:
        _writeChildren(buffer, node);
    }
  }

  void _writeBlockText(
    StringBuffer buffer,
    html_dom.Element node,
    String prefix,
  ) {
    final text = node.text.trim();
    if (text.isEmpty) return;
    buffer.write("\n\n$prefix$text\n\n");
  }

  void _writeChildren(StringBuffer buffer, html_dom.Element node) {
    for (final child in node.nodes) {
      _writeNode(buffer, child);
    }
  }

  bool _writeMarginDiv(StringBuffer buffer, html_dom.Element node) {
    if (node.localName != "div" || node.nodes.isNotEmpty) return false;
    final style = node.attributes["style"]?.toLowerCase() ?? "";
    if (!style.contains("margin-bottom")) return false;
    if (RegExp(r'margin-bottom\s*:\s*2em').hasMatch(style)) {
      buffer.write(_gap2em);
    } else {
      buffer.write(_gap1em);
    }
    return true;
  }
}

class _MetaText extends StatelessWidget {
  final String text;

  const _MetaText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
    );
  }
}
