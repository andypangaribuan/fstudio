/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of f_guide;

class _Crypto {
  _Crypto._();

  String _uint8ListToHex(Uint8List byteArr) {
    if (byteArr.isEmpty) {
      return "";
    }

    Uint8List result = Uint8List(byteArr.length << 1);
    const hexTable = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

    for (var i = 0; i < byteArr.length; i++) {
      var bit = byteArr[i];
      var index = bit >> 4 & 15;
      var i2 = i << 1;
      result[i2] = hexTable[index].codeUnitAt(0);
      index = bit & 15;
      result[i2 + 1] = hexTable[index].codeUnitAt(0);
    }

    return String.fromCharCodes(result);
  }

  Uint8List _hexToUint8List(String hex) {
    if (hex.length % 2 != 0) {
      throw 'odd number of hex digits';
    }

    var length = hex.length ~/ 2;
    var result = Uint8List(length);

    for (var i = 0; i < length; ++i) {
      var num = int.parse(hex.substring(i * 2, (2 * (i + 1))), radix: 16);
      if (num.isNaN) {
        throw 'expected hex string';
      }

      result[i] = num;
    }

    return result;
  }

  Uint8List aesECBEncryptRaw({required String key, required String value}) {
    Uint8List keyData = Uint8List.fromList(utf8.encode(key));
    Uint8List plainText = Uint8List.fromList(utf8.encode(value));

    PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      ECBBlockCipher(AESEngine()),
    );

    cipher.init(
      true,
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        KeyParameter(keyData),
        null,
      ),
    );

    final cipherText = cipher.process(plainText);
    return cipherText;
  }

  String aesECBEncrypt({required String key, required String value}) {
    final cipherText = aesECBEncryptRaw(key: key, value: value);
    return _uint8ListToHex(cipherText);
  }

  Uint8List aesECBDecryptRaw({required String key, required String value}) {
    Uint8List keyData = Uint8List.fromList(utf8.encode(key));

    PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      ECBBlockCipher(AESEngine()),
    );

    cipher.init(
      false,
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        KeyParameter(keyData),
        null,
      ),
    );

    final val = _hexToUint8List(value);
    final cipherText = cipher.process(val);
    return cipherText;
  }

  String aesECBDecrypt({required String key, required String value}) {
    final cipherText = aesECBDecryptRaw(key: key, value: value);
    return String.fromCharCodes(cipherText);
  }
}
