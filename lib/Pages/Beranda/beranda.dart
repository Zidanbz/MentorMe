import 'package:flutter/material.dart';
import 'dart:convert';

class BerandaPage extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> learningPaths;
  final Function(int) onTabChange;

  const BerandaPage({
    super.key,
    required this.categories,
    required this.learningPaths,
    required this.onTabChange,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  void _onCardTap(String cardTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage(title: cardTitle)),
    );
  }

  void _onButtonTap(String buttonTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage(title: buttonTitle)),
    );
  }

  Image decodeBase64Image(String base64String) {
    final decodedBytes = base64Decode(base64String);
    return Image.memory(decodedBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BERANDA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Cards and content section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _onButtonTap(category['name']),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  child: Text(
                                    category['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Learning Path',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: widget.learningPaths.length,
                          itemBuilder: (context, index) {
                            final learningPath = widget.learningPaths[index];
                            final picture = learningPath['picture'];

                            return InkWell(
                              onTap: () {
                                // Handle grid item tap
                                widget.onTabChange(1);
                              },
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: picture != null
                                          ? decodeBase64Image(picture)
                                          : const Icon(Icons.image),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        learningPath['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  final String title;

  const NewPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the $title page'),
      ),
    );
  }
}
