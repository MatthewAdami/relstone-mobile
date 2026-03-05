import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── US States ────────────────────────────────────────────────────────────────
const List<String> kUsStates = [
  'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
  'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
  'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine',
  'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
  'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
  'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
  'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
  'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia',
  'Washington', 'West Virginia', 'Wisconsin', 'Wyoming',
];

// ── Brand Colors ─────────────────────────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFF2EABFE);
  static const dark    = Color(0xFF0F172A);
  static const text    = Color(0xFF1E293B);
  static const muted   = Color(0xFF94A3B8);
  static const border  = Color(0xFFE2E8F0);
  static const white   = Color(0xFFFFFFFF);
  static const bg      = Color(0xFFF1F5F9);
  static const red     = Color(0xFFEF4444);
  static const green   = Color(0xFF16A34A);
  static const yellow  = Color(0xFFF0A500);
}

// ── Cart Item Model ───────────────────────────────────────────────────────────
class CartItem {
  final String id;
  final String name;
  final String type;
  final double price;
  final int creditHours;
  final bool withTextbook;
  final double textbookPrice;

  const CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.creditHours = 0,
    this.withTextbook = false,
    this.textbookPrice = 0,
  });

  double get lineTotal => price + (withTextbook ? textbookPrice : 0);
}

// ── DRE Info Dropdown ─────────────────────────────────────────────────────────
class DREInfoBox extends StatefulWidget {
  const DREInfoBox({super.key});

  @override
  State<DREInfoBox> createState() => _DREInfoBoxState();
}

class _DREInfoBoxState extends State<DREInfoBox> {
  bool _open = false;

  static const _details = [
    ('Course Format',        'Correspondence/Internet instruction combining text materials, mandatory quiz questions, and final examinations for each unit.'),
    ('15-Hour Courses',      'Minimum 2 days from access to materials. Covers Agency, Ethics, Fair Housing, Trust Fund Accounting, Risk Management.'),
    ('45-Hour Courses',      'Minimum 2 days (online) or 6 days (printed). Maximum completion: 12 months from enrollment.'),
    ('Mandatory Quizzes',    'DRE regulations require quizzes before final exams. Submit online at RELSTONEexams.com for instant feedback.'),
    ('Final Exams',          'Standard courses: 15 questions, 15 min. Implicit Bias: 60 questions, 60 min. Consumer Protection: 40 questions, 40 min.'),
    ('Important Regulation', 'Do not take more than 15 hours credit of C.E. finals in one 24-hour period per DRE requirements.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: _open ? const Color(0xFFF8FAFC) : AppColors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('DRE',
                        style: TextStyle(color: Colors.white, fontSize: 10,
                            fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('REAL ESTATE CONTINUING EDUCATION – GENERAL INFORMATION',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                                color: AppColors.dark, letterSpacing: 0.3)),
                        SizedBox(height: 2),
                        Text('California DRE Sponsor No. 1025 | Real Estate License Services – A RELSTONE® Company',
                            style: TextStyle(fontSize: 9, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.muted, size: 16),
                ],
              ),
            ),
          ),
          if (_open) _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.4,
            ),
            itemCount: _details.length,
            itemBuilder: (_, i) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('● ${_details[i].$1}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(_details[i].$2,
                      style: const TextStyle(fontSize: 8.5, color: AppColors.muted,
                          height: 1.5),
                      maxLines: 4, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                _contactItem(Icons.location_pin,   const Color(0xFF2563EB), 'P.O. Box 374, Escondido, CA 92033'),
                const SizedBox(height: 6),
                _contactItem(Icons.phone,          const Color(0xFF0891B2), '(619) 222-2425'),
                const SizedBox(height: 6),
                _contactItem(Icons.email_outlined, const Color(0xFF1E40AF), 'rels@relstone.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, Color bg, String text) => Row(
    children: [
      Container(
        width: 24, height: 24,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
        child: Icon(icon, color: Colors.white, size: 12),
      ),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
    ],
  );
}

