import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:mentorme/Pages/Konsultasi/roomchat.dart';
import 'package:mentorme/global/global.dart';

class DetailKegiatan extends StatefulWidget {
  final String activityId;
  DetailKegiatan({Key? key, required this.activityId}) : super(key: key);

  @override
  State<DetailKegiatan> createState() => _DetailKegiatanState();
}

class _DetailKegiatanState extends State<DetailKegiatan> {
  int _selectedIndex = 0; // Mulai dengan tidak ada yang dipilih
  late Future<Map<String, dynamic>> _activityFuture;

  @override
  void initState() {
    super.initState();
    print("Masuk ke DetailKegiatan dengan ID: ${widget.activityId}");
    _activityFuture = _fetchActivityDetails();
  }

  void _onBottomNavTap(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akhiri Course')),
      );
    } else if (index == 1) {
      try {
        final activityDetails = await _fetchActivityDetails();
        final mentorEmail = activityDetails['mentor']; // sesuaikan key-nya

        if (mentorEmail != null && mentorEmail.isNotEmpty) {
          _startChatWithMentor(mentorEmail);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email mentor tidak tersedia')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data aktivitas: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchActivityDetails() async {
    if (widget.activityId.isEmpty) {
      throw Exception("Invalid activity ID");
    }
    try {
      final response = await http.get(
        Uri.parse(
            'https://widgets-catb7yz54a-uc.a.run.app/api/my/activity/${widget.activityId}'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 && responseData.containsKey('data')) {
        return responseData['data'];
      } else {
        throw Exception('Failed to load activity details');
      }
    } catch (e) {
      throw Exception('Failed to load activity details: $e');
    }
  }

  Future<void> _startChatWithMentor(String emailMentor) async {
    try {
      // Step 1: GET history chat
      final historyResponse = await http.get(
        Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/chat'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      final historyData = json.decode(historyResponse.body);
      print(historyResponse);
      if (historyResponse.statusCode == 200 && historyData['data'] != null) {
        final chats = historyData['data'] as List<dynamic>;

        // Cek apakah sudah ada room dengan email mentor ini
        final existingRoom = chats.firstWhere(
          (chat) => chat['emailMentor'] == emailMentor,
          orElse: () => null,
        );

        if (existingRoom != null) {
          final idRoom = existingRoom['idRoom'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomchatPage(
                  roomId: idRoom,
                  currentUserName: '',
                  currentUserEmail: '',
                  currentUserRole: ''),
            ),
          );
          return;
        }
      }

      // Step 2: Kalau belum ada → POST buat chat baru
      final postResponse = await http.post(
        Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/chat'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': emailMentor}),
      );

      final postData = json.decode(postResponse.body);

      if ((postResponse.statusCode == 200 || postResponse.statusCode == 201) &&
          postData['data'] != null) {
        final idRoom = postData['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomchatPage(
                roomId: idRoom,
                currentUserName: '',
                currentUserEmail: '',
                currentUserRole: ''),
          ),
        );
      } else {
        throw Exception(postData['error'] ?? 'Gagal memulai chat baru');
      }
    } catch (e) {
      print('Error starting chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat chat: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelajaranku', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final activityDetails = snapshot.data!;
          final fullName = activityDetails['fullName'] ?? 'N/A';
          final materialName = activityDetails['materialName'] ?? 'N/A';
          final trainActivities = activityDetails['train'] ?? [];
          final totalProgress = (activityDetails['totalProgress'] ?? 0.0) / 100;
          final pictureBase64 = activityDetails['picture'] ?? '';
          final email = activityDetails['mentor'] ?? "Unknown";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: pictureBase64.isNotEmpty
                            ? Image.memory(base64Decode(pictureBase64)).image
                            : AssetImage('assets/mentor.png'),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama Course: $materialName',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Nama Mentor: $fullName'),
                          Text(
                              'Total Progress: ${(totalProgress * 100).toInt()}%'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: trainActivities.length,
                  itemBuilder: (context, index) {
                    final activity =
                        trainActivities[index]['trainActivity'] ?? {};
                    final meeting = activity['meeting'] ?? 'N/A';
                    final syllabus = activity['materialNameSyllabus'] ?? 'N/A';
                    final status = activity['status'] ?? false;
                    final isReport = activity['status'] ?? false;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pertemuan ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  status ? '✓ Selesai' : '✗ Belum dibuat',
                                  style: TextStyle(
                                      color:
                                          status ? Colors.green : Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(syllabus),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isReport
                                    ? null
                                    : () {
                                        showProjectPopup(context,
                                            IDActivity: activity['IDActivity']);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isReport
                                      ? Colors.grey
                                      : Color(0xff3DD598),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  isReport
                                      ? 'Laporan Aktivitas Telah Diisi'
                                      : 'Isi Laporan Aktivitas',
                                  style: TextStyle(color: Colors.black),
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 0 ? 1 : _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.grey, // Item terpilih tidak terlihat
        selectedLabelStyle: TextStyle(color: Colors.grey),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Akhiri Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Hubungi Mentor',
          ),
        ],
      ),
    );
  }
}

// Update the showProjectPopup function to pass the callback
void showProjectPopup(BuildContext context, {required IDActivity}) {
  FilePickerResult? fileResult;
  TextEditingController criticismController = TextEditingController();
  bool isLoading = false;

  showModalBottomSheet(
    backgroundColor: Color(0xff27DEBF),
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dokumen Tugas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['zip', 'pdf', 'doc', 'docx', 'png'],
                    );

                    if (result != null) {
                      setState(() {
                        fileResult = result;
                      });
                    }
                  },
                  icon: Icon(Icons.upload_file, color: Colors.black),
                  label: Text("Upload Dokumen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (fileResult != null) ...[
                  SizedBox(height: 10),
                  Text(
                    "File: ${fileResult!.files.single.name}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
                SizedBox(height: 5),
                Text("Format: ZIP, Maks: 10 MB",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
                SizedBox(height: 20),
                Text(
                  "Kritik, Saran dan Masukan (Opsional)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: criticismController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        "Berikan kritik dan saranmu untuk meningkatkan kualitas mentor",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (fileResult == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Silakan unggah file terlebih dahulu!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            await _uploadTask(
                              context,
                              IDActivity,
                              fileResult!.files.single.path!,
                              criticismController.text,
                              () {
                                Navigator.of(context).pop();
                              },
                            );

                            setState(() {
                              isLoading = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3DD598),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text("Simpan", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _uploadTask(BuildContext context, String IDActivity,
    String filePath, String criticism, Function onSuccess) async {
  final scaffoldContext = context;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
        'https://widgets-catb7yz54a-uc.a.run.app/api/my/activity/upload/$IDActivity'),
  );

  request.headers['Authorization'] = 'Bearer $currentUserToken';
  request.fields['criticism'] = criticism;

  request.files.add(await http.MultipartFile.fromPath('task', filePath));

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      if (scaffoldContext.mounted) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Tugas berhasil diunggah')),
        );
      }
      Navigator.pop(scaffoldContext);
      onSuccess();
    } else {
      if (scaffoldContext.mounted) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah tugas, coba lagi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (scaffoldContext.mounted) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
