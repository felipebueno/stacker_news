import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class PdfReaderPage extends StatelessWidget {
  const PdfReaderPage({super.key});

  static const String id = 'pdf_reader';

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String?;

    return GenericPageScaffold(
      moreActions: [
        IconButton(
          onPressed: url == null || url == ''
              ? null
              : () {
                  Share.shareUri(Uri.parse(url));
                },
          icon: const Icon(Icons.share),
        ),
      ],
      body: url == null || url == ''
          ? Container()
          : const PDF(
              fitEachPage: true,
            ).cachedFromUrl(
              url,
              placeholder: (progress) => Center(
                child: Text(
                  'Downloading\n$progress %',
                  textAlign: TextAlign.center,
                ),
              ),
              errorWidget: (error) => Center(child: Text(error.toString())),
            ),
    );
  }
}
