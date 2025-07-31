import 'package:flutter/material.dart';
import 'package:kang/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidgetGenerator extends StatelessWidget {
  final NewsResponse response;

  const NewsWidgetGenerator({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: response.articles.length,
      itemBuilder: (context, index) {
        final article = response.articles[index];

        return Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(
                      fontFamily: 'BitcountSingle',
                      letterSpacing: 1.4,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 8),
                if (article.description != null)
                  Text(
                    article.description!,
                    style: TextStyle(
                        fontFamily: 'BitcountSingle',
                        letterSpacing: 1.4,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(Uri.encodeFull(article.url));
                    ;
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch URL')),
                      );
                    }
                  },
                  child: Text(
                    article.url,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