// ── Reusable Form Field ───────────────────────────────────────────────────────
class CoFormField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool optional;
  final String? errorText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffix;

  const CoFormField({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.optional = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: AppColors.text),
            children: [
              TextSpan(text: label),
              if (optional)
                const TextSpan(text: ' (optional)',
                    style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w400))
              else
                const TextSpan(text: ' *', style: TextStyle(color: AppColors.red)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 13, color: AppColors.text),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
            suffixIcon: suffix,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                  color: hasError ? AppColors.red : AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                  color: hasError ? AppColors.red : AppColors.primary, width: 1.5),
            ),
            filled: hasError,
            fillColor: hasError ? const Color(0xFFFFF8F8) : null,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: const TextStyle(fontSize: 11, color: AppColors.red)),
        ],
        const SizedBox(height: 14),
      ],
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(title.toUpperCase(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                      color: AppColors.dark, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: AppColors.border, thickness: 1.5),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// ── Order Summary Sidebar ─────────────────────────────────────────────────────
class CheckoutSummary extends StatefulWidget {
  final List<CartItem> cartItems;
  final double cartTotal;
  final int totalCreditHours;
  final Map<String, String> cardErrors;
  final TextEditingController cardNumberCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;
  final VoidCallback onSubmit;

  const CheckoutSummary({
    super.key,
    required this.cartItems,
    required this.cartTotal,
    required this.totalCreditHours,
    required this.cardErrors,
    required this.cardNumberCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.onSubmit,
  });

  @override
  State<CheckoutSummary> createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummary> {
  bool _showCvv = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildOrderSection(),
          const DREInfoBox(),
          _buildCardSection(),
          _buildTrustBadge(),
        ],
      ),
    );
  }

  Widget _buildOrderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YOUR ORDER',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                  color: AppColors.dark, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('PRODUCT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.muted, letterSpacing: 1)),
              Text('SUBTOTAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.muted, letterSpacing: 1)),
            ],
          ),
          const Divider(color: AppColors.border),
          ...widget.cartItems.map((item) => _buildLineItem(item)),
          const SizedBox(height: 8),
          const Divider(color: AppColors.border),
          _metaRow('Subtotal', '\$${widget.cartTotal.toStringAsFixed(2)}'),
          _metaRow('Shipment 1', 'N/A', italic: true),
          const Divider(color: AppColors.border),
          _metaRow('Total', '\$${widget.cartTotal.toStringAsFixed(2)}', bold: true),
          if (widget.totalCreditHours > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_box, color: AppColors.green, size: 14),
                const SizedBox(width: 6),
                Text('${widget.totalCreditHours} Total Credit Hours',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: AppColors.green)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLineItem(CartItem item) {
    final isPackage = item.type == 'package';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPackage ? const Color(0xFFF0FDF4) : const Color(0xFFE0F2FE),
                    border: Border.all(
                        color: isPackage ? const Color(0xFFBBF7D0) : const Color(0xFFBAE6FD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(isPackage ? 'Package' : 'Course',
                      style: TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        color: isPackage ? const Color(0xFF15803D) : const Color(0xFF0369A1),
                      )),
                ),
                const SizedBox(height: 4),
                Text(item.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: AppColors.dark)),
                if (item.creditHours > 0) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.label, color: AppColors.primary, size: 10),
                      const SizedBox(width: 3),
                      Text('${item.creditHours} Credit Hours',
                          style: const TextStyle(fontSize: 10, color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
                if (item.withTextbook && item.textbookPrice > 0) ...[
                  const SizedBox(height: 2),
                  Text('+ Printed Textbook (+\$${item.textbookPrice.toStringAsFixed(2)})',
                      style: const TextStyle(fontSize: 10, color: AppColors.muted,
                          fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
          Text('\$${item.lineTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value, {bool bold = false, bool italic = false}) {
    final style = TextStyle(
      fontSize: bold ? 13 : 12,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: bold ? AppColors.dark : AppColors.muted,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Credit Card',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.dark)),
              Row(
                children: [
                  _cardBadge('MC', const Color(0xFFEB001B)),
                  const SizedBox(width: 4),
                  _cardBadge('AMEX', const Color(0xFF2E77BC)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Pay securely using your credit card.',
              style: TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(height: 12),

          // Card Number
          _cardFieldLabel('Card Number', isRequired: true,
              error: widget.cardErrors['cardNumber']),
          TextField(
            controller: widget.cardNumberCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [_CardNumberFormatter()],
            maxLength: 19,
            style: const TextStyle(fontSize: 13, color: AppColors.text),
            decoration: _cardInputDecoration(
              hint: '•••• •••• •••• ••••',
              hasError: widget.cardErrors['cardNumber'] != null,
              suffix: const Icon(Icons.credit_card, color: AppColors.muted, size: 18),
            ),
          ),
          if (widget.cardErrors['cardNumber'] != null)
            _errorText(widget.cardErrors['cardNumber']!),
          const SizedBox(height: 12),

          // Expiry + CVV
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardFieldLabel('Expiration (MM/YY)', isRequired: true,
                        error: widget.cardErrors['expiry']),
                    TextField(
                      controller: widget.expiryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [_ExpiryFormatter()],
                      maxLength: 5,
                      style: const TextStyle(fontSize: 13, color: AppColors.text),
                      decoration: _cardInputDecoration(hint: 'MM / YY',
                          hasError: widget.cardErrors['expiry'] != null),
                    ),
                    if (widget.cardErrors['expiry'] != null)
                      _errorText(widget.cardErrors['expiry']!),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardFieldLabel('Card Security Code', isRequired: true,
                        error: widget.cardErrors['cvv']),
                    TextField(
                      controller: widget.cvvCtrl,
                      obscureText: !_showCvv,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      style: const TextStyle(fontSize: 13, color: AppColors.text),
                      decoration: _cardInputDecoration(
                        hint: 'CSC',
                        hasError: widget.cardErrors['cvv'] != null,
                        suffix: GestureDetector(
                          onTap: () => setState(() => _showCvv = !_showCvv),
                          child: Icon(
                              _showCvv ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.muted, size: 16),
                        ),
                      ),
                    ),
                    if (widget.cardErrors['cvv'] != null)
                      _errorText(widget.cardErrors['cvv']!),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Place Order button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('PLACE ORDER',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 10, color: AppColors.muted, height: 1.6),
              children: [
                TextSpan(text: 'Your personal data will be used to process your order, '
                    'support your experience throughout this website, and for other '
                    'purposes described in our '),
                TextSpan(text: 'privacy policy',
                    style: TextStyle(color: AppColors.primary,
                        decoration: TextDecoration.underline)),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFFF8FAFC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.security, color: AppColors.green, size: 14),
          SizedBox(width: 6),
          Text('Secure checkout · 30-day money-back guarantee',
              style: TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _cardBadge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    child: Text(label,
        style: const TextStyle(color: Colors.white, fontSize: 9,
            fontWeight: FontWeight.w800)),
  );

  Widget _cardFieldLabel(String label,
      {required bool isRequired, String? error}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
              color: AppColors.text),
          children: [
            TextSpan(text: label),
            if (isRequired)
              const TextSpan(text: ' *', style: TextStyle(color: AppColors.red)),
          ],
        ),
      ),
    );
  }

  InputDecoration _cardInputDecoration({
    required String hint,
    required bool hasError,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      suffixIcon: suffix,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(
            color: hasError ? AppColors.red : AppColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(
            color: hasError ? AppColors.red : AppColors.primary, width: 1.5),
      ),
      filled: hasError,
      fillColor: hasError ? const Color(0xFFFFF8F8) : null,
    );
  }

  Widget _errorText(String msg) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Text(msg, style: const TextStyle(fontSize: 10, color: AppColors.red)),
  );
}

// ── Text Input Formatters ─────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text
        .replaceAll(RegExp(r'\D'), '')
        .substring(0,
            newVal.text.replaceAll(RegExp(r'\D'), '').length.clamp(0, 16));
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
        text: str, selection: TextSelection.collapsed(offset: str.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.substring(0, digits.length.clamp(0, 4));
    String formatted = limited;
    if (limited.length >= 3) {
      formatted = '${limited.substring(0, 2)}/${limited.substring(2)}';
    }
    return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length));
  }
}

// ── Success Screen ────────────────────────────────────────────────────────────
class _SuccessScreen extends StatelessWidget {
  final String firstName;
  final String email;
  final double total;

  const _SuccessScreen({
    required this.firstName,
    required this.email,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.green, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('Order Confirmed!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                    color: AppColors.dark)),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppColors.muted,
                    height: 1.6),
                children: [
                  const TextSpan(text: 'Thank you, '),
                  TextSpan(text: firstName,
                      style: const TextStyle(fontWeight: FontWeight.w700,
                          color: AppColors.text)),
                  const TextSpan(text: '! A confirmation has been sent to '),
                  TextSpan(text: email,
                      style: const TextStyle(fontWeight: FontWeight.w700,
                          color: AppColors.text)),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Total charged: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 15, color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 28),
            ElevatedButton(
              // ✅ Navigator — no callback needed
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/homescreen', (_) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Back to Home',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main Checkout Screen ──────────────────────────────────────────────────────
class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double cartTotal;
  final int totalCreditHours;
  final VoidCallback clearCart;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.cartTotal,
    required this.totalCreditHours,
    required this.clearCart,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ── Form controllers ──────────────────────────────────────────────────────
  final _firstNameCtrl  = TextEditingController();
  final _lastNameCtrl   = TextEditingController();
  final _companyCtrl    = TextEditingController();
  final _streetCtrl     = TextEditingController();
  final _aptCtrl        = TextEditingController();
  final _cityCtrl       = TextEditingController();
  final _zipCtrl        = TextEditingController();
  final _phoneCtrl      = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _orderNotesCtrl = TextEditingController();

  // ── Card controllers ──────────────────────────────────────────────────────
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl     = TextEditingController();
  final _cvvCtrl        = TextEditingController();

  String _country = 'United States (US)';
  String _state   = 'California';

  Map<String, String> _errors     = {};
  Map<String, String> _cardErrors = {};
  bool   _placed         = false;
  double _confirmedTotal = 0;
  bool   _showPassword   = false;

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl, _lastNameCtrl, _companyCtrl, _streetCtrl, _aptCtrl,
      _cityCtrl, _zipCtrl, _phoneCtrl, _emailCtrl, _passwordCtrl,
      _orderNotesCtrl, _cardNumberCtrl, _expiryCtrl, _cvvCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────────────────────
  Map<String, String> _validate() {
    final e = <String, String>{};
    void req(String key, String val) {
      if (val.trim().isEmpty) e[key] = 'This field is required.';
    }
    req('firstName', _firstNameCtrl.text);
    req('lastName',  _lastNameCtrl.text);
    req('street',    _streetCtrl.text);
    req('city',      _cityCtrl.text);
    req('zip',       _zipCtrl.text);
    req('phone',     _phoneCtrl.text);
    req('email',     _emailCtrl.text);
    req('password',  _passwordCtrl.text);
    if (_emailCtrl.text.isNotEmpty &&
        !RegExp(r'\S+@\S+\.\S+').hasMatch(_emailCtrl.text)) {
      e['email'] = 'Enter a valid email address.';
    }
    if (_passwordCtrl.text.isNotEmpty && _passwordCtrl.text.length < 6) {
      e['password'] = 'Password must be at least 6 characters.';
    }
    return e;
  }

  Map<String, String> _validateCard() {
    final e = <String, String>{};
    if (_cardNumberCtrl.text.replaceAll(' ', '').isEmpty)
      e['cardNumber'] = 'Card number is required.';
    if (_expiryCtrl.text.trim().isEmpty)
      e['expiry'] = 'Expiration date is required.';
    if (_cvvCtrl.text.trim().isEmpty)
      e['cvv'] = 'Security code is required.';
    return e;
  }

  void _handleSubmit() {
    final errs  = _validate();
    final cErrs = _validateCard();
    if (errs.isNotEmpty || cErrs.isNotEmpty) {
      setState(() { _errors = errs; _cardErrors = cErrs; });
      return;
    }
    setState(() {
      _confirmedTotal = widget.cartTotal;
      _placed = true;
    });
    widget.clearCart();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    // Empty cart state
    if (!_placed && widget.cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Column(
          children: [
            _buildHeader(context),
            const Expanded(
              child: Center(
                child: Text('Your cart is empty.',
                    style: TextStyle(fontSize: 15, color: AppColors.muted)),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _placed
                ? _SuccessScreen(
                    firstName: _firstNameCtrl.text,
                    email: _emailCtrl.text,
                    total: _confirmedTotal,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: isWide
                        ? _buildWideLayout()
                        : _buildNarrowLayout(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.lock, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text('Checkout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                        color: AppColors.white)),
              ],
            ),
            TextButton.icon(
              // ✅ Navigator — no callback needed
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back,
                  color: Color(0x99FFFFFF), size: 14),
              label: const Text('Back to Cart',
                  style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF),
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildForm()),
        const SizedBox(width: 20),
        SizedBox(width: 400, child: _buildSummary()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildSummary(),
        const SizedBox(height: 16),
        _buildForm(),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // ── Billing & Shipping ──────────────────────────────────────────────
        SectionCard(
          icon: Icons.location_on,
          title: 'Billing & Shipping',
          children: [
            Row(
              children: [
                Expanded(child: CoFormField(
                    label: 'First Name', controller: _firstNameCtrl,
                    errorText: _errors['firstName'])),
                const SizedBox(width: 12),
                Expanded(child: CoFormField(
                    label: 'Last Name', controller: _lastNameCtrl,
                    errorText: _errors['lastName'])),
              ],
            ),
            CoFormField(label: 'Company Name', controller: _companyCtrl,
                optional: true),
            // Country dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Country / Region ',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                        color: AppColors.text)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _country,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                          color: AppColors.border, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  items: ['United States (US)', 'Canada', 'United Kingdom']
                      .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c,
                              style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (v) => setState(() => _country = v!),
                ),
                const SizedBox(height: 14),
              ],
            ),
            CoFormField(
                label: 'Street Address', controller: _streetCtrl,
                placeholder: 'House number and street name',
                errorText: _errors['street']),
            CoFormField(
                label: 'Apt / Suite', controller: _aptCtrl,
                placeholder: 'Apartment, suite, unit, etc.', optional: true),
            Row(
              children: [
                Expanded(child: CoFormField(
                    label: 'Town / City', controller: _cityCtrl,
                    errorText: _errors['city'])),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('State ',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text)),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: _state,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: AppColors.border, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        items: kUsStates
                            .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s,
                                    style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (v) => setState(() => _state = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CoFormField(label: 'ZIP Code', controller: _zipCtrl,
                keyboardType: TextInputType.number,
                errorText: _errors['zip']),
            CoFormField(label: 'Phone', controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                errorText: _errors['phone']),
            CoFormField(label: 'Email Address', controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                errorText: _errors['email']),
          ],
        ),
        const SizedBox(height: 16),

        // ── Create Account ──────────────────────────────────────────────────
        SectionCard(
          icon: Icons.account_circle_outlined,
          title: 'Create Your Account',
          children: [
            CoFormField(
              label: 'Create Account Password',
              controller: _passwordCtrl,
              placeholder: 'Minimum 6 characters',
              obscureText: !_showPassword,
              errorText: _errors['password'],
              suffix: IconButton(
                icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.muted, size: 18),
                onPressed: () =>
                    setState(() => _showPassword = !_showPassword),
              ),
            ),
            const Text(
              'Your account gives you instant access to your purchased courses.',
              style: TextStyle(fontSize: 11, color: AppColors.muted,
                  height: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Additional Info ─────────────────────────────────────────────────
        SectionCard(
          icon: Icons.sticky_note_2_outlined,
          title: 'Additional Information',
          children: [
            CoFormField(
              label: 'Order Notes',
              controller: _orderNotesCtrl,
              placeholder:
                  'Notes about your order, e.g. special notes for delivery.',
              optional: true,
              maxLines: 4,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return CheckoutSummary(
      cartItems:        widget.cartItems,
      cartTotal:        widget.cartTotal,
      totalCreditHours: widget.totalCreditHours,
      cardErrors:       _cardErrors,
      cardNumberCtrl:   _cardNumberCtrl,
      expiryCtrl:       _expiryCtrl,
      cvvCtrl:          _cvvCtrl,
      onSubmit:         _handleSubmit,
    );
  }
}