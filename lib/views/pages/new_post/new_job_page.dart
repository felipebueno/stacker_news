import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/views/pages/new_post/text_with_preview.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

import 'new_job_footer.dart';

class NewJobPage extends StatefulWidget {
  static const String id = 'new_job';

  const NewJobPage({super.key});

  @override
  State<NewJobPage> createState() => _NewJobPageState();
}

class _NewJobPageState extends State<NewJobPage> {
  bool _remote = false;

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'Job',
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey,
                      child: CachedNetworkImage(
                        imageUrl: '$baseUrl/jobs-default.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Text('Logo'),
                ],
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.image_search,
                    size: 32,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Job Title',
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Company',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Remote'),
              Switch(
                value: _remote,
                onChanged: (bool val) {
                  setState(() {
                    _remote = val;
                  });
                },
              ),
            ],
          ),
          const TextWithPreview(label: 'Description'),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'How to apply',
                hintText: 'URL or email address'),
          ),
          const SizedBox(height: 8),
          const NewJobFooter(),
        ],
      ),
    );
  }
}
