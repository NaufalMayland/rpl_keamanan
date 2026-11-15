import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  // ---------------------------------------------------------------
  // a) isValidEmail()
  // ---------------------------------------------------------------
  group('Validators.isValidEmail', () {
    test('menerima email dengan format valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('first.last@sub.domain.co.id'), isTrue);
      expect(Validators.isValidEmail('user+tag@example.com'), isTrue);
    });

    test('menolak email kosong', () {
      expect(Validators.isValidEmail(''), isFalse);
    });

    test('menolak email tanpa tanda @', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
    });

    test('menolak email tanpa bagian lokal', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
    });

    test('menolak email tanpa domain', () {
      expect(Validators.isValidEmail('user@'), isFalse);
    });

    test('menolak email tanpa titik pada domain', () {
      expect(Validators.isValidEmail('user@example'), isFalse);
    });

    test('menolak email yang berakhir dengan titik', () {
      expect(Validators.isValidEmail('user@example.'), isFalse);
    });

    test('menolak email dengan lebih dari satu @', () {
      expect(Validators.isValidEmail('user@@example.com'), isFalse);
    });
  });

  // ---------------------------------------------------------------
  // b) sanitize()
  // ---------------------------------------------------------------
  group('Validators.sanitize', () {
    test('mengubah tag script menjadi HTML entities', () {
      final result = Validators.sanitize('<script>alert(1)</script>');
      expect(result, '&lt;script&gt;alert(1)&lt;/script&gt;');
    });

    test('hasil tidak lagi mengandung karakter < dan >', () {
      final result = Validators.sanitize('<b>tebal</b><i>miring</i>');
      expect(result, isNot(contains('<')));
      expect(result, isNot(contains('>')));
    });

    test('mengubah tanda kutip ganda', () {
      expect(Validators.sanitize('a"b'), 'a&quot;b');
    });

    test('mengubah tanda kutip tunggal', () {
      expect(Validators.sanitize("it's"), 'it&#x27;s');
    });

    test('menetralkan atribut event handler berbahaya', () {
      final result = Validators.sanitize('<img src="x" onerror=\'alert(1)\'>');
      expect(
        result,
        '&lt;img src=&quot;x&quot; onerror=&#x27;alert(1)&#x27;&gt;',
      );
      expect(result, isNot(contains('<')));
    });

    test('membuang spasi di awal dan akhir', () {
      expect(Validators.sanitize('  halo  '), 'halo');
    });

    test('teks biasa tidak berubah', () {
      expect(Validators.sanitize('Halo Dunia 123'), 'Halo Dunia 123');
    });

    test('string kosong tetap kosong', () {
      expect(Validators.sanitize(''), '');
    });
  });

  // ---------------------------------------------------------------
  // c) validateText()
  // ---------------------------------------------------------------
  group('Validators.validateText', () {
    test('menolak null dan teks kosong atau hanya spasi', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
      expect(Validators.validateText(''), 'Field tidak boleh kosong');
      expect(Validators.validateText('   '), 'Field tidak boleh kosong');
    });

    test('memakai fieldName pada pesan error', () {
      expect(
        Validators.validateText('', fieldName: 'Nama'),
        'Nama tidak boleh kosong',
      );
    });

    test('menerima teks 1 karakter dengan batas default', () {
      expect(Validators.validateText('a'), isNull);
    });

    test('menolak teks lebih pendek dari minLength', () {
      expect(
        Validators.validateText(
          'ab',
          fieldName: 'Nama',
          minLength: 3,
          maxLength: 50,
        ),
        'Nama harus antara 3-50 karakter',
      );
    });

    test('menerima teks tepat sepanjang minLength (batas bawah)', () {
      expect(
        Validators.validateText('abc', minLength: 3, maxLength: 50),
        isNull,
      );
    });

    test('menerima teks tepat sepanjang maxLength (batas atas)', () {
      expect(
        Validators.validateText('a' * 50, minLength: 3, maxLength: 50),
        isNull,
      );
    });

    test('menolak teks lebih panjang dari maxLength', () {
      expect(
        Validators.validateText(
          'a' * 51,
          fieldName: 'Nama',
          minLength: 3,
          maxLength: 50,
        ),
        'Nama harus antara 3-50 karakter',
      );
    });

    test('batas default maksimal 100 karakter', () {
      expect(Validators.validateText('a' * 100), isNull);
      expect(
        Validators.validateText('a' * 101),
        'Field harus antara 1-100 karakter',
      );
    });

    test('panjang dihitung setelah spasi di tepi dibuang', () {
      expect(
        Validators.validateText('  ab  ', fieldName: 'Nama', minLength: 3),
        'Nama harus antara 3-100 karakter',
      );
    });
  });

  // ---------------------------------------------------------------
  // Tambahan: validator dari Latihan 3
  // ---------------------------------------------------------------
  group('Validators.validatePhone', () {
    test('menolak kosong', () {
      expect(Validators.validatePhone(''), 'Nomor telepon tidak boleh kosong');
    });

    test('menolak karakter selain angka', () {
      expect(
        Validators.validatePhone('0812abc4567'),
        'Nomor telepon hanya boleh berisi angka',
      );
    });

    test('menolak kurang dari 10 digit dan lebih dari 13 digit', () {
      expect(
        Validators.validatePhone('08123'),
        'Nomor telepon harus 10-13 digit',
      );
      expect(
        Validators.validatePhone('08123456789012'),
        'Nomor telepon harus 10-13 digit',
      );
    });

    test('menerima tepat 10 dan 13 digit', () {
      expect(Validators.validatePhone('0812345678'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });
  });

  group('Validators.validateUrl', () {
    test('menolak kosong', () {
      expect(Validators.validateUrl(''), 'URL tidak boleh kosong');
    });

    test('menolak URL tanpa http:// atau https://', () {
      const message = 'URL harus dimulai dengan http:// atau https://';
      expect(Validators.validateUrl('google.com'), message);
      expect(Validators.validateUrl('ftp://example.com'), message);
      expect(Validators.validateUrl('https://'), message);
    });

    test('menerima URL http dan https', () {
      expect(Validators.validateUrl('http://example.com'), isNull);
      expect(Validators.validateUrl('https://example.com/path?x=1'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('menolak kosong', () {
      expect(Validators.validatePassword(''), 'Password tidak boleh kosong');
    });

    test('menolak kurang dari 8 karakter', () {
      expect(
        Validators.validatePassword('Abcde1!'),
        'Password minimal 8 karakter',
      );
    });

    test('menolak tanpa huruf kapital', () {
      expect(
        Validators.validatePassword('abcdefg1!'),
        'Password harus mengandung huruf kapital',
      );
    });

    test('menolak tanpa angka', () {
      expect(
        Validators.validatePassword('Abcdefgh!'),
        'Password harus mengandung angka',
      );
    });

    test('menolak tanpa simbol', () {
      expect(
        Validators.validatePassword('Abcdefg1'),
        'Password harus mengandung simbol',
      );
    });

    test('menerima password yang memenuhi semua aturan', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
    });
  });
}
