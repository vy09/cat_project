import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const ProfileMenuWidget({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        radius: 18,
        child: Icon(Icons.person, color: Color(0xFF6B7FED), size: 22),
      ),
      itemBuilder: (BuildContext context) => [
        // User Name Header
        PopupMenuItem<String>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF6B7FED),
                  radius: 16,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        // Logout Option
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'logout') {
          onLogout();
        }
      },
    );
  }
}
