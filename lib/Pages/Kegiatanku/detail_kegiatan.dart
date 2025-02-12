import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mentorme/global/global.dart';

class DetailKegiatan extends StatelessWidget {
  final String activityId;
  DetailKegiatan({Key? key, required this.activityId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchActivityDetails() async {
    if (activityId.isEmpty) {
      print("Error: activityId is null or empty!");
      throw Exception("Invalid activity ID");
    }
    try {
      print('Fetching details for activity ID: $activityId');
      final response = await http.get(
        Uri.parse(
            'https://widgets-catb7yz54a-uc.a.run.app/api/my/activity/$activityId'),
        headers: {
          'Authorization': 'Bearer $currentUserToken', // Jika perlu
          'Content-Type': 'application/json',
        },
      );
      print('Raw API Response: ${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['data'] != null) {
          return responseData['data'];
        } else {
          print("Error: Data is null or malformed");
          throw Exception("Invalid response format");
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load activity details');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load activity details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kegiatan'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchActivityDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load activity details'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final activityDetails = snapshot.data!;
          final fullName = activityDetails['fullName'] ?? 'N/A';
          final materialName = activityDetails['materialName'] ?? 'N/A';
          final trainActivities = activityDetails['train'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Mentor: $fullName',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Materi: $materialName',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Aktivitas:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: trainActivities.length,
                    itemBuilder: (context, index) {
                      final activity = trainActivities[index]['trainActivity'];
                      final meeting = activity['meeting'] ?? 'N/A';
                      final syllabus =
                          activity['materialNameSyllabus'] ?? 'N/A';
                      final status = activity['status'] ?? false;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meeting,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text('Materi: $syllabus'),
                              SizedBox(height: 5),
                              Text(
                                  'Status: ${status ? "Selesai" : "Belum Selesai"}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
