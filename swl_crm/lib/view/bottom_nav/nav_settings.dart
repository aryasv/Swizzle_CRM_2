import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavSettings extends StatelessWidget {
  const NavSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Custom AppBar
          const CustomAppBar(
            title: 'Settings',
          ),

          // Profile section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE8F1FD),
                  child: Text(
                    'SJ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A7DE1),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'sarah.johnson@swlcrm.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Chip(
                  label: Text(
                    'Sales Manager',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2A7DE1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Color(0xFFE8F1FD),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ],
            ),
          ),

          SizedBox(height: 16,),


          // Settings list
          const Expanded(
            child: SingleChildScrollView(
              child: SettingsList(),
            ),
          ),
        ],
      ),
    );
  }
}
