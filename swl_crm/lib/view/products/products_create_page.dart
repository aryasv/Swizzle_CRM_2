import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/products_model.dart';

class ProductsCreatePage extends StatefulWidget {
  final ProductModel? product;

  const ProductsCreatePage({
    super.key,
    this.product,
  });

  @override
  State<ProductsCreatePage> createState() => _ProductsCreatePageState();
}

class _ProductsCreatePageState extends State<ProductsCreatePage> {
  final WebFunctions _api = WebFunctions();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isSaving = false;
  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _nameController.text = widget.product!.name;
      _codeController.text = widget.product!.code;
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final priceStr = _priceController.text.trim();

    if (name.isEmpty || code.isEmpty || priceStr.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    final price = double.tryParse(priceStr);
    if (price == null) {
      _showError("Please enter a valid price");
      return;
    }

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getString('account_id') ?? "1";

      late ApiResponse response;

      if (isEdit) {
        response = await _api.updateProduct(
          context: context,
          productUuid: widget.product!.uuid,
          productName: name,
          productCode: code,
          productPrice: price,
          productId: widget.product!.id.toString(),
          accountId: accountId,
        );
      } else {
        response = await _api.createProduct(
          context: context,
          productName: name,
          productCode: code,
          productPrice: price,
          accountId: accountId,
        );
      }

      if (!mounted) return;

      if (response.result) {
        Navigator.pop(context, true);
      } else {
        _showError(response.error);
      }
    } catch (e) {
      _showError("An error occurred: $e");
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // AppBar
          CustomAppBar(
            title: isEdit ? 'Edit Product' : 'Add New Product',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  const Text(
                    'Product Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      label: 'Enter product name',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Product Code
                  const Text(
                    'Product Code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    decoration: _inputDecoration(
                      label: 'Enter unique product code',
                    ),
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    'Product code must be unique within your account.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _priceController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: _inputDecoration(
                      label: '0.00',
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveProduct,
                      icon: const Icon(Icons.check, color: Colors.white,),
                      label: _isSaving
                          ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                          : Text(
                        isEdit ? 'Update Product' : 'Save Product',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A7DE1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF2A7DE1),
          width: 1.5,
        ),
      ),
    );
  }
}
