import 'package:flutter/material.dart';

class ExamCommitmentDialog extends StatefulWidget {
  final VoidCallback onAccept;

  const ExamCommitmentDialog({super.key, required this.onAccept});

  @override
  State<ExamCommitmentDialog> createState() => _ExamCommitmentDialogState();
}

class _ExamCommitmentDialogState extends State<ExamCommitmentDialog> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Text(
                'Pernyataan Komitmen Peserta Ujian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduction text
                    Text(
                      '"Saya, dengan ini bersedia untuk mematuhi seluruh Tata Tertib pelaksanaan ujian dan tidak akan melakukan kecurangan dalam bentuk apapun selama ujian berlangsung, seperti:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),

                    // List of rules
                    _buildRuleItem(
                      '1.',
                      'Menduplikasi soal seperti memfoto, tangkapan layar, menyalin dan atau menyimpan soal dalam bentuk apapun.',
                    ),
                    const SizedBox(height: 8),
                    _buildRuleItem(
                      '2.',
                      'Menyebarluaskan soal dan jawaban ujian.',
                    ),
                    const SizedBox(height: 8),
                    _buildRuleItem(
                      '3.',
                      'Meminta bantuan atau berkomunikasi dengan orang lain dalam mengerjakan soal ujian.',
                    ),
                    const SizedBox(height: 8),
                    _buildRuleItem(
                      '4.',
                      'Tidak membuka perangkat uji yang bersifat rahasia, atau ikut serta dalam praktek penipuan dalam bentuk apapun selama pengujian berlangsung.',
                    ),
                    const SizedBox(height: 16),

                    // Declaration text
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                'Jika terdapat indikasi melakukan kecurangan dalam ujian ini, saya ',
                          ),
                          TextSpan(
                            text: 'BERSEDIA',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' untuk dinyatakan '),
                          TextSpan(
                            text: 'TIDAK LULUS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' dalam ujian ini."'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Radio buttons
                    _buildRadioOption('Setuju', 'agree'),
                    const SizedBox(height: 8),
                    _buildRadioOption('Tidak Setuju', 'disagree'),
                  ],
                ),
              ),
            ),

            // Footer with button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _selectedOption == 'agree'
                      ? () {
                          Navigator.of(context).pop();
                          widget.onAccept();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7FED),
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'LANJUT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedOption == 'agree'
                          ? Colors.white
                          : Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue;
              });
            },
            activeColor: const Color(0xFF6B7FED),
          ),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
