import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:mentorme/features/consultation/roomchat.dart';
import 'package:mentorme/features/learning/services/learning_api_service.dart';
import 'package:mentorme/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKegiatan extends StatefulWidget {
  final String activityId;
  const DetailKegiatan({Key? key, required this.activityId}) : super(key: key);

  @override
  State<DetailKegiatan> createState() => _DetailKegiatanState();
}

class _DetailKegiatanState extends State<DetailKegiatan> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);
  static const Color accentColor = Color(0xff27DEBF);

  late Future<Map<String, dynamic>> _activityFuture;
  bool _isChatLoading = false;
  bool _isCompletionLoading = false;

  // --- LOGIC (No Changes) ---
  @override
  void initState() {
    super.initState();
    _activityFuture = _fetchActivityDetails();
  }

  Future<Map<String, dynamic>> _fetchActivityDetails() async {
    // ... (logic original tidak diubah)
    if (widget.activityId.isEmpty) throw Exception("Invalid activity ID");
    try {
      final response = await http.get(
        Uri.parse(
            'https://widgets22-catb7yz54a-et.a.run.app/api/my/activity/${widget.activityId}'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);
      print("DEBUG: Activity Details Fetched: $responseData");
      if (response.statusCode == 200 && responseData.containsKey('data')) {
        final activityData = responseData['data'];
        print(
            "DEBUG: Activity data - isCompleted: ${activityData['isCompleted']}, completed: ${activityData['completed']}, status: ${activityData['status']}");
        return activityData;
      } else {
        throw Exception('Failed to load activity details');
      }
    } catch (e) {
      throw Exception('Failed to load activity details: $e');
    }
  }

  Future<void> _handleContactMentor() async {
    setState(() => _isChatLoading = true);
    try {
      final activityDetails = await _activityFuture; // Use the fetched data
      final mentorEmail = activityDetails['mentor'];

      if (mentorEmail != null && mentorEmail.isNotEmpty) {
        await _startChatWithMentor(mentorEmail);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email mentor tidak tersedia')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data aktivitas: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isChatLoading = false);
    }
  }

  Future<void> _startChatWithMentor(String emailMentor) async {
    // ... (logic original tidak diubah)
    try {
      final historyResponse = await http.get(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      if (historyResponse.statusCode == 200) {
        final historyData = json.decode(historyResponse.body);
        final chats = historyData['data'] as List<dynamic>?;
        final existingRoom = chats?.firstWhere(
          (chat) => chat['emailMentor'] == emailMentor,
          orElse: () => null,
        );

        final prefs = await SharedPreferences.getInstance();
        final name = prefs.getString('nameUser') ?? 'User';
        final email = prefs.getString('emailUser') ?? '';

        if (existingRoom != null) {
          final idRoom = existingRoom['idRoom'];
          if (mounted)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomchatPage(
                        roomId: idRoom,
                        currentUserName: name,
                        currentUserEmail: email)));
          return;
        }
      }

      final postResponse = await http.post(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat'),
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
        final prefs = await SharedPreferences.getInstance();
        final name = prefs.getString('nameUser') ?? 'User';
        final email = prefs.getString('emailUser') ?? '';
        if (mounted)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomchatPage(
                      roomId: idRoom,
                      currentUserName: name,
                      currentUserEmail: email)));
      } else {
        throw Exception(postData['error'] ?? 'Gagal memulai chat baru');
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan saat memulai chat: $e')));
    }
  }

  void _refreshActivity() {
    setState(() {
      _activityFuture = _fetchActivityDetails();
    });
  }

  Future<void> _handleCompleteLearning() async {
    // Get the learning ID from activity details first
    final activityDetails = await _activityFuture;
    final learningId = activityDetails['learningId'];

    if (learningId == null || learningId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID pembelajaran tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog first
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selesaikan Pembelajaran'),
          content: const Text(
            'Apakah Anda yakin ingin menyelesaikan pembelajaran ini? '
            'Tindakan ini tidak dapat dibatalkan dan akan memproses pembayaran ke mentor.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('Ya, Selesaikan',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _isCompletionLoading = true);

    try {
      print('DEBUG: Starting learning completion for Learning ID: $learningId');
      final response = await LearningApiService.completeLearning(
        learningId: learningId,
      );

      print(
          'DEBUG: Completion response - Success: ${response.success}, Message: ${response.message}');

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data ??
                  'Pembelajaran berhasil diselesaikan! Pendapatan telah ditambahkan ke mentor.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );
          print('DEBUG: Refreshing activity data...');
          _refreshActivity(); // Refresh to update UI
        } else {
          print('DEBUG: Completion failed - ${response.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('DEBUG: Exception during completion: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCompletionLoading = false);
    }
  }

  // --- UI WIDGETS (New and Improved) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data tersedia'));
          }

          final activityDetails = snapshot.data!;
          final materialName = activityDetails['materialName'] ?? 'N/A';
          final trainActivities = activityDetails['train'] as List? ?? [];
          final pictureUrl = activityDetails['picture'] ?? '';

          // Check if learning is already completed
          final isLearningCompleted = activityDetails['isCompleted'] == true ||
              activityDetails['completed'] == true ||
              activityDetails['status'] == true;

          final completedTrain = trainActivities
              .where((t) => (t['trainActivity']?['status'] ?? false) == true)
              .length;
          final totalTrain = trainActivities.length;
          final totalProgress =
              totalTrain == 0 ? 0.0 : completedTrain / totalTrain;

          return Stack(
            children: [
              // Main Content
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: _buildHeader(
                          materialName, pictureUrl, totalProgress)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "Daftar Pertemuan",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkTextColor),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity =
                            trainActivities[index]['trainActivity'] ?? {};
                        return _buildActivityItem(context, activity, index);
                      },
                      childCount: trainActivities.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: SizedBox(
                          height: totalProgress >= 1.0
                              ? 160
                              : 100)), // Space for FABs
                ],
              ),
              _buildAppBar(),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: _activityFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final activityDetails = snapshot.data!;
          final trainActivities = activityDetails['train'] as List? ?? [];

          // Check if learning is already completed
          final isLearningCompleted = activityDetails['isCompleted'] == true ||
              activityDetails['completed'] == true ||
              activityDetails['status'] == true;

          final completedTrain = trainActivities
              .where((t) => (t['trainActivity']?['status'] ?? false) == true)
              .length;
          final totalTrain = trainActivities.length;
          final totalProgress =
              totalTrain == 0 ? 0.0 : completedTrain / totalTrain;

          return _buildFloatingActionButtons(
              totalProgress, isLearningCompleted);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionButtons(
      double progress, bool isLearningCompleted) {
    if (progress >= 1.0) {
      // Show both buttons when all activities are complete
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Complete Learning Button - disabled if already completed
          FloatingActionButton.extended(
            onPressed: isLearningCompleted || _isCompletionLoading
                ? null
                : _handleCompleteLearning,
            backgroundColor:
                isLearningCompleted ? Colors.grey.shade400 : Colors.green,
            heroTag: "complete_learning",
            icon: _isCompletionLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Icon(
                    isLearningCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: Colors.white,
                  ),
            label: Text(
              _isCompletionLoading
                  ? 'Memproses...'
                  : isLearningCompleted
                      ? 'Pembelajaran Selesai'
                      : 'Selesaikan Pembelajaran',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          // Contact Mentor Button
          FloatingActionButton.extended(
            onPressed: _isChatLoading ? null : _handleContactMentor,
            backgroundColor: primaryColor,
            heroTag: "contact_mentor",
            icon: _isChatLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(_isChatLoading ? 'Memuat...' : 'Hubungi Mentor'),
          ),
        ],
      );
    } else {
      // Show only contact mentor button when learning is not complete
      return FloatingActionButton.extended(
        onPressed: _isChatLoading ? null : _handleContactMentor,
        backgroundColor: primaryColor,
        icon: _isChatLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.chat_bubble_outline_rounded),
        label: Text(_isChatLoading ? 'Memuat...' : 'Hubungi Mentor'),
      );
    }
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Pelajaranku",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
    );
  }

  Widget _buildHeader(String materialName, String pictureUrl, double progress) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(color: primaryColor),
          ),
        ),
        Positioned(
          top: 110,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      pictureUrl.isNotEmpty ? NetworkImage(pictureUrl) : null,
                  child: pictureUrl.isEmpty
                      ? const Icon(Icons.school, size: 35)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materialName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTextColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 90), // Spacer for the card
      ],
    );
  }

  Widget _buildActivityItem(
      BuildContext context, Map<String, dynamic> activity, int index) {
    final syllabus = activity['materialNameSyllabus'] ?? 'N/A';
    final status = activity['status'] ?? false;
    final activityId = activity['IDActivity'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        status ? primaryColor : Colors.grey.shade300,
                    child: Text(
                      'P${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status ? Colors.white : darkTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      syllabus,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: darkTextColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    status ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: status ? Colors.green : Colors.grey,
                    size: 20,
                  )
                ],
              ),
              const Divider(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: status
                      ? null
                      : () => showProjectPopup(
                            context,
                            IDActivity: activityId,
                            onUploadSuccess: _refreshActivity,
                          ),
                  icon: Icon(
                      status
                          ? Icons.description_rounded
                          : Icons.upload_file_rounded,
                      size: 18),
                  label: Text(
                      status ? 'Laporan Telah Diisi' : 'Isi Laporan Aktivitas'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: darkTextColor,
                    backgroundColor:
                        status ? Colors.grey.shade200 : accentColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Helper classes and functions

class WaveClipper extends CustomClipper<Path> {
  // ... (Sama seperti sebelumnya, tidak perlu diubah)
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 25);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height - 50, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showProjectPopup(BuildContext context,
    {required String IDActivity, required VoidCallback onUploadSuccess}) {
  // ... (logicnya sama, hanya style yang diubah)
  FilePickerResult? fileResult;
  TextEditingController criticismController = TextEditingController();
  bool isLoading = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Unggah Laporan",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _DetailKegiatanState.darkTextColor)),
              const SizedBox(height: 16),
              const Text("Dokumen Tugas (.zip, .pdf, .docx, .png, .jpg)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _DetailKegiatanState.darkTextColor)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'zip',
                      'pdf',
                      'doc',
                      'docx',
                      'png',
                      'jpg',
                      'jpeg'
                    ],
                  );
                  if (result != null) setState(() => fileResult = result);
                },
                icon: const Icon(Icons.upload_file),
                label: Text(fileResult == null ? "Pilih File" : "Ganti File"),
                style: OutlinedButton.styleFrom(
                    foregroundColor: _DetailKegiatanState.primaryColor,
                    side: const BorderSide(
                        color: _DetailKegiatanState.primaryColor)),
              ),
              if (fileResult != null) ...[
                const SizedBox(height: 8),
                Text("Terpilih: ${fileResult!.files.single.name}",
                    style: const TextStyle(
                        color: _DetailKegiatanState.darkTextColor,
                        fontStyle: FontStyle.italic)),
              ],
              const SizedBox(height: 20),
              const Text("Kritik & Saran (Opsional)",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _DetailKegiatanState.darkTextColor)),
              const SizedBox(height: 8),
              TextField(
                controller: criticismController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      "Berikan masukan untuk meningkatkan kualitas mentor...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading || fileResult == null
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          await _uploadTask(
                              context,
                              IDActivity,
                              fileResult!.files.single.path!,
                              criticismController.text,
                              onUploadSuccess);
                          setState(() => isLoading = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _DetailKegiatanState.primaryColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white))
                      : const Text("Kirim Laporan",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

Future<void> _uploadTask(BuildContext context, String IDActivity,
    String filePath, String criticism, VoidCallback onSuccess) async {
  // ... (logic original tidak diubah)
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://widgets22-catb7yz54a-et.a.run.app/api/my/activity/upload/$IDActivity'));
  request.headers['Authorization'] = 'Bearer $currentUserToken';
  request.fields['criticism'] = criticism;
  request.files.add(await http.MultipartFile.fromPath('task', filePath));

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Tugas berhasil diunggah'),
            backgroundColor: Colors.green));
        Navigator.pop(context); // Close the popup
        onSuccess(); // Trigger the refresh
      }
    } else {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal mengunggah tugas, coba lagi'),
            backgroundColor: Colors.red));
    }
  } catch (e) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan: $e'), backgroundColor: Colors.red));
  }
}
