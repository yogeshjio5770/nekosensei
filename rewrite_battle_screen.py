import os

screen_content = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../services/battle_service.dart';

enum BattleState { matchmaking, live, ghost, finished }

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  BattleState _state = BattleState.matchmaking;
  
  String? _battleId;
  bool _isPlayer1 = true;
  StreamSubscription? _battleSub;
  
  int _timeLeft = 60;
  Timer? _timer;
  Timer? _matchmakingTimer;
  
  int _myScore = 0;
  int _opponentScore = 0;
  String _opponentName = 'Searching...';
  
  final List<Map<String, dynamic>> _questions = [
    {'q': '猫', 'a': 'Cat', 'opts': ['Cat', 'Dog', 'Bird', 'Fish']},
    {'q': '水', 'a': 'Water', 'opts': ['Water', 'Fire', 'Earth', 'Wind']},
    {'q': '本', 'a': 'Book', 'opts': ['Book', 'Pen', 'Desk', 'Chair']},
    {'q': '食べる', 'a': 'Eat', 'opts': ['Eat', 'Drink', 'Sleep', 'Run']},
    {'q': '行く', 'a': 'Go', 'opts': ['Go', 'Come', 'Stop', 'Wait']},
    {'q': '車', 'a': 'Car', 'opts': ['Car', 'Bus', 'Train', 'Bike']},
    {'q': '新しい', 'a': 'New', 'opts': ['New', 'Old', 'Big', 'Small']},
  ];

  Map<String, dynamic> _currentQ = {};

  @override
  void initState() {
    super.initState();
    _startMatchmaking();
  }

  Future<void> _startMatchmaking() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      _startGhostBattle();
      return;
    }

    try {
      _battleId = await ref.read(battleServiceProvider).joinMatchmaking(user.uid, user.displayName ?? 'Player');
      
      // Start 10 second timeout for fallback
      _matchmakingTimer = Timer(const Duration(seconds: 10), () {
        if (_state == BattleState.matchmaking) {
          _cancelMatchmakingAndGhost();
        }
      });

      _battleSub = ref.read(battleServiceProvider).getBattleStream(_battleId!).listen((doc) {
        if (!doc.exists) return;
        final data = doc.data() as Map<String, dynamic>;
        
        if (_state == BattleState.matchmaking && data['status'] == 'active') {
          // Battle started!
          _matchmakingTimer?.cancel();
          setState(() {
            _state = BattleState.live;
            _isPlayer1 = data['player1Id'] == user.uid;
            _opponentName = _isPlayer1 ? data['player2Name'] : data['player1Name'];
          });
          _nextQuestion();
          _startBattleTimer();
        } else if (_state == BattleState.live) {
          // Update scores
          setState(() {
            if (_isPlayer1) {
              _myScore = data['player1Score'] ?? 0;
              _opponentScore = data['player2Score'] ?? 0;
            } else {
              _myScore = data['player2Score'] ?? 0;
              _opponentScore = data['player1Score'] ?? 0;
            }
          });
        }
      });
    } catch (e) {
      _startGhostBattle();
    }
  }

  void _cancelMatchmakingAndGhost() async {
    _matchmakingTimer?.cancel();
    _battleSub?.cancel();
    if (_battleId != null) {
      await ref.read(battleServiceProvider).cancelMatchmaking(_battleId!);
    }
    _startGhostBattle();
  }

  Future<void> _startGhostBattle() async {
    _matchmakingTimer?.cancel();
    _battleSub?.cancel();
    
    final opponent = await ref.read(battleServiceProvider).findGhostOpponent();
    setState(() {
      _state = BattleState.ghost;
      _opponentName = opponent['displayName'];
    });
    
    _nextQuestion();
    _startBattleTimer(ghostOpponent: opponent);
  }

  void _nextQuestion() {
    final q = _questions[Random().nextInt(_questions.length)];
    final opts = List<String>.from(q['opts'])..shuffle();
    setState(() {
      _currentQ = {
        'q': q['q'],
        'a': q['a'],
        'opts': opts,
      };
    });
  }

  void _startBattleTimer({Map<String, dynamic>? ghostOpponent}) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
          if (_state == BattleState.ghost && ghostOpponent != null) {
            final targetScore = ghostOpponent['finalScore'] as int;
            if (_opponentScore < targetScore && Random().nextDouble() > 0.7) {
              _opponentScore++;
            }
          }
        });
      } else {
        _endBattle(ghostOpponent: ghostOpponent);
      }
    });
  }

  Future<void> _endBattle({Map<String, dynamic>? ghostOpponent}) async {
    _timer?.cancel();
    setState(() {
      _state = BattleState.finished;
    });

    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final won = _myScore > _opponentScore;
      if (_battleId != null && ghostOpponent == null) {
        await ref.read(battleServiceProvider).endBattle(_battleId!, user.uid, won);
      } else if (ghostOpponent != null) {
        await ref.read(battleServiceProvider).submitGhostBattleResult(
          userId: user.uid,
          myScore: _myScore,
          opponentScore: _opponentScore,
          opponentId: ghostOpponent['uid'],
        );
      }
      ref.invalidate(currentUserProvider);
    }
  }

  void _answer(String selected) {
    if (_state == BattleState.finished) return;
    
    if (selected == _currentQ['a']) {
      if (_state == BattleState.live && _battleId != null) {
        ref.read(battleServiceProvider).incrementScore(_battleId!, _isPlayer1);
      } else if (_state == BattleState.ghost) {
        setState(() {
          _myScore++;
        });
      }
    }
    _nextQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _matchmakingTimer?.cancel();
    _battleSub?.cancel();
    if (_state == BattleState.matchmaking && _battleId != null) {
      ref.read(battleServiceProvider).cancelMatchmaking(_battleId!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state == BattleState.matchmaking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Finding live opponent...'),
              const SizedBox(height: 8),
              Text('Starting ghost battle in 10s if no match found.', 
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    if (_state == BattleState.finished) {
      final won = _myScore > _opponentScore;
      final tie = _myScore == _opponentScore;
      return Scaffold(
        backgroundColor: won ? AppColors.success : (tie ? Colors.orange : AppColors.error),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                won ? 'YOU WIN!' : (tie ? 'TIE!' : 'YOU LOSE!'),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text('Your Score: $_myScore', style: const TextStyle(fontSize: 24, color: Colors.white)),
              Text('$_opponentName Score: $_opponentScore', style: const TextStyle(fontSize: 24, color: Colors.white)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Training'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('⏱️ 00:${_timeLeft.toString().padLeft(2, '0')}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('YOU', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('$_myScore', style: const TextStyle(fontSize: 32, color: AppColors.primary)),
                  ],
                ),
                Text(_state == BattleState.ghost ? 'VS (Ghost)' : 'VS (Live)', 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                Column(
                  children: [
                    Text(_opponentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('$_opponentScore', style: const TextStyle(fontSize: 32, color: AppColors.error)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentQ['q'],
                    style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 48),
                  ...(_currentQ['opts'] as List<String>).map((opt) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                        ),
                        onPressed: () => _answer(opt),
                        child: Text(opt, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
"""

with open(r'c:\duolingo\lib\screens\practice\battle_screen.dart', 'w', encoding='utf-8') as f:
    f.write(screen_content)
print("Updated battle_screen.dart")
