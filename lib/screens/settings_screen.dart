import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isPolish = appProvider.currentLanguage == 'pl';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPolish ? 'Ustawienia' : 'Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            context,
            isPolish ? 'Wygląd' : 'Appearance',
            Icons.palette,
          ),
          _buildThemeCard(context, themeProvider, isPolish),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            isPolish ? 'Język' : 'Language',
            Icons.language,
          ),
          _buildLanguageCard(context, appProvider, isPolish),
          const SizedBox(height: 24),
          if (authProvider.appUser != null) ...[
            _buildSectionHeader(
              context,
              isPolish ? 'Profil' : 'Profile',
              Icons.person,
            ),
            _buildProfileCard(context, authProvider, isPolish),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader(
            context,
            isPolish ? 'Aplikacja' : 'Application',
            Icons.apps,
          ),
          _buildAppInfoCard(context, isPolish),
          const SizedBox(height: 24),
          _buildResetButton(context, isPolish),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProvider, bool isPolish) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    Icons.light_mode,
                    isPolish ? 'Jasny' : 'Light',
                    ThemeMode.light,
                    themeProvider,
                  ),
                ),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    Icons.dark_mode,
                    isPolish ? 'Ciemny' : 'Dark',
                    ThemeMode.dark,
                    themeProvider,
                  ),
                ),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    Icons.brightness_auto,
                    isPolish ? 'Auto' : 'Auto',
                    ThemeMode.system,
                    themeProvider,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    IconData icon,
    String label,
    ThemeMode mode,
    ThemeProvider themeProvider,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => themeProvider.setThemeMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.primaryContainer : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, AppProvider appProvider, bool isPolish) {
    return Card(
      child: Column(
        children: appProvider.availableLanguages.map((lang) {
          final isSelected = lang['code'] == appProvider.currentLanguage;
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  lang['code']!.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            title: Text(lang['name']!),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => appProvider.setLanguage(lang['code']!),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthProvider authProvider, bool isPolish) {
    final user = authProvider.appUser;
    if (user == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isPolish ? 'Członek od ${user.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}'
                  : 'Member since ${user.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context, bool isPolish) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(isPolish ? 'Wersja' : 'Version'),
            trailing: const Text('1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(isPolish ? 'Polityka prywatności' : 'Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, bool isPolish) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showResetDialog(context, isPolish),
        icon: const Icon(Icons.restart_alt),
        label: Text(isPolish ? 'Zresetuj aplikację' : 'Reset application'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context, bool isPolish) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPolish ? 'Zresetować aplikację?' : 'Reset application?'),
        content: Text(
          isPolish
              ? 'Wszystkie dane zostaną usunięte. Czy chcesz kontynuować?'
              : 'All data will be deleted. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isPolish ? 'Anuluj' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isPolish ? 'Zresetuj' : 'Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false,
      );
    }
  }
}
