import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/profile_model.dart';
import 'package:swl_crm/api/web_functions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  ProfileModel? _profile;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await WebFunctions().myProfile(context: context);
      if (response.result && response.response != null) {
        // Assuming the profile data is in 'data' key or directly in response
        final data = response.response!['data'] ?? response.response!;
        setState(() {
          _profile = ProfileModel.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.error;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _profile == null
                  ? const Center(child: Text('No profile data found'))
                  : Column(
                      children: [
                        CustomAppBar(
                          title: 'My Profile',
                          showBack: true,
                        ),

                        // Profile section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
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
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: const Color(0xFFE8F1FD),
                                  child: Text(
                                    _profile!.initials,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2A7DE1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _profile!.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _profile!.email,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Chip(
                                  label: Text(
                                    _profile!.role,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF2A7DE1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFE8F1FD),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        // Content
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),

                                // Personal Info
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Additional Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                _InfoCard(
                                  icon: Icons.calendar_month_outlined,
                                  label: 'Member Since',
                                  value: _profile!.memberSince,
                                ),
                                _InfoCard(
                                  icon: Icons.alarm_add_outlined,
                                  label: 'Last Updated',
                                  value: _profile!.lastUpdated,
                                ),
                                _InfoCard(
                                  icon: Icons.apartment_outlined,
                                  label: 'Organization',
                                  value: _profile!.organization,
                                ),
                                if (_profile!.phone.isNotEmpty &&
                                    _profile!.phone != 'N/A')
                                  _InfoCard(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone',
                                    value: _profile!.phone,
                                  ),

                                const SizedBox(height: 20),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(10),
              // child: Icon is added below
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF2A7DE1),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
