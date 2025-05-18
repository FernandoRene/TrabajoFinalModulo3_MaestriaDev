import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class CopiableTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool showButtons;
  final bool useCard;

  const CopiableTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.showButtons = true,
    this.useCard = false,
  }) : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Texto copiado al portapapeles'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareText(String text) {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copiar texto'),
                  onTap: () {
                    _copyToClipboard(context, text);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir texto'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareText(text);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Text(
        text,
        style: style,
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget,
        if (showButtons) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                tooltip: 'Copiar texto',
                onPressed: () => _copyToClipboard(context, text),
              ),
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                tooltip: 'Compartir texto',
                onPressed: () => _shareText(text),
              ),
            ],
          ),
        ],
      ],
    );

    if (useCard) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      );
    } else {
      return content;
    }
  }
}