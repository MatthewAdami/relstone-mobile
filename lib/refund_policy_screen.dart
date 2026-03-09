import 'package:flutter/material.dart';

Future<void> showRefundPolicyBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.94,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: const RefundPolicyScreen(showAsSheet: true),
      ),
    ),
  );
}

class RefundPolicyScreen extends StatelessWidget {
  final bool showAsSheet;

  const RefundPolicyScreen({super.key, this.showAsSheet = false});

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1A2A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => _goBack(context),
          icon: Icon(showAsSheet ? Icons.close_rounded : Icons.arrow_back_rounded),
          tooltip: showAsSheet ? 'Close' : 'Back',
        ),
        title: const Text(
          'Refund Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: Column(
          children: [
            if (showAsSheet)
              Container(
                width: 44,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8C3D1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                'Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'Our refund and returns policy lasts 30 days. If 30 days have passed since your purchase, we cannot offer you a full refund or exchange.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'To be eligible for a return, your item must be unused and in the same condition that you received it. It must also be in the original packaging.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'Several types of goods are exempt from being returned. Perishable goods such as food, flowers, newspapers or magazines cannot be returned. We also do not accept products that are intimate or sanitary goods, hazardous materials, or flammable liquids or gases.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 14),
              Text(
                'Additional non-returnable items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              _PolicyBullet('Gift cards'),
              _PolicyBullet('Downloadable software products'),
              _PolicyBullet('Some health and personal care items'),
              SizedBox(height: 10),
              Text(
                'To complete your return, we require a receipt or proof of purchase.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'Please do not send your purchase back to the manufacturer.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 14),
              Text(
                'There are certain situations where only partial refunds are granted:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              _PolicyBullet('Book with obvious signs of use'),
              _PolicyBullet('CD, DVD, VHS tape, software, video game, cassette tape, or vinyl record that has been opened.'),
              _PolicyBullet('Any item not in its original condition, is damaged or missing parts for reasons not due to our error.'),
              _PolicyBullet('Any item that is returned more than 30 days after delivery'),
              SizedBox(height: 18),
              Text(
                'Refunds',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'Once your return is received and inspected, we will send you an email to notify you that we have received your returned item. We will also notify you of the approval or rejection of your refund.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'If you are approved, then your refund will be processed, and a credit will automatically be applied to your credit card or original method of payment, within a certain amount of days.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Late or missing refunds',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'If you have not received a refund yet, first check your bank account again.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'Then contact your credit card company, it may take some time before your refund is officially posted.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'Next contact your bank. There is often some processing time before a refund is posted.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'If you have done all of this and you still have not received your refund yet, please contact us at [email address].',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Sale items',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'Only regular priced items may be refunded. Sale items cannot be refunded.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Exchanges',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'We only replace items if they are defective or damaged. If you need to exchange it for the same item, send us an email at [email address] and send your item to: [physical address].',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Gifts',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'If the item was marked as a gift when purchased and shipped directly to you, you will receive a gift credit for the value of your return. Once the returned item is received, a gift certificate will be mailed to you.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'If the item was not marked as a gift when purchased, or the gift giver had the order shipped to themselves to give to you later, we will send a refund to the gift giver and they will find out about your return.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Shipping returns',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'To return your product, you should mail your product to: [physical address].',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'You will be responsible for paying for your own shipping costs for returning your item. Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'Depending on where you live, the time it may take for your exchanged product to reach you may vary.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 10),
              Text(
                'If you are returning more expensive items, you may consider using a trackable shipping service or purchasing shipping insurance. We do not guarantee that we will receive your returned item.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
              SizedBox(height: 18),
              Text(
                'Need help?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text(
                'Contact us at [email] for questions related to refunds and returns.',
                style: TextStyle(height: 1.55, fontSize: 15.5),
              ),
            ],
          ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyBullet extends StatelessWidget {
  final String text;

  const _PolicyBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF223B57)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.5, fontSize: 15.5),
            ),
          ),
        ],
      ),
    );
  }
}
