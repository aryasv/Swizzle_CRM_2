import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/deals_model.dart';
import 'package:swl_crm/view/deals/deal_details_page.dart';
import 'package:swl_crm/view/deals/deal_form_page.dart';

class DealsList extends StatefulWidget {
  const DealsList({super.key});

  @override
  State<DealsList> createState() => _DealsListState();
}

class _DealsListState extends State<DealsList> {
  bool _isLoading = true;
  List<DealModel> _deals = [];
  int _page = 1;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchDeals();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading) {
      _fetchDeals();
    }
  }

  Future<void> _fetchDeals() async {
    if (!_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final response = await WebFunctions().deals(
        context: context,
        status: 'active', // or 'all' depending on requirement
        page: _page,
      );

      if (response.result && response.response != null) {
        final dealsResponse = DealsResponse.fromJson(response.response!);
        
        if (dealsResponse.deals.isEmpty) {
          _hasMore = false;
        } else {
             if (_page >= dealsResponse.lastPage) {
                _hasMore = false;
             }
        }

        if (mounted) {
          setState(() {
            _deals.addAll(dealsResponse.deals);
            _page++;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint("Error fetching deals: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _deals.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_deals.isEmpty) {
       return const Center(child: Text("No deals found"));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _deals.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _deals.length) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }

        final deal = _deals[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DealDetailsPage(
                  dealId: deal.id,
                  dealUuid: deal.uuid,
                ),
              ),
            );
          },
          child: DealCard(
            title: deal.title,
            status: deal.stageName.isNotEmpty ? deal.stageName : deal.status,
            amount: deal.amount,
            clientName: deal.clientName,
            closingDate: deal.closingDate,
            onEdit: () async {
               final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DealFormPage(
                          dealId: deal.id,
                          dealUuid: deal.uuid,
                          dealSummary: deal,
                      ),
                  ),
              );
              if (result == true) {
                  _page = 1;
                  _deals.clear();
                  _hasMore = true;
                  _fetchDeals();
              }
            },
            onDelete: () => _confirmDelete(deal),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(DealModel deal) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Deal"),
        content: const Text("Are you sure you want to delete this deal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final response = await WebFunctions().deleteDeal(
          context: context,
          dealUuid: deal.uuid,
          dealId: deal.id,
        );

        if (response.result) {
            if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Deal deleted successfully")),
                );
                // Refresh list
                _page = 1;
                _deals.clear();
                _hasMore = true;
                _fetchDeals(); // logic handles loading state
            }
        } else {
             if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.error)),
                );
                setState(() => _isLoading = false);
            }
        }
      } catch (e) {
          debugPrint("Error deleting deal: $e");
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("An error occurred")),
             );
             setState(() => _isLoading = false);
          }
      }
    }
  }
}

class DealCard extends StatelessWidget {
  final String title;
  final String status;
  final String amount;
  final String clientName;
  final String closingDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DealCard({
    Key? key,
    required this.title,
    required this.status,
    required this.amount,
    required this.clientName,
    required this.closingDate,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          //  Title And menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.more_vert, size: 24),
                  onSelected: (value) {
                    if (value == 'edit') {
                        onEdit();
                    } else if (value == 'delete') {
                        onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Name And Status
          Row(
            children: [
              _InfoItem(label: 'Name', value: clientName),
              const Spacer(),
              _StatusChip(status: status),
            ],
          ),

          const SizedBox(height: 16),

          //  Close Date And Amount
          Row(
            children: [
              _InfoItem(label: 'Close Date', value: closingDate),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A7DE1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
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
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Basic logic for color, can be improved with map
    final bool isOpen = status.toLowerCase() != 'closed' && status.toLowerCase() != 'lost';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? const Color(0xFF2A7DE1)
            : const Color(0xFF888888), // Grey for closed/lost
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
