
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _detailsController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _uiState = ReportUiState.loading);

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      if (_simulateFailure) {
        throw Exception('Simulated failure');
      }

      if (!mounted) return;
      setState(() => _uiState = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_uiState) {
      case ReportUiState.loading:
        content = const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting report... Please wait.'),
          ],
        );

      case ReportUiState.success:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 12),
            const Text(
              'Report submitted successfully!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Submit Another Report',
              onPressed: () => setState(() => _uiState = ReportUiState.idle),
            ),
            AppButton(
              label: 'Back to Home',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );

      case ReportUiState.empty:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 60),
            const SizedBox(height: 12),
            const Text('No report records are available.'),
            const SizedBox(height: 12),
            AppButton(
              label: 'Back to Report Form',
              onPressed: () => setState(() => _uiState = ReportUiState.idle),
            ),
          ],
        );

      case ReportUiState.error:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 12),
            const Text('Report submission failed. Please try again.'),
            const SizedBox(height: 12),
            AppButton(
              label: 'Retry',
              onPressed: submitReport,
            ),
            TextButton(
              onPressed: () => setState(() => _uiState = ReportUiState.idle),
              child: const Text('Correct Form'),
            ),
          ],
        );

      case ReportUiState.idle:
        content = Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Report Form',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: 'Student Name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Student ID',
                controller: _studentIdController,
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Report Details',
                controller: _detailsController,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simulate submission failure (testing only)'),
                value: _simulateFailure,
                onChanged: (value) {
                  setState(() => _simulateFailure = value ?? false);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Submit Report',
                onPressed: submitReport,
              ),
              TextButton(
                onPressed: () => setState(() => _uiState = ReportUiState.empty),
                child: const Text('View Reports (Empty Preview)'),
              ),
            ],
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Report Form')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: content,
          ),
        ),
      ),
    );
  }
}
