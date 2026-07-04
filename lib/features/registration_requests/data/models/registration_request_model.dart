class RegistrationRequestModel {
  final String name;
  final String phone;
  final String customerType;
  final String registrationDate;
  final int childrenCount;
  final List<String> className;
  final List<String> subject;
  final String curriculum;
  final String paymentStatus;
  final String amount;
  final String paymentActionText;

  const RegistrationRequestModel({
    required this.name,
    required this.phone,
    required this.customerType,
    required this.registrationDate,
    required this.childrenCount,
    required this.className,
    required this.subject,
    required this.curriculum,
    required this.paymentStatus,
    required this.amount,
    required this.paymentActionText,
  });
}
 const List<RegistrationRequestModel> requests = [
    RegistrationRequestModel(
      name: 'سارة أحمد',
      phone: '010111123655',
      customerType: 'عميل جديد',
      registrationDate: '2026/06/20',
      childrenCount: 1,
      className: ['الصف الثالث الابتدائي'],
      subject: ['القرآن الكريم'],
      curriculum: 'المنهج المصري',
      paymentStatus: 'بانتظار مراجعة الإيصال يدوياً',
      amount: 'SAR 42',
      paymentActionText: 'تأكيد الدفع يدوياً',
    ),
    RegistrationRequestModel(
      name: 'محمد علي',
      phone: '01098765432',
      customerType: 'عميل جديد',
      registrationDate: '2026/06/18',
      childrenCount: 2,
      className: ['الصف الثالث الابتدائي'],
      subject: ['القرآن الكريم'],
      curriculum: 'المنهج المصري',
      paymentStatus: 'تم الدفع',
      amount: 'SAR 84',
      paymentActionText: 'تم التأكيد',
    ),
    RegistrationRequestModel(
      name: 'ريم خالد',
      phone: '01122334455',
      customerType: 'عميل حالي',
      registrationDate: '2026/06/15',
      childrenCount: 3,
      className: ['الصف الثالث الابتدائي'],
      subject: ['القرآن الكريم'],
      curriculum: 'المنهج السعودي',
      paymentStatus: 'بانتظار مراجعة الإيصال يدوياً',
      amount: 'SAR 126',
      paymentActionText: 'تأكيد الدفع يدوياً',
    ),
    RegistrationRequestModel(
      name: 'عبدالله حسن',
      phone: '01234567890',
      customerType: 'عميل جديد',
      registrationDate: '2026/06/12',
      childrenCount: 1,
      className: ['الصف الثالث الابتدائي'],
      subject: ['القرآن الكريم'],
      curriculum: 'المنهج السعودي',
      paymentStatus: 'تم الدفع',
      amount: 'SAR 65',
      paymentActionText: 'تم التأكيد',
    ),
    RegistrationRequestModel(
      name: 'نور أحمد',
      phone: '01555666777',
      customerType: 'عميل جديد',
      registrationDate: '2026/06/10',
      childrenCount: 2,
      className: ['الصف الثالث الابتدائي'],
      subject: ['القرآن الكريم'],
      curriculum: 'المنهج البريطاني',
      paymentStatus: 'بانتظار مراجعة الإيصال يدوياً',
      amount: 'SAR 90',
      paymentActionText: 'تأكيد الدفع يدوياً',
    ),
  ];