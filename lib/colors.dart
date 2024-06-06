import 'dart:math';

import 'package:flutter/material.dart' show Color;

final class SNColors {
  static const primary = Color(0XFFFADA5E);
  static const secondary = Color(0XFFF6911D);
  static const danger = Color(0XFFc03221);
  static const warning = secondary;
  static const info = Color(0XFF007cbe);
  static const success = Color(0XFF5c8001);
  static const twitter = Color(0XFF1da1f2);
  static const boost = Color(0XFF8c25f4);
  static const light = Color(0XFFf8f9fa);
  static const dark = Color(0XFF212529);
  static const nostr = Color(0XFF8d45dd);

  static const rainbow = [
    0XFFf6911d,
    0XFFf6921e,
    0XFFf6931f,
    0XFFf6941f,
    0XFFf69420,
    0XFFf69520,
    0XFFf69521,
    0XFFf69621,
    0XFFf69622,
    0XFFf69722,
    0XFFf69723,
    0XFFf69823,
    0XFFf69824,
    0XFFf69924,
    0XFFf69925,
    0XFFf69a25,
    0XFFf79a25,
    0XFFf79b26,
    0XFFf79c26,
    0XFFf79c27,
    0XFFf79d27,
    0XFFf79d28,
    0XFFf79e28,
    0XFFf79e29,
    0XFFf79f29,
    0XFFf79f2a,
    0XFFf7a02a,
    0XFFf7a02b,
    0XFFf7a12b,
    0XFFf7a12c,
    0XFFf7a22c,
    0XFFf7a32d,
    0XFFf7a42e,
    0XFFf7a52e,
    0XFFf7a52f,
    0XFFf7a62f,
    0XFFf7a630,
    0XFFf7a730,
    0XFFf7a731,
    0XFFf7a831,
    0XFFf7a832,
    0XFFf7a932,
    0XFFf7a933,
    0XFFf7aa33,
    0XFFf7aa34,
    0XFFf7ab34,
    0XFFf7ac35,
    0XFFf8ac35,
    0XFFf8ad36,
    0XFFf8ae36,
    0XFFf8ae37,
    0XFFf8af38,
    0XFFf8b038,
    0XFFf8b039,
    0XFFf8b139,
    0XFFf8b13a,
    0XFFf8b23a,
    0XFFf8b23b,
    0XFFf8b33b,
    0XFFf8b33c,
    0XFFf8b43c,
    0XFFf8b53d,
    0XFFf8b63e,
    0XFFf8b73f,
    0XFFf8b83f,
    0XFFf8b840,
    0XFFf8b940,
    0XFFf8b941,
    0XFFf8ba41,
    0XFFf8ba42,
    0XFFf8bb42,
    0XFFf8bb43,
    0XFFf8bc43,
    0XFFf8bd44,
    0XFFf8bd45,
    0XFFf8be45,
    0XFFf8bf46,
    0XFFf9bf46,
    0XFFf9c047,
    0XFFf9c147,
    0XFFf9c148,
    0XFFf9c248,
    0XFFf9c249,
    0XFFf9c349,
    0XFFf9c34a,
    0XFFf9c44a,
    0XFFf9c44b,
    0XFFf9c54b,
    0XFFf9c54c,
    0XFFf9c64c,
    0XFFf9c64d,
    0XFFf9c74d,
    0XFFf9c84e,
    0XFFf9c94f,
    0XFFf9ca4f,
    0XFFf9ca50,
    0XFFf9cb50,
    0XFFf9cb51,
    0XFFf9cc51,
    0XFFf9cc52,
    0XFFf9cd52,
    0XFFf9cd53,
    0XFFf9ce53,
    0XFFf9ce54,
    0XFFf9cf54,
    0XFFf9cf55,
    0XFFf9d055,
    0XFFf9d156,
    0XFFfad156,
    0XFFfad256,
    0XFFfad257,
    0XFFfad358,
    0XFFfad458,
    0XFFfad459,
    0XFFfad559,
    0XFFfad55a,
    0XFFfad65a,
    0XFFfad65b,
    0XFFfad75b,
    0XFFfad75c,
    0XFFfad85c,
    0XFFfad95d,
    0XFFfada5e,
    0XFFf9da5e,
    0XFFf9d95d,
    0XFFf8d95d,
    0XFFf7d95d,
    0XFFf7d85c,
    0XFFf6d85c,
    0XFFf6d75b,
    0XFFf5d75b,
    0XFFf4d75b,
    0XFFf4d65a,
    0XFFf3d65a,
    0XFFf2d65a,
    0XFFf2d559,
    0XFFf1d559,
    0XFFf1d558,
    0XFFf0d458,
    0XFFefd458,
    0XFFefd457,
    0XFFeed357,
    0XFFedd357,
    0XFFedd256,
    0XFFecd256,
    0XFFebd255,
    0XFFebd155,
    0XFFead155,
    0XFFead154,
    0XFFe9d054,
    0XFFe8d054,
    0XFFe8d053,
    0XFFe7cf53,
    0XFFe6cf52,
    0XFFe6ce52,
    0XFFe5ce52,
    0XFFe5ce51,
    0XFFe4cd51,
    0XFFe3cd51,
    0XFFe3cd50,
    0XFFe2cc50,
    0XFFe1cc4f,
    0XFFe0cb4f,
    0XFFdfcb4e,
    0XFFdeca4e,
    0XFFdeca4d,
    0XFFddc94d,
    0XFFdcc94d,
    0XFFdcc94c,
    0XFFdbc84c,
    0XFFdac84b,
    0XFFd9c74b,
    0XFFd9c74a,
    0XFFd8c74a,
    0XFFd7c64a,
    0XFFd7c649,
    0XFFd6c549,
    0XFFd5c548,
    0XFFd4c448,
    0XFFd3c447,
    0XFFd2c347,
    0XFFd2c346,
    0XFFd1c346,
    0XFFd0c245,
    0XFFcfc245,
    0XFFcec144,
    0XFFcdc044,
    0XFFccc043,
    0XFFcbbf42,
    0XFFcabf42,
    0XFFc9be41,
    0XFFc8be41,
    0XFFc7bd40,
    0XFFc6bc3f,
    0XFFc5bc3f,
    0XFFc4bb3e,
    0XFFc3bb3e,
    0XFFc2ba3d,
    0XFFc1ba3d,
    0XFFc0b93c,
    0XFFbfb93b,
    0XFFbfb83b,
    0XFFbeb83b,
    0XFFbdb73a,
    0XFFbcb73a,
    0XFFbbb639,
    0XFFbab638,
    0XFFbab538,
    0XFFb9b538,
    0XFFb8b537,
    0XFFb8b437,
    0XFFb7b437,
    0XFFb6b336,
    0XFFb5b335,
    0XFFb4b235,
    0XFFb3b234,
    0XFFb3b134,
    0XFFb2b134,
    0XFFb1b133,
    0XFFb1b033,
    0XFFb0b032,
    0XFFafb032,
    0XFFafaf32,
    0XFFaeaf31,
    0XFFaeae31,
    0XFFadae31,
    0XFFacae30,
    0XFFacad30,
    0XFFabad30,
    0XFFaaad2f,
    0XFFaaac2f,
    0XFFa9ac2e,
    0XFFa8ac2e,
    0XFFa8ab2e,
    0XFFa7ab2d,
    0XFFa7aa2d,
    0XFFa6aa2d,
    0XFFa5aa2c,
    0XFFa5a92c,
    0XFFa4a92b,
    0XFFa3a92b,
    0XFFa3a82b,
    0XFFa2a82a,
    0XFFa1a72a,
    0XFFa0a729,
    0XFF9fa628,
    0XFF9ea628,
    0XFF9ea528,
    0XFF9da527,
    0XFF9ca527,
    0XFF9ca427,
    0XFF9ba426,
    0XFF9aa325,
    0XFF99a325,
    0XFF98a224,
    0XFF97a224,
    0XFF97a124,
    0XFF96a123,
    0XFF95a022,
    0XFF94a022,
    0XFF939f21,
    0XFF929f21,
    0XFF919e20,
    0XFF909e20,
    0XFF8f9d1f,
    0XFF8e9c1e,
    0XFF8d9c1e,
    0XFF8c9b1d,
    0XFF8b9b1d,
    0XFF8a9a1c,
    0XFF899a1b,
    0XFF88991b,
    0XFF87981a,
    0XFF86981a,
    0XFF859719,
    0XFF849719,
    0XFF849718,
    0XFF839618,
    0XFF829617,
    0XFF819517,
    0XFF809516,
    0XFF7f9416,
    0XFF7f9415,
    0XFF7e9315,
    0XFF7d9315,
    0XFF7d9314,
    0XFF7c9214,
    0XFF7b9213,
    0XFF7a9113,
    0XFF7a9112,
    0XFF799112,
    0XFF789012,
    0XFF789011,
    0XFF778f11,
    0XFF768f10,
    0XFF758e10,
    0XFF748e0f,
    0XFF738d0f,
    0XFF738d0e,
    0XFF728d0e,
    0XFF718c0e,
    0XFF718c0d,
    0XFF708c0d,
    0XFF708b0d,
    0XFF6f8b0c,
    0XFF6e8a0c,
    0XFF6e8a0b,
    0XFF6d8a0b,
    0XFF6c890b,
    0XFF6c890a,
    0XFF6b890a,
    0XFF6b880a,
    0XFF6a8809,
    0XFF698809,
    0XFF698708,
    0XFF688708,
    0XFF678608,
    0XFF678607,
    0XFF668607,
    0XFF658507,
    0XFF658506,
    0XFF648506,
    0XFF648405,
    0XFF638405,
    0XFF628405,
    0XFF628304,
    0XFF618304,
    0XFF608304,
    0XFF608203,
    0XFF5f8203,
    0XFF5f8102,
    0XFF5e8102,
    0XFF5d8102,
    0XFF5d8001,
    0XFF5c8001,
    0XFF5c8002,
    0XFF5b8003,
    0XFF5b8004,
    0XFF5a8005,
    0XFF5a8006,
    0XFF598006,
    0XFF598007,
    0XFF598008,
    0XFF588009,
    0XFF58800a,
    0XFF57800b,
    0XFF57800c,
    0XFF56800c,
    0XFF56800d,
    0XFF56800e,
    0XFF55800f,
    0XFF558010,
    0XFF548011,
    0XFF548012,
    0XFF538013,
    0XFF538014,
    0XFF528015,
    0XFF528016,
    0XFF518017,
    0XFF518018,
    0XFF507f19,
    0XFF507f1a,
    0XFF4f7f1b,
    0XFF4f7f1c,
    0XFF4e7f1d,
    0XFF4e7f1e,
    0XFF4d7f1f,
    0XFF4d7f20,
    0XFF4d7f21,
    0XFF4c7f22,
    0XFF4b7f23,
    0XFF4b7f24,
    0XFF4b7f25,
    0XFF4a7f25,
    0XFF4a7f26,
    0XFF4a7f27,
    0XFF497f28,
    0XFF487f29,
    0XFF487f2a,
    0XFF487f2b,
    0XFF477f2b,
    0XFF477f2c,
    0XFF477f2d,
    0XFF467f2e,
    0XFF467f2f,
    0XFF457f30,
    0XFF457f31,
    0XFF447f31,
    0XFF447f32,
    0XFF447f33,
    0XFF437f34,
    0XFF437f35,
    0XFF427f36,
    0XFF427f37,
    0XFF417f38,
    0XFF417f39,
    0XFF407f3a,
    0XFF407f3b,
    0XFF3f7f3c,
    0XFF3f7f3d,
    0XFF3e7f3e,
    0XFF3e7f3f,
    0XFF3d7f40,
    0XFF3d7f41,
    0XFF3c7f42,
    0XFF3c7f43,
    0XFF3c7f44,
    0XFF3b7f44,
    0XFF3b7f45,
    0XFF3b7f46,
    0XFF3a7f47,
    0XFF397e48,
    0XFF397e49,
    0XFF397e4a,
    0XFF387e4a,
    0XFF387e4b,
    0XFF387e4c,
    0XFF377e4d,
    0XFF367e4e,
    0XFF367e4f,
    0XFF367e50,
    0XFF357e50,
    0XFF357e51,
    0XFF357e52,
    0XFF347e53,
    0XFF347e54,
    0XFF337e55,
    0XFF337e56,
    0XFF327e56,
    0XFF327e57,
    0XFF327e58,
    0XFF317e59,
    0XFF317e5a,
    0XFF307e5b,
    0XFF307e5c,
    0XFF2f7e5c,
    0XFF2f7e5d,
    0XFF2f7e5e,
    0XFF2e7e5f,
    0XFF2e7e60,
    0XFF2d7e61,
    0XFF2d7e62,
    0XFF2d7e63,
    0XFF2c7e63,
    0XFF2c7e64,
    0XFF2b7e65,
    0XFF2b7e66,
    0XFF2a7e67,
    0XFF2a7e68,
    0XFF2a7e69,
    0XFF297e69,
    0XFF297e6a,
    0XFF287e6b,
    0XFF287e6c,
    0XFF277e6d,
    0XFF277e6e,
    0XFF277e6f,
    0XFF267e6f,
    0XFF267e70,
    0XFF267e71,
    0XFF257e72,
    0XFF247e73,
    0XFF247e74,
    0XFF247e75,
    0XFF237e75,
    0XFF237e76,
    0XFF237e77,
    0XFF227d78,
    0XFF217d79,
    0XFF217d7a,
    0XFF217d7b,
    0XFF207d7b,
    0XFF207d7c,
    0XFF207d7d,
    0XFF1f7d7e,
    0XFF1f7d7f,
    0XFF1e7d80,
    0XFF1e7d81,
    0XFF1d7d82,
    0XFF1d7d83,
    0XFF1c7d84,
    0XFF1c7d85,
    0XFF1b7d86,
    0XFF1b7d87,
    0XFF1a7d88,
    0XFF1a7d89,
    0XFF197d8a,
    0XFF197d8b,
    0XFF187d8c,
    0XFF187d8d,
    0XFF187d8e,
    0XFF177d8e,
    0XFF177d8f,
    0XFF167d90,
    0XFF167d91,
    0XFF157d92,
    0XFF157d93,
    0XFF157d94,
    0XFF147d94,
    0XFF147d95,
    0XFF147d96,
    0XFF137d97,
    0XFF127d98,
    0XFF127d99,
    0XFF127d9a,
    0XFF117d9a,
    0XFF117d9b,
    0XFF117d9c,
    0XFF107d9d,
    0XFF0f7d9e,
    0XFF0f7d9f,
    0XFF0f7da0,
    0XFF0e7da1,
    0XFF0e7da2,
    0XFF0d7da3,
    0XFF0d7da4,
    0XFF0c7da5,
    0XFF0c7da6,
    0XFF0b7ca7,
    0XFF0b7ca8,
    0XFF0a7ca9,
    0XFF0a7caa,
    0XFF097cab,
    0XFF097cac,
    0XFF087cad,
    0XFF087cae,
    0XFF077caf,
    0XFF077cb0,
    0XFF067cb1,
    0XFF067cb2,
    0XFF067cb3,
    0XFF057cb3,
    0XFF057cb4,
    0XFF047cb5,
    0XFF047cb6,
    0XFF037cb7,
    0XFF037cb8,
    0XFF037cb9,
    0XFF027cb9,
    0XFF027cba,
    0XFF017cbb,
    0XFF017cbc,
    0XFF007cbd,
    0XFF007cbe,
    0XFF017cbe,
    0XFF017bbe,
    0XFF027bbf,
    0XFF037abf,
    0XFF047ac0,
    0XFF0479c0,
    0XFF0579c0,
    0XFF0679c0,
    0XFF0678c0,
    0XFF0778c1,
    0XFF0777c1,
    0XFF0877c1,
    0XFF0976c1,
    0XFF0a76c2,
    0XFF0b75c2,
    0XFF0c75c3,
    0XFF0c74c3,
    0XFF0d74c3,
    0XFF0e73c3,
    0XFF0f73c4,
    0XFF1072c4,
    0XFF1172c4,
    0XFF1171c5,
    0XFF1271c5,
    0XFF1370c5,
    0XFF1470c6,
    0XFF146fc6,
    0XFF156fc6,
    0XFF166ec6,
    0XFF166ec7,
    0XFF176ec7,
    0XFF186dc7,
    0XFF196dc8,
    0XFF196cc8,
    0XFF1a6cc8,
    0XFF1b6bc8,
    0XFF1b6bc9,
    0XFF1c6bc9,
    0XFF1d6ac9,
    0XFF1e6ac9,
    0XFF1e69ca,
    0XFF1f69ca,
    0XFF2068ca,
    0XFF2068cb,
    0XFF2167cb,
    0XFF2267cb,
    0XFF2366cb,
    0XFF2366cc,
    0XFF2466cc,
    0XFF2465cc,
    0XFF2565cc,
    0XFF2665cc,
    0XFF2664cd,
    0XFF2764cd,
    0XFF2863cd,
    0XFF2863ce,
    0XFF2963ce,
    0XFF2962ce,
    0XFF2a62ce,
    0XFF2b62ce,
    0XFF2b61cf,
    0XFF2c61cf,
    0XFF2d60cf,
    0XFF2e5fd0,
    0XFF2f5fd0,
    0XFF305ed0,
    0XFF305ed1,
    0XFF315ed1,
    0XFF315dd1,
    0XFF325dd1,
    0XFF335cd2,
    0XFF345cd2,
    0XFF355bd2,
    0XFF355bd3,
    0XFF365bd3,
    0XFF365ad3,
    0XFF375ad3,
    0XFF3859d4,
    0XFF3959d4,
    0XFF3a58d4,
    0XFF3b57d5,
    0XFF3c57d5,
    0XFF3c56d5,
    0XFF3d56d6,
    0XFF3e56d6,
    0XFF3e55d6,
    0XFF3f55d6,
    0XFF4054d7,
    0XFF4154d7,
    0XFF4253d7,
    0XFF4353d8,
    0XFF4352d8,
    0XFF4452d8,
    0XFF4551d9,
    0XFF4651d9,
    0XFF4750d9,
    0XFF484fda,
    0XFF494fda,
    0XFF494eda,
    0XFF4a4edb,
    0XFF4b4ddb,
    0XFF4c4ddb,
    0XFF4d4cdc,
    0XFF4e4cdc,
    0XFF4e4bdc,
    0XFF4f4bdc,
    0XFF504bdd,
    0XFF504add,
    0XFF514add,
    0XFF5249de,
    0XFF5348de,
    0XFF5448de,
    0XFF5547df,
    0XFF5647df,
    0XFF5646df,
    0XFF5746df,
    0XFF5746e0,
    0XFF5845e0,
    0XFF5945e0,
    0XFF5a44e1,
    0XFF5b44e1,
    0XFF5b43e1,
    0XFF5c43e1,
    0XFF5c43e2,
    0XFF5d42e2,
    0XFF5e42e2,
    0XFF5f41e3,
    0XFF6040e3,
    0XFF6140e3,
    0XFF613fe4,
    0XFF623fe4,
    0XFF633fe4,
    0XFF633ee4,
    0XFF643ee4,
    0XFF643ee5,
    0XFF653de5,
    0XFF663de5,
    0XFF663ce6,
    0XFF673ce6,
    0XFF683ce6,
    0XFF683be6,
    0XFF693be6,
    0XFF693be7,
    0XFF6a3ae7,
    0XFF6b3ae7,
    0XFF6c39e7,
    0XFF6c39e8,
    0XFF6d38e8,
    0XFF6e38e8,
    0XFF6e37e9,
    0XFF6f37e9,
    0XFF7036e9,
    0XFF7136e9,
    0XFF7136ea,
    0XFF7235ea,
    0XFF7335ea,
    0XFF7334ea,
    0XFF7434eb,
    0XFF7533eb,
    0XFF7633eb,
    0XFF7633ec,
    0XFF7732ec,
    0XFF7832ec,
    0XFF7831ec,
    0XFF7931ed,
    0XFF7a30ed,
    0XFF7b30ed,
    0XFF7b2fee,
    0XFF7c2fee,
    0XFF7d2eee,
    0XFF7e2eef,
    0XFF7f2def,
    0XFF802def,
    0XFF802cef,
    0XFF812cf0,
    0XFF822bf0,
    0XFF832bf1,
    0XFF842af1,
    0XFF852af1,
    0XFF8529f1,
    0XFF8629f2,
    0XFF8628f2,
    0XFF8728f2,
    0XFF8828f2,
    0XFF8827f2,
    0XFF8927f3,
    0XFF8a26f3,
    0XFF8b26f4,
    0XFF8b25f4,
    0XFF8c25f,
  ];

  static Color? getColor(int? meSats) {
    if (meSats == null || meSats == 0) {
      return null;
    }

    if (meSats <= 10) {
      return secondary;
    }

    final idx = min(
      (log(meSats) / log(10000)).floor() * (rainbow.length - 1),
      rainbow.length - 1,
    );

    return Color(rainbow[idx]);
  }
}
