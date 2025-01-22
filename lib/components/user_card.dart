import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage('assets/doctor.jpg')),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Good!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
