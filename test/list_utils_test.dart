
import 'package:clue/core/list_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('List utils looped', () {

    final list = ['apple', 'pear', 'banana', 'kiwi'];
    expect(list.loopedFromIndex(0).first, 'apple');
    expect(list.loopedFromIndex(0).last, 'kiwi');
    expect(list.loopedFromIndex(0).length, 4);

    expect(list.loopedFromIndex(1).first, 'pear');
    expect(list.loopedFromIndex(1).last, 'apple');
    expect(list.loopedFromIndex(1).length, 4);

    expect(list.loopedFromIndex(2).first, 'banana');
    expect(list.loopedFromIndex(2).last, 'pear');
    expect(list.loopedFromIndex(2).length, 4);

    expect(list.loopedFromIndex(3).first, 'kiwi');
    expect(list.loopedFromIndex(3).last, 'banana');
    expect(list.loopedFromIndex(3).length, 4);

  });
}