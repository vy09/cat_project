class QuestionModel {
  final String naskahPenyelId;
  final String mohonId;
  final String ujianPesertaId;
  final String catDafSoalId;
  final String catDafJenisSoalId;
  final String soal;
  final String jawabA;
  final String jawabB;
  final String jawabC;
  final String jawabD;
  final int questionNumber;

  QuestionModel({
    required this.naskahPenyelId,
    required this.mohonId,
    required this.ujianPesertaId,
    required this.catDafSoalId,
    required this.catDafJenisSoalId,
    required this.soal,
    required this.jawabA,
    required this.jawabB,
    required this.jawabC,
    required this.jawabD,
    required this.questionNumber,
  });

  // Convenience method to get options as list
  List<String> get options => [
    'A. $jawabA',
    'B. $jawabB',
    'C. $jawabC',
    'D. $jawabD',
  ];

  // Factory constructor for JSON deserialization
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      naskahPenyelId: json['naskah_penyel_id']?.toString() ?? '',
      mohonId: json['mohon_id']?.toString() ?? '',
      ujianPesertaId: json['ujian_peserta_id']?.toString() ?? '',
      catDafSoalId: json['cat_daf_soal_id']?.toString() ?? '',
      catDafJenisSoalId: json['cat_daf_jenis_soal_id']?.toString() ?? '',
      soal: json['soal']?.toString() ?? '',
      jawabA: json['jawab_a']?.toString() ?? '',
      jawabB: json['jawab_b']?.toString() ?? '',
      jawabC: json['jawab_c']?.toString() ?? '',
      jawabD: json['jawab_d']?.toString() ?? '',
      questionNumber: 0, // Will be set when loading
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'naskah_penyel_id': naskahPenyelId,
      'mohon_id': mohonId,
      'ujian_peserta_id': ujianPesertaId,
      'cat_daf_soal_id': catDafSoalId,
      'cat_daf_jenis_soal_id': catDafJenisSoalId,
      'soal': soal,
      'jawab_a': jawabA,
      'jawab_b': jawabB,
      'jawab_c': jawabC,
      'jawab_d': jawabD,
    };
  }

  // Create a copy with modified question number
  QuestionModel copyWith({int? questionNumber}) {
    return QuestionModel(
      naskahPenyelId: naskahPenyelId,
      mohonId: mohonId,
      ujianPesertaId: ujianPesertaId,
      catDafSoalId: catDafSoalId,
      catDafJenisSoalId: catDafJenisSoalId,
      soal: soal,
      jawabA: jawabA,
      jawabB: jawabB,
      jawabC: jawabC,
      jawabD: jawabD,
      questionNumber: questionNumber ?? this.questionNumber,
    );
  }
}
