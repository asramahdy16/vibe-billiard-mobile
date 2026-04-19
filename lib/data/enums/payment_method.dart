/// Payment method enum matching backend
enum PaymentMethod {
  cash('cash', 'Cash (Kasir)'),
  transfer('transfer', 'Transfer Bank'),
  ewallet('ewallet', 'E-Wallet');

  final String value;
  final String label;

  const PaymentMethod(this.value, this.label);

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentMethod.cash,
    );
  }
}
