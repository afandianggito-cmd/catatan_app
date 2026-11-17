
import 'package:flutter/material.dart';

void main() {
  runApp(const CatatanApp());
}

// ===============================
// APLIKASI UTAMA
// ===============================

class CatatanApp extends StatelessWidget {
  const CatatanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Saya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}

// ===============================
// MODEL CATATAN
// ===============================

class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });
}

// ===============================
// HALAMAN UTAMA DAN NAVIGASI
// ===============================

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int halamanAktif = 0;

  final List<Note> daftarCatatan = [];

  final List<String> judulHalaman = [
    'Beranda',
    'Daftar Catatan',
    'Profil',
  ];

  // PINDAH HALAMAN
  void pindahHalaman(int index) {
    setState(() {
      halamanAktif = index;
    });
  }

  // TAMBAH DAN EDIT CATATAN
  Future<void> tampilkanForm({
    Note? catatan,
    int? index,
  }) async {
    final hasil = await showDialog<Note>(
      context: context,
      builder: (context) {
        return FormCatatanDialog(
          catatan: catatan,
        );
      },
    );

    if (hasil != null && mounted) {
      setState(() {
        if (catatan == null) {
          daftarCatatan.add(hasil);
        } else if (index != null &&
            index >= 0 &&
            index < daftarCatatan.length) {
          daftarCatatan[index] = hasil;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            catatan == null
                ? 'Catatan berhasil ditambahkan'
                : 'Catatan berhasil diperbarui',
          ),
        ),
      );
    }
  }

  // HAPUS CATATAN
  void hapusCatatan(int index) {
    setState(() {
      daftarCatatan.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil dihapus'),
      ),
    );
  }

  // TAMPILAN UTAMA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulHalaman[halamanAktif],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: IndexedStack(
        index: halamanAktif,
        children: [
          HalamanBeranda(
            jumlahCatatan: daftarCatatan.length,
            bukaCatatan: () => pindahHalaman(1),
          ),

          HalamanDaftarCatatan(
            daftarCatatan: daftarCatatan,
            editCatatan: (catatan, index) {
              tampilkanForm(
                catatan: catatan,
                index: index,
              );
            },
            hapusCatatan: hapusCatatan,
          ),

          const HalamanProfil(),
        ],
      ),

      // TOMBOL TAMBAH HANYA DI HALAMAN CATATAN
      floatingActionButton: halamanAktif == 1
          ? FloatingActionButton(
              onPressed: () {
                tampilkanForm();
              },
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,

      // NAVIGASI TIGA SCREEN
      bottomNavigationBar: NavigationBar(
        selectedIndex: halamanAktif,
        onDestinationSelected: pindahHalaman,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Catatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ===============================
// SCREEN 1: BERANDA
// ===============================

class HalamanBeranda extends StatelessWidget {
  final int jumlahCatatan;
  final VoidCallback bukaCatatan;

  const HalamanBeranda({
    super.key,
    required this.jumlahCatatan,
    required this.bukaCatatan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          const Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Simpan ide dan aktivitasmu dalam satu aplikasi.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.note_alt,
                  size: 45,
                  color: Colors.white,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Total Catatan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$jumlahCatatan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: bukaCatatan,
              icon: const Icon(Icons.notes),
              label: const Text('Lihat Daftar Catatan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// SCREEN 2: DAFTAR CATATAN
// ===============================

class HalamanDaftarCatatan extends StatelessWidget {
  final List<Note> daftarCatatan;

  final Function(Note, int) editCatatan;
  final Function(int) hapusCatatan;

  const HalamanDaftarCatatan({
    super.key,
    required this.daftarCatatan,
    required this.editCatatan,
    required this.hapusCatatan,
  });

  @override
  Widget build(BuildContext context) {
    if (daftarCatatan.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 12),

            Text(
              'Belum ada catatan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            Text(
              'Tekan tombol + untuk membuat catatan',
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarCatatan.length,
      itemBuilder: (context, index) {
        final catatan = daftarCatatan[index];

        return Card(
          margin: const EdgeInsets.only(
            bottom: 12,
          ),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.note),
            ),

            title: Text(
              catatan.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              catatan.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  editCatatan(catatan, index);
                } else if (value == 'hapus') {
                  hapusCatatan(index);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),

                PopupMenuItem(
                  value: 'hapus',
                  child: Text('Hapus'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===============================
// SCREEN 3: PROFIL
// ===============================

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Profil Pengguna',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Pengguna Catatan Saya',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.deepPurple,
              ),
              title: const Text('Tentang Aplikasi'),
              subtitle: const Text(
                'Catatan Saya adalah aplikasi sederhana '
                'untuk mengelola catatan.',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.edit_note,
                color: Colors.deepPurple,
              ),
              title: const Text('Fitur Aplikasi'),
              subtitle: const Text(
                'Tambah, lihat, edit, dan hapus catatan.',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.school,
                color: Colors.deepPurple,
              ),
              title: const Text('Versi Aplikasi'),
              subtitle: const Text('Versi 1.0'),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// FORM TAMBAH DAN EDIT CATATAN
// ===============================

class FormCatatanDialog extends StatefulWidget {
  final Note? catatan;

  const FormCatatanDialog({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanDialog> createState() =>
      _FormCatatanDialogState();
}

class _FormCatatanDialogState
    extends State<FormCatatanDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController judulController;
  late TextEditingController isiController;

  @override
  void initState() {
    super.initState();

    judulController = TextEditingController(
      text: widget.catatan?.title ?? '',
    );

    isiController = TextEditingController(
      text: widget.catatan?.content ?? '',
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.catatan == null
            ? 'Tambah Catatan'
            : 'Edit Catatan',
      ),

      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                if (value.trim().length < 3) {
                  return 'Judul minimal 3 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: isiController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Isi catatan wajib diisi';
                }

                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Batal'),
        ),

        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ??
                false) {
              final hasil = Note(
                title: judulController.text.trim(),
                content: isiController.text.trim(),
              );

              Navigator.pop(context, hasil);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
