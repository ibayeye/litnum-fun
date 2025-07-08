import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../helpers/web_downloader_stub.dart'
    if (dart.library.html) '../helpers/web_downloader.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  bool isDownloadingAll = false;

  @override
  void initState() {
    super.initState();
    fetchAllResults();
  }

  // Download semua hasil siswa - Universal function
  void _downloadAllResults() async {
    setState(() {
      isDownloadingAll = true;
    });

    try {
      const url = 'https://litnum-backend.vercel.app/api/v1/export/all';

      // Tampilkan loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(width: 16),
              Text('Mengunduh semua hasil siswa...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fileName =
            'semua_hasil_siswa_${DateTime.now().millisecondsSinceEpoch}.csv';

        if (kIsWeb) {
          // Untuk web browser
          _downloadForWeb(response.bodyBytes, fileName);
        } else {
          // Untuk mobile
          await _downloadForMobile(response.bodyBytes, fileName);
        }

        // Hilangkan loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Tampilkan dialog sukses
        _showDownloadAllSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendownload file semua hasil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isDownloadingAll = false;
      });
    }
  }

  // Download untuk web browser
  void _downloadForWeb(List<int> bytes, String filename) {
    downloadFileWeb(bytes, filename);
  }

  // Download untuk mobile
  Future<void> _downloadForMobile(List<int> bytes, String filename) async {
    if (!kIsWeb) {
      try {
        // Gunakan app-specific directory
        Directory directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(bytes);

        // Tampilkan dialog dengan opsi untuk mobile
        _showDownloadMobileSuccessDialog(file.path);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving file: $e')),
        );
      }
    }
  }

  void _showDownloadAllSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kIsWeb
                  ? 'File semua hasil siswa telah diunduh ke folder Downloads.'
                  : 'File semua hasil siswa telah diunduh.'),
              const SizedBox(height: 8),
              Text(
                'Total siswa: ${users.length}',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 12),
                Text(
                  'Periksa folder Downloads di komputer Anda.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDownloadMobileSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('File telah diunduh.'),
              const SizedBox(height: 12),
              Text(
                'File: ${filePath.split('/').last}',
                style:
                    const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text(
                'Total siswa: ${users.length}',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 12),
              Text(
                'Pilih aksi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
              label: const Text('Tutup'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _openFile(filePath);
              },
              icon: Icon(Icons.open_in_new),
              label: const Text('Buka'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _shareFile(filePath);
              },
              icon: Icon(Icons.share),
              label: const Text('Bagikan'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _copyPath(filePath);
              },
              icon: Icon(Icons.copy),
              label: const Text('Copy Path'),
            ),
          ],
        );
      },
    );
  }

  void _downloadUserResult(String name) async {
    try {
      final encodedName = Uri.encodeComponent(name);
      final url =
          'https://litnum-backend.vercel.app/api/v1/export/$encodedName';

      // Tampilkan loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(width: 16),
              Text('Mengunduh file...'),
            ],
          ),
        ),
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fileName =
            'hasil_${name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.csv';

        if (kIsWeb) {
          // Download untuk web
          _downloadForWeb(response.bodyBytes, fileName);

          // Hilangkan loading snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Tampilkan dialog sukses untuk web
          _showDownloadWebSuccessDialog(name);
        } else {
          // Download untuk mobile
          await _downloadForMobile(response.bodyBytes, fileName);

          // Hilangkan loading snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendownload file')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showDownloadWebSuccessDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'File hasil untuk $userName telah diunduh ke folder Downloads.'),
              const SizedBox(height: 12),
              Text(
                'Periksa folder Downloads di komputer Anda.',
                style:
                    const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi-fungsi untuk mobile (hanya berjalan di mobile)
  void _openFile(String filePath) async {
    if (!kIsWeb) {
      try {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Tidak dapat membuka file. Pastikan ada aplikasi Excel/WPS Office.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error membuka file: $e')),
        );
      }
    }
  }

  void _shareFile(String filePath) async {
    if (!kIsWeb) {
      try {
        final file = File(filePath);

        if (!await file.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File tidak ditemukan')),
          );
          return;
        }

        final xFile = XFile(
          file.path,
          mimeType: 'text/csv',
          name: file.path.split('/').last,
        );

        await Share.shareXFiles(
          [xFile],
          text: 'File Hasil Literasi Numerasi',
          subject: 'Hasil Literasi Numerasi - ${file.path.split('/').last}',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error berbagi file: $e')),
        );
      }
    }
  }

  Future<void> _copyPath(String filePath) async {
    await Clipboard.setData(ClipboardData(text: filePath));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Path file disalin ke clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> fetchAllResults() async {
    try {
      final response = await http.get(
        Uri.parse('https://litnum-backend.vercel.app/api/v1/allResult'),
      );

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          users = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  Color getRankColor(int index) {
    if (index == 0 || index == 1 || index == 2) {
      return Colors.green;
    } else if (index == 3 || index == 4 || index == 5) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          // Tombol download semua hasil
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: isDownloadingAll
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: users.isEmpty ? null : _downloadAllResults,
                    icon: const Icon(Icons.download_for_offline),
                    tooltip: 'Download semua hasil siswa',
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info dan tombol download semua
          if (users.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total ${users.length} siswa • Tap tombol ⬇ di AppBar untuk download semua hasil${kIsWeb ? ' (akan tersimpan di Downloads)' : ''}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // List siswa
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada data leaderboard',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getRankColor(index),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                user['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Skor: ${user['allResult'].toStringAsFixed(2)}%'),
                              trailing: IconButton(
                                icon: const Icon(Icons.download,
                                    color: Colors.blue),
                                tooltip: 'Download hasil ${user['name']}',
                                onPressed: () {
                                  _downloadUserResult(user['name']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
