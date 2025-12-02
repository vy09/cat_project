# CAT Project - Exam System Implementation

## 📋 Overview

Sistem ujian telah diimplementasikan dengan menggunakan data soal yang diberikan dalam format JSON. Semua 30 soal ujian telah diintegrasikan ke dalam aplikasi Flutter.

## 🗂️ Struktur File yang Dibuat/Diupdate

### 1. Data Files

- **`assets/data/exam_questions.json`** - File JSON berisi 30 soal ujian lengkap
- **`lib/data/models/question_model.dart`** - Model data untuk soal ujian (UPDATED)

### 2. Service Files

- **`lib/core/services/exam_service.dart`** - Service untuk mengelola data ujian

### 3. Widget Updates

- **`lib/modules/exam/exam_page.dart`** - Halaman utama ujian (UPDATED)
- **`lib/modules/exam/widgets/exam_question_widget.dart`** - Widget pertanyaan (UPDATED)

### 4. Configuration

- **`pubspec.yaml`** - Konfigurasi assets (UPDATED)

### 5. Demo/Testing

- **`bin/exam_demo.dart`** - Demo script untuk testing

## 🚀 Fitur yang Diimplementasikan

### ✅ Data Management

- [x] 30 soal ujian lengkap dari data JSON
- [x] Parsing HTML content dalam soal
- [x] Caching untuk performa optimal
- [x] Error handling dan loading states

### ✅ Question Features

- [x] Nomor soal dinamis
- [x] Teks soal dengan format HTML
- [x] 4 pilihan jawaban (A, B, C, D)
- [x] Pembersihan format HTML untuk tampilan

### ✅ Exam Flow

- [x] Loading state saat memuat soal
- [x] Error handling jika gagal memuat
- [x] Navigasi antar soal
- [x] Tracking jawaban yang dipilih
- [x] Marking soal ragu-ragu

## 📊 Data Structure

### QuestionModel

```dart
class QuestionModel {
  final String naskahPenyelId;      // ID naskah penyelenggaraan
  final String mohonId;             // ID permohonan
  final String ujianPesertaId;      // ID ujian peserta
  final String catDafSoalId;        // ID soal CAT
  final String catDafJenisSoalId;   // ID jenis soal
  final String soal;                // Teks soal
  final String jawabA;              // Pilihan A
  final String jawabB;              // Pilihan B
  final String jawabC;              // Pilihan C
  final String jawabD;              // Pilihan D
  final int questionNumber;         // Nomor soal (auto-generated)
}
```

### Exam Service Features

```dart
class ExamService {
  // Memuat semua soal ujian
  Future<List<QuestionModel>> loadExamQuestions()

  // Mendapatkan soal berdasarkan index
  Future<QuestionModel?> getQuestion(int index)

  // Mendapatkan total jumlah soal
  Future<int> getTotalQuestions()

  // Mengacak urutan soal
  Future<List<QuestionModel>> getShuffledQuestions()

  // Mendapatkan soal dalam rentang tertentu
  Future<List<QuestionModel>> getQuestionsRange(int start, int count)

  // Mencari soal berdasarkan keyword
  Future<List<QuestionModel>> searchQuestions(String keyword)
}
```

## 🛠️ Implementasi HTML Processing

Sistem dapat menangani format HTML dalam soal:

- `<br>`, `<br/>`, `<br />` → Line break
- `&lt;`, `&gt;`, `&amp;`, `&nbsp;` → HTML entities
- Tag HTML lainnya akan dihapus
- Normalisasi line break (`\r\n` → `\n`)

## 📱 User Interface

### Exam Page Flow:

1. **Loading Screen** - Menampilkan indikator loading saat memuat soal
2. **Error Screen** - Menampilkan pesan error jika gagal memuat dengan tombol retry
3. **Question Screen** - Menampilkan soal dengan pilihan jawaban
4. **Navigation** - Drawer navigasi untuk melompat ke soal tertentu

### Question Display:

- Nomor soal dengan format "Soal No. X"
- Teks soal dengan format yang bersih (tanpa HTML tags)
- 4 pilihan jawaban (A, B, C, D) dengan highlight selection
- Tombol navigasi dan marking ragu-ragu

## 🔧 Penggunaan

### Memuat Soal Ujian:

```dart
final examService = ExamService();
final questions = await examService.loadExamQuestions();
```

### Mendapatkan Soal Specific:

```dart
final question = await examService.getQuestion(0); // Soal pertama
```

### Mengacak Soal:

```dart
final shuffledQuestions = await examService.getShuffledQuestions();
```

## 📁 Asset Configuration

File `pubspec.yaml` telah dikonfigurasi untuk include:

```yaml
assets:
  - assets/images/logo/
  - assets/images/icons/
  - assets/data/ # Added for JSON files
```

## ✅ Status Implementation

**COMPLETED:**

- ✅ 30 soal ujian telah diintegrasikan
- ✅ Model data Question dengan semua field
- ✅ ExamService dengan fitur lengkap
- ✅ HTML content processing
- ✅ Loading dan error states
- ✅ UI updates untuk menampilkan soal real
- ✅ Asset configuration
- ✅ Demo script untuk testing

**READY TO USE:**
Sistem ujian sekarang siap digunakan dengan:

- 30 soal ujian real dari data yang diberikan
- Interface yang responsive dan user-friendly
- Error handling yang robust
- Performa optimal dengan caching

## 🎯 Exam Questions Overview

Total: **30 Soal**
Topics: Uji Kesesuaian Pesawat Sinar-X, Mammografi, Radiologi

Sample Questions Include:

1. Penggunaan alat ukur baru dalam pengujian
2. Data mentah hasil uji dan dokumentasi
3. Peralatan untuk kesesuaian berkas sinar-X
4. Parameter missing tissue pada mammografi
5. Pengujian reproduksibilitas keluaran radiasi
6. Dan 25 soal lainnya...

Setiap soal mencakup:

- Soal dengan konteks teknis yang detail
- 4 pilihan jawaban yang komprehensif
- Format yang konsisten dan mudah dibaca
