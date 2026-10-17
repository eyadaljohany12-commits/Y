class Chess960Generator {
  static const _lightBishop = [1, 3, 5, 7];
  static const _darkBishop  = [0, 2, 4, 6];
  static const _knightPairs = [
    [0, 1], [0, 2], [0, 3], [0, 4],
    [1, 2], [1, 3], [1, 4],
    [2, 3], [2, 4],
    [3, 4],
  ];

  static List<String> generate(int id) {
    assert(id >= 0 && id < 960, 'Position ID must be in [0, 959]');
    final rank = List<String?>.filled(8, null);
    int n = id;

    rank[_lightBishop[n % 4]] = 'B';
    n ~/= 4;

    rank[_darkBishop[n % 4]] = 'B';
    n ~/= 4;

    rank[_nthEmpty(rank, (n % 6) + 1)] = 'Q';
    n ~/= 6;

    final empty = _emptyIndices(rank);
    final kp = _knightPairs[n];
    rank[empty[kp[0]]] = 'N';
    rank[empty[kp[1]]] = 'N';

    final rem = _emptyIndices(rank);
    rank[rem[0]] = 'R';
    rank[rem[1]] = 'K';
    rank[rem[2]] = 'R';

    return rank.cast<String>();
  }

  static String toFen(int id) {
    final rank = generate(id);
    final back = rank.join();

    final qIdx = rank.indexOf('R');
    final kIdx = rank.lastIndexOf('R');
    final qFile = String.fromCharCode(97 + qIdx);
    final kFile = String.fromCharCode(97 + kIdx);

    final white = '${qFile.toUpperCase()}${kFile.toUpperCase()}';
    final black = '${qFile.toLowerCase()}${kFile.toLowerCase()}';

    return '$back/pppppppp/8/8/8/8/PPPPPPPP/$back w $white$black - 0 1';
  }

  static List<int> _emptyIndices(List<String?> rank) {
    final out = <int>[];
    for (var i = 0; i < rank.length; i++) {
      if (rank[i] == null) out.add(i);
    }
    return out;
  }

  static int _nthEmpty(List<String?> rank, int n) {
    var count = 0;
    for (var i = 0; i < rank.length; i++) {
      if (rank[i] == null) {
        count++;
        if (count == n) return i;
      }
    }
    throw StateError('No empty square');
  }
}
