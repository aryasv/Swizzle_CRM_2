import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/settings_model.dart';

class NavSettings extends StatefulWidget {
  const NavSettings({super.key});

  @override
  State<NavSettings> createState() => _NavSettingsState();
}

class _NavSettingsState extends State<NavSettings> {
  final WebFunctions _api = WebFunctions();

  bool isLoading = true;
  SettingsUserModel? user;
  List<SettingsItemModel> settings = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final response = await _api.callApiFunction(
      context,
      "settings",
      {},
    );

    if (!mounted) return;

    if (response.result && response.response != null) {
      final data = response.response!['data'];

      user = SettingsUserModel.fromJson(data['user']);

      settings = (data['settings'] as List)
          .map((e) => SettingsItemModel.fromJson(e))
          .toList();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomAppBar(title: 'Settings'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFE8F1FD),
                  child: Text(
                    user!.name.isNotEmpty ? user!.name[0] : '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A7DE1),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user!.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    user!.role,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2A7DE1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: const Color(0xFFE8F1FD),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 48),
              child: SettingsList(items: settings),
            ),
          ),
        ],
      ),
    );
  }
}

