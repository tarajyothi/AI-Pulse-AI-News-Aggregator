import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = 'AI Explorer';
  bool _notificationsEnabled = true;
  bool _darkMode = true;

  final Map<String, bool> _categoryPrefs = {
    'Generative AI': true,
    'AI Research': true,
    'Robotics': false,
    'AI Tools': true,
    'AI Startups': false,
    'Big Tech': true,
  };

  static const String _appVersion = '1.0.0';

  void _openEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _EditProfileSheet(
        initialName: _displayName,
        onSave: (newName) {
          setState(() => _displayName = newName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.surfaceLight,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            'Profile',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          _buildProfileHeader(),
          const SizedBox(height: 28),
          _sectionTitle('News Preferences'),
          const SizedBox(height: 12),
          _buildCategoryPrefs(),
          const SizedBox(height: 28),
          _sectionTitle('Settings'),
          const SizedBox(height: 12),
          _buildSettingsCard(),
          const SizedBox(height: 28),
          _sectionTitle('About'),
          const SizedBox(height: 12),
          _buildAboutCard(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.18), AppColors.secondary.withValues(alpha: 0.12)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'AI news enthusiast',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _openEditProfileSheet,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_rounded, color: AppColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildCategoryPrefs() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: _categoryPrefs.keys.map((category) {
          final isLast = category == _categoryPrefs.keys.last;
          return Column(
            children: [
              CheckboxListTile(
                value: _categoryPrefs[category],
                onChanged: (value) => setState(() => _categoryPrefs[category] = value ?? false),
                title: Text(category, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
              if (!isLast) const Divider(color: AppColors.divider, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            subtitle: const Text('Get alerts for breaking AI news', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
          ),
          const Divider(color: AppColors.divider, height: 1),
          SwitchListTile(
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value ? 'Dark mode enabled' : 'Light mode is coming soon')),
              );
            },
            title: const Text('Dark Mode', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            subtitle: const Text('AI Pulse is optimized for dark UI', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Pulse',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'AI Pulse aggregates the latest AI news from across the web into one clean, distraction-free feed — covering generative AI, research, robotics, tools, startups, and big tech.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Version', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(_appVersion, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Editable profile form shown as a modal bottom sheet.
/// Demonstrates Form, GlobalKey<FormState>, TextFormField, validator, SnackBar.
class _EditProfileSheet extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onSave;

  const _EditProfileSheet({required this.initialName, required this.onSave});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim());
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors before saving'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Profile',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                validator: _validateName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
