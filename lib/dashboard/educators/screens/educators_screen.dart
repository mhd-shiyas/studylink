import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class EducatorsScreen extends StatelessWidget {
  final List<Map<String, String>> educators = [
    {
      "name": "Name",
      "subject": "English",
      "image":
          "https://via.placeholder.com/150" // Replace with actual image URL
    },
    {
      "name": "Name",
      "subject": "Maths",
      "image":
          "https://via.placeholder.com/150" // Replace with actual image URL
    },
    {
      "name": "Name",
      "subject": "DM",
      "image":
          "https://via.placeholder.com/150" // Replace with actual image URL
    },
    {
      "name": "Name",
      "subject": "Fundamental",
      "image":
          "https://via.placeholder.com/150" // Replace with actual image URL
    },
    {
      "name": "Name",
      "subject": "BCA",
      "image":
          "https://via.placeholder.com/150" // Replace with actual image URL
    },
  ];

  EducatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: "Note",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Educators',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: educators.length,
                itemBuilder: (context, index) {
                  final educator = educators[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(educator["image"]!),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  educator["name"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Department of BCA\nSubject: ${educator["subject"]}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
