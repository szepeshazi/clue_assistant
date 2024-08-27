import 'package:clue/models/clues.dart';

class AccusationResponse {
  AccusationResponse({
    required this.hasEvidence,
    this.evidence,
  });

  final bool hasEvidence;
  final ClueItem? evidence;

  @override
  String toString() {
    return 'Response{hasEvidence: $hasEvidence, evidence: $evidence}';
  }
}
