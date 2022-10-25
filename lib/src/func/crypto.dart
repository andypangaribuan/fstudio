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

  String uint8ToHex(Uint8List byteArr) {
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

  String aesECBEncrypt({required String key, required String value}) {
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
    return uint8ToHex(cipherText);
  }
}
