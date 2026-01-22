import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/dashboard_model.dart';

class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  final WebFunctions _api = WebFunctions();

  bool _isLoading = true;
  String _error = '';

  DashboardModel? dashboard;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  // Dashboard API
  Future<void> _loadDashboard() async {
    final response = await _api.dashboard(context: context);

    if (!mounted) return;

    if (response.result && response.response != null) {
      final data = response.response!['data'];

      setState(() {
        dashboard = DashboardModel.fromJson(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.error.isNotEmpty
            ? response.error
            : 'Failed to load dashboard';
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(_error);
      });
    }

    if (dashboard == null) {
      return const SizedBox.shrink();
    }

    final stats = dashboard!.statistics;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            dashboard!.user.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            dashboard!.user.role,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE8F1FD),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF2A7DE1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${dashboard!.user.name}!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Company and Role row
                    Row(
                      children: [
                        const Icon(Icons.business,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          dashboard!.account.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.verified_user,
                            size: 14, color: Color(0xFF2A7DE1)),
                        const SizedBox(width: 4),
                        Text(
                          dashboard!.user.role,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      dashboard!.currentDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Grid View
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: dashboard!.statistics.map((stat) {
                  return _StatCard(
                    iconUrl: stat.icon,
                    value: stat.total.toString(),
                    label: stat.label,
                  );
                }).toList(),
              ),


              const SizedBox(height: 20),

              // Account Information
              const _SectionTitle(title: 'Account Information'),
              _InfoBlock(
                items: [
                  _InfoItem(
                    label: 'Account Name',
                    value: dashboard!.account.name,
                  ),
                  _InfoItem(
                    label: 'Currency',
                    value:
                    '${dashboard!.account.currencySymbol} ${dashboard!.account.currencyCode} (${dashboard!.account.currencyName})',
                  ),
                  _InfoItem(
                    label: 'Total Team Members',
                    value: dashboard!.account.totalUsers.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //  Team Overview
              const _SectionTitle(title: 'Team Overview'),
              _InfoBlock(
                items: [
                  _InfoItem(
                    label: 'Account Admins',
                    value:
                    dashboard!.teamOverview.adminUsers.toString(),
                  ),
                  _InfoItem(
                    label: 'Staff Members',
                    value:
                    dashboard!.teamOverview.staffMembers.toString(),
                  ),
                ],
                trailingIcons: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String iconUrl;
  final String value;
  final String label;

  const _StatCard({
    required this.iconUrl,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            //padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              //color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              iconUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.bar_chart,
                  color: Color(0xFF2A7DE1),
                  size: 40,
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final List<_InfoItem> items;
  final bool trailingIcons;

  const _InfoBlock({
    required this.items,
    this.trailingIcons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (trailingIcons)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: Color(0xFF2A7DE1),
                      size: 18,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });
}
