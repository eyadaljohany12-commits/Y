import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import '../engine/chess960_generator.dart';
import '../theme/shatr_colors.dart';
import '../widgets/glass_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Position _position;
  late int _positionId;
  Square? _selected;
  Map<Square, Set<Square>> _legal = {};
  final List<String> _history = [];
  String? _status;

  @override
  void initState() {
    super.initState();
    _positionId = DateTime.now().millisecondsSinceEpoch % 960;
    _initPosition();
  }

  void _initPosition() {
    final fen = Chess960Generator.toFen(_positionId);
    try {
      _position = Chess.fromSetup(Setup.parseFen(fen));
    } catch (_) {
      _position = Chess.initial;
    }
    _refresh();
  }

  void _refresh() {
    final m = <Square, Set<Square>>{};
    _position.legalMoves.forEach((from, to) => m[from] = to);
    setState(() => _legal = m);
    _updateStatus();
  }

  void _updateStatus() {
    if (_position.isCheckmate) {
      _status = 'كش مات — ${_position.turn == Side.white ? "الأسود يفوز" : "الأبيض يفوز"}';
    } else if (_position.isStalemate) {
      _status = 'تعادل — لا نقلات قانونية';
    } else if (_position.isCheck) {
      _status = 'كش!';
    } else {
      _status = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.5),
            radius: 1.2,
            colors: [Color(0xFF1A0A0D), ShatrColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              if (_status != null) _statusBanner(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _board(),
                ),
              ),
              Expanded(
                flex: 1,
                child: GlassCard(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: _historyPane(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GlassCard(
            opacity: 0.1,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الوضعية',
                      style: TextStyle(
                          fontSize: 10, color: ShatrColors.textSecondary)),
                  Text('#$_positionId',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ShatrColors.accentRed)),
                ],
              ),
            ),
          ),
          const Spacer(),
          GlassCard(
            opacity: 0.1,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _position.turn == Side.white
                          ? Colors.white
                          : ShatrColors.accentRed,
                      boxShadow: [
                        BoxShadow(
                          color: _position.turn == Side.white
                              ? Colors.white54
                              : ShatrColors.accentRedGlow,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _position.turn == Side.white ? 'دور الأبيض' : 'دور الأسود',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ShatrColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        opacity: 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(_status!,
              style: const TextStyle(
                  color: ShatrColors.accentRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
        ),
      ),
    );
  }

  Widget _board() {
    return LayoutBuilder(builder: (_, c) {
      final size = c.maxWidth;
      final sq = size / 8;
      return Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(children: [
              _squares(sq),
              ..._pieces(sq),
            ]),
          ),
        ),
      );
    });
  }

  Widget _squares(double sq) {
    return Column(
      children: List.generate(8, (rIdx) {
        final rank = 7 - rIdx;
        return Row(
          children: List.generate(8, (file) {
            final isLight = (file + rank) % 2 == 0;
            final square = Square.values.firstWhere(
                (s) => s.file == file && s.rank == rank);
            final isSel = _selected == square;
            final targets =
                _selected != null ? (_legal[_selected!] ?? {}) : <Square>{};
            final isTarget = targets.contains(square);
            final isCapture =
                isTarget && _position.board.pieceAt(square) != null;
            return GestureDetector(
              onTap: () => _onTap(square),
              child: Container(
                width: sq,
                height: sq,
                decoration: BoxDecoration(
                  color: isLight
                      ? ShatrColors.boardLight
                      : ShatrColors.boardDark,
                  border: isSel
                      ? Border.all(color: ShatrColors.accentRed, width: 2)
                      : null,
                ),
                child: Stack(children: [
                  if (isTarget)
                    Center(
                      child: Container(
                        width: isCapture ? sq * 0.85 : sq * 0.3,
                        height: isCapture ? sq * 0.85 : sq * 0.3,
                        decoration: BoxDecoration(
                          shape: isCapture
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius:
                              isCapture ? BorderRadius.circular(4) : null,
                          border: isCapture
                              ? Border.all(
                                  color: ShatrColors.highlightCapture,
                                  width: 3)
                              : null,
                          color: isCapture
                              ? Colors.transparent
                              : ShatrColors.highlightMove,
                          boxShadow: [
                            BoxShadow(
                                color: ShatrColors.highlightMove,
                                blurRadius: 8),
                          ],
                        ),
                      ),
                    ),
                ]),
              ),
            );
          }),
        );
      }),
    );
  }

  List<Widget> _pieces(double sq) {
    final out = <Widget>[];
    for (var r = 0; r < 8; r++) {
      for (var f = 0; f < 8; f++) {
        final s =
            Square.values.firstWhere((x) => x.file == f && x.rank == r);
        final p = _position.board.pieceAt(s);
        if (p == null) continue;
        out.add(Positioned(
          left: f * sq,
          top: (7 - r) * sq,
          width: sq,
          height: sq,
          child: GestureDetector(
            onTap: () => _onTap(s),
            child: Center(
              child: Text(
                _glyph(p),
                style: TextStyle(
                  fontSize: sq * 0.65,
                  color: p.color == Side.white
                      ? Colors.white
                      : ShatrColors.textPrimary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      }
    }
    return out;
  }

  String _glyph(Piece p) {
    final w = p.color == Side.white;
    switch (p.role) {
      case Role.king:
        return w ? '♔' : '♚';
      case Role.queen:
        return w ? '♕' : '♛';
      case Role.rook:
        return w ? '♖' : '♜';
      case Role.bishop:
        return w ? '♗' : '♝';
      case Role.knight:
        return w ? '♘' : '♞';
      case Role.pawn:
        return w ? '♙' : '♟';
    }
  }

  void _onTap(Square s) {
    if (_selected != null) {
      final targets = _legal[_selected!] ?? {};
      if (targets.contains(s)) {
        _move(_selected!, s);
        return;
      }
    }
    final p = _position.board.pieceAt(s);
    if (p != null && p.color == _position.turn) {
      setState(() => _selected = s);
    } else {
      setState(() => _selected = null);
    }
  }

  void _move(Square from, Square to) {
    final fromPiece = _position.board.pieceAt(from);
    final toPiece = _position.board.pieceAt(to);
    NormalMove mv;
    if (fromPiece?.role == Role.king &&
        toPiece?.role == Role.rook &&
        toPiece?.color == fromPiece?.color) {
      mv = NormalMove(from: from, to: to);
    } else if (fromPiece?.role == Role.pawn &&
        (to.rank == 7 || to.rank == 0)) {
      mv = NormalMove(from: from, to: to, promotion: Role.queen);
    } else {
      mv = NormalMove(from: from, to: to);
    }

    try {
      final np = _position.play(mv);
      setState(() {
        _position = np;
        _selected = null;
        _history.add(mv.toString());
      });
      _refresh();
    } catch (_) {
      setState(() => _selected = null);
    }
  }

  Widget _historyPane() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'سجل النقلات',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ShatrColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _history.isEmpty
                ? const Center(
                    child: Text('لا توجد نقلات بعد',
                        style: TextStyle(color: ShatrColors.textSecondary)))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (_, i) => Text(
                      '${i + 1}. ${_history[i]}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ShatrColors.textPrimary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
