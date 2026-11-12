import 'package:flutter/material.dart';
import '../../state/erp_controller.dart';

class AuthScreen extends StatefulWidget {
  final ErpController controller;
  const AuthScreen({super.key, required this.controller});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  // Login Controllers
  final TextEditingController _loginUsernameCtrl = TextEditingController(text: 'admin');
  final TextEditingController _loginPasswordCtrl = TextEditingController(text: '123');

  // Register Controllers
  final TextEditingController _regNameCtrl = TextEditingController();
  final TextEditingController _regUsernameCtrl = TextEditingController();
  final TextEditingController _regPhoneCtrl = TextEditingController();
  final TextEditingController _regPasswordCtrl = TextEditingController();
  String _selectedRole = 'Owner / Admin';

  @override
  void dispose() {
    _loginUsernameCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _regNameCtrl.dispose();
    _regUsernameCtrl.dispose();
    _regPhoneCtrl.dispose();
    _regPasswordCtrl.dispose();
    super.dispose();
  }

  TextStyle _txt(
    ErpController ctrl, {
    double size = 12.5,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: ctrl.isRtl ? 1.55 : 1.3,
      fontFamilyFallback: const [
        'Inter',
        'Segoe UI',
        'Roboto',
        'sans-serif',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;
    final isDark = ctrl.isDarkMode;
    final isUrdu = ctrl.currentLang == 'ur';
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? Colors.white12 : Colors.grey.shade300;

    return Directionality(
      textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Controls (Language & Theme)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Language Selector Chips
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black38 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              _langChip(ctrl, 'ur', 'اردو'),
                              _langChip(ctrl, 'ro', 'Roman'),
                              _langChip(ctrl, 'en', 'English'),
                            ],
                          ),
                        ),
                        // Dark/Light Theme Button
                        IconButton(
                          onPressed: ctrl.toggleDarkMode,
                          icon: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: isDark ? const Color(0xFFFBBF24) : Colors.black87,
                            size: 20,
                          ),
                          tooltip: 'Toggle Theme',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Brand Logo & Header Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ctrl.palette.headerStart,
                            ctrl.palette.headerEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ctrl.palette.primary.withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 8),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.jpeg',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.store_rounded,
                                  size: 40,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isUrdu
                                ? 'بابر اینڈ برادرز ہارڈویئر اینڈ پینٹ سٹور'
                                : 'BABUR & BROTHERS PAINT ERP',
                            style: _txt(
                              ctrl,
                              size: 15,
                              weight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isUrdu
                                ? 'گوبیز پینٹس آفیشل ڈیلرشپ اینڈ ٹنٹنگ اسٹوڈیو'
                                : "Gobi's Paints Official Dealer & POS System",
                            style: _txt(
                              ctrl,
                              size: 11,
                              weight: FontWeight.w500,
                              color: const Color(0xFFFDE68A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card Form Container
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderCol),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Tab Bar (Login vs Register)
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _isRegisterMode = false),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 9),
                                      decoration: BoxDecoration(
                                        color: !_isRegisterMode
                                            ? ctrl.palette.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUrdu ? 'لاگ ان (Sign In)' : 'Sign In',
                                        style: _txt(
                                          ctrl,
                                          size: 12,
                                          weight: FontWeight.bold,
                                          color: !_isRegisterMode
                                              ? Colors.white
                                              : (isDark ? Colors.grey : Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _isRegisterMode = true),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 9),
                                      decoration: BoxDecoration(
                                        color: _isRegisterMode
                                            ? ctrl.palette.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUrdu ? 'نیا اکاؤنٹ (Register)' : 'Register',
                                        style: _txt(
                                          ctrl,
                                          size: 12,
                                          weight: FontWeight.bold,
                                          color: _isRegisterMode
                                              ? Colors.white
                                              : (isDark ? Colors.grey : Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Form Content
                          if (!_isRegisterMode) ...[
                            // LOGIN FORM
                            _buildInputField(
                              ctrl,
                              controller: _loginUsernameCtrl,
                              label: isUrdu ? 'یوزر نیم یا فون نمبر' : 'Username or Phone',
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildInputField(
                              ctrl,
                              controller: _loginPasswordCtrl,
                              label: isUrdu ? 'پاس ورڈ' : 'Password',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              obscure: _obscurePassword,
                              onToggleObscure: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                              isDark: isDark,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ctrl.palette.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                ctrl.login(
                                  _loginUsernameCtrl.text,
                                  _loginPasswordCtrl.text,
                                );
                              },
                              child: Text(
                                isUrdu ? 'لاگ ان کریں (Sign In)' : 'Sign In',
                                style: _txt(
                                  ctrl,
                                  size: 13,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 12),

                            // Quick Demo Logins
                            Text(
                              isUrdu
                                  ? 'آسانی کے لیے 1-کلک فوری لاگ ان:'
                                  : 'Quick 1-Click Fast Access:',
                              style: _txt(ctrl, size: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _loginUsernameCtrl.text = 'admin';
                                _loginPasswordCtrl.text = '123';
                                ctrl.login('admin', '123');
                              },
                              icon: const Icon(Icons.verified_user_rounded, size: 18, color: Color(0xFF10B981)),
                              label: Text(
                                isUrdu
                                    ? 'بابر برادرز (مالک / ایڈمن اکاؤنٹ)'
                                    : 'Babur Brothers (Owner / Admin Account)',
                                style: _txt(ctrl, size: 11.5, weight: FontWeight.bold),
                              ),
                            ),
                          ] else ...[
                            // REGISTER FORM
                            _buildInputField(
                              ctrl,
                              controller: _regNameCtrl,
                              label: isUrdu ? 'مکمل نام (Full Name)' : 'Full Name',
                              icon: Icons.badge_outlined,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            _buildInputField(
                              ctrl,
                              controller: _regUsernameCtrl,
                              label: isUrdu ? 'یوزر نیم (Username)' : 'Username',
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            _buildInputField(
                              ctrl,
                              controller: _regPhoneCtrl,
                              label: isUrdu ? 'موبائل نمبر (Mobile)' : 'Mobile Phone',
                              icon: Icons.phone_outlined,
                              isDark: isDark,
                              isPhone: true,
                            ),
                            const SizedBox(height: 10),
                            _buildInputField(
                              ctrl,
                              controller: _regPasswordCtrl,
                              label: isUrdu ? 'پاس ورڈ (Password)' : 'Password',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              obscure: _obscurePassword,
                              onToggleObscure: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),

                            // Role Selection
                            Text(
                              isUrdu ? 'ذمہ داری / عہدہ (Role):' : 'Account Role:',
                              style: _txt(ctrl, size: 11.5, weight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderCol),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedRole,
                                  isExpanded: true,
                                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Owner / Admin',
                                      child: Text(
                                        isUrdu ? 'مالک / ایڈمن (Owner / Admin)' : 'Owner / Admin',
                                        style: _txt(ctrl, size: 12),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Manager',
                                      child: Text(
                                        isUrdu ? 'سٹور مینیجر (Store Manager)' : 'Store Manager',
                                        style: _txt(ctrl, size: 12),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Cashier / Salesman',
                                      child: Text(
                                        isUrdu
                                            ? 'سیلز کیشیئر (Cashier / Salesman)'
                                            : 'Cashier / Salesman',
                                        style: _txt(ctrl, size: 12),
                                      ),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedRole = val);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                ctrl.register(
                                  name: _regNameCtrl.text,
                                  username: _regUsernameCtrl.text,
                                  password: _regPasswordCtrl.text,
                                  role: _selectedRole,
                                  phone: _regPhoneCtrl.text,
                                );
                              },
                              child: Text(
                                isUrdu ? 'اکاؤنٹ بنائیں اور شروع کریں' : 'Create Account & Sign In',
                                style: _txt(
                                  ctrl,
                                  size: 13,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Footer Address & Copyright
                    Text(
                      ctrl.shopProfile.address,
                      style: _txt(ctrl, size: 10.5, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Helpline: ${ctrl.shopProfile.phone}',
                      style: _txt(ctrl, size: 10.5, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _langChip(ErpController ctrl, String code, String label) {
    final active = ctrl.currentLang == code;
    return InkWell(
      onTap: () => ctrl.setLanguage(code),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? ctrl.palette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active
                ? Colors.white
                : (ctrl.isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    ErpController ctrl, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    bool isPhone = false,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscure,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: _txt(ctrl, size: 12.5),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: _txt(ctrl, size: 11.5, color: Colors.grey),
          prefixIcon: Icon(icon, size: 18, color: ctrl.palette.primary),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
