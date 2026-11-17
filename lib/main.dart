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
      home: const HalamanLogin(),
    );
  }
}

// ===============================
// HALAMAN LOGIN
// ===============================

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final formLoginKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Catatan Saya'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formLoginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_person,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Silakan Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'ID Pengguna',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'ID wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value.length < 5) {
                      return 'Password minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (formLoginKey.currentState?.validate() ?? false) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HalamanUtama(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// MODEL CATATAN
// ===============================

class Note {
  String? id;
  String title;
  String content;
  String? nomor;
  String? alamat;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.nomor,
    this.alamat,
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

  void pindahHalaman(int index) {
    setState(() {
      halamanAktif = index;
    });
  }

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
            daftarCatatan: daftarCatatan,
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
  final List<Note> daftarCatatan;

  const HalamanBeranda({
    super.key,
    required this.jumlahCatatan,
    required this.bukaCatatan,
    required this.daftarCatatan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.note_alt,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Total Catatan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$jumlahCatatan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catatan Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: bukaCatatan,
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          daftarCatatan.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'Belum ada catatan yang ditambahkan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daftarCatatan.length > 3 ? 3 : daftarCatatan.length,
                  itemBuilder: (context, index) {
                    final catatan = daftarCatatan[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.note, color: Colors.white),
                        ),
                        title: Text(
                          catatan.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          catatan.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: bukaCatatan,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// ===============================
// SCREEN 2: DAFTAR CATATAN + FITUR PENCARIAN
// ===============================

class HalamanDaftarCatatan extends StatefulWidget {
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
  State<HalamanDaftarCatatan> createState() => _HalamanDaftarCatatanState();
}

class _HalamanDaftarCatatanState extends State<HalamanDaftarCatatan> {
  final TextEditingController searchController = TextEditingController();
  String keyword = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter catatan berdasarkan judul, isi, nomor, atau alamat yang diketik
    final hasilPencarian = widget.daftarCatatan.where((catatan) {
      final query = keyword.toLowerCase();
      final judul = catatan.title.toLowerCase();
      final isi = catatan.content.toLowerCase();
      final nomor = (catatan.nomor ?? '').toLowerCase();
      final alamat = (catatan.alamat ?? '').toLowerCase();

      return judul.contains(query) ||
          isi.contains(query) ||
          nomor.contains(query) ||
          alamat.contains(query);
    }).toList();

    return Column(
      children: [
        // ===============================
        // KOTAK PENCARIAN (SEARCH BAR)
        // ===============================
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Cari catatan (Judul, Nomor, Alamat)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          keyword = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),

        // ===============================
        // DAFTAR HASIL PENCARIAN
        // ===============================
        Expanded(
          child: widget.daftarCatatan.isEmpty
              ? const Center(
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
                      Text('Tekan tombol + untuk membuat catatan'),
                    ],
                  ),
                )
              : hasilPencarian.isEmpty
                  ? const Center(
                      child: Text(
                        'Pencarian tidak ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: hasilPencarian.length,
                      itemBuilder: (context, index) {
                        final catatan = hasilPencarian[index];
                        // Cari index asli di list utama agar fungsi edit/hapus tetap akurat
                        final originalIndex = widget.daftarCatatan.indexOf(catatan);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${catatan.id ?? '-'}'),
                                Text('No: ${catatan.nomor ?? '-'}'),
                                Text('Alamat: ${catatan.alamat ?? '-'}'),
                                const SizedBox(height: 4),
                                Text(
                                  catatan.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  widget.editCatatan(catatan, originalIndex);
                                } else if (value == 'hapus') {
                                  widget.hapusCatatan(originalIndex);
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
                    ),
        ),
      ],
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
                'Catatan Saya adalah aplikasi sederhana untuk mengelola catatan.',
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
                'Login, Tambah, lihat, edit, dan hapus catatan.',
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
          const SizedBox(height: 10),
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Keluar Akun',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('Keluar dari sesi saat ini'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HalamanLogin(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Keluar'),
                      ),
                    ],
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
  State<FormCatatanDialog> createState() => _FormCatatanDialogState();
}

class _FormCatatanDialogState extends State<FormCatatanDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController judulController;
  late TextEditingController isiController;
  late TextEditingController nomorController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(
      text: widget.catatan?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    judulController = TextEditingController(
      text: widget.catatan?.title ?? '',
    );
    isiController = TextEditingController(
      text: widget.catatan?.content ?? '',
    );
    nomorController = TextEditingController(
      text: widget.catatan?.nomor ?? '',
    );
    alamatController = TextEditingController(
      text: widget.catatan?.alamat ?? '',
    );
  }

  @override
  void dispose() {
    idController.dispose();
    judulController.dispose();
    isiController.dispose();
    nomorController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.catatan == null ? 'Tambah Catatan' : 'Edit Catatan',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: idController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'ID Catatan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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
                controller: nomorController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: isiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi catatan wajib diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
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
            if (formKey.currentState?.validate() ?? false) {
              final hasil = Note(
                id: idController.text.trim(),
                title: judulController.text.trim(),
                content: isiController.text.trim(),
                nomor: nomorController.text.trim(),
                alamat: alamatController.text.trim(),
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