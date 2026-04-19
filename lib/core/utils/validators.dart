/// Input validators for forms
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password wajib diisi';
    if (value.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi';
    if (value != password) return 'Password tidak cocok';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Nama wajib diisi';
    if (value.length < 2) return 'Nama minimal 2 karakter';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final regex = RegExp(r'^(\+62|62|0)[0-9]{8,13}$');
    if (!regex.hasMatch(value)) return 'Format nomor HP tidak valid';
    return null;
  }

  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) return '$fieldName wajib diisi';
    return null;
  }
}
