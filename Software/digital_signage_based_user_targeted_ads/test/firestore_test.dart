import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

void main() {
  group("unit testing for firestore retrieve", () {
    MockFirestoreInstance instance;
    setUp(() {
      instance = MockFirestoreInstance();
    });

    test('data with server timestamp', () async {
      // arrange
      final collectionRef = instance.collection('MacAddresses');
      final data1 = {'Mac1': '1313'};
      final data2 = {'Mac1': '1212'};
      final data3 = {'Mac1': '1414', 'Mac2': '1010'};
      // act
      await collectionRef.add(data1);
      await collectionRef.add(data2);
      await collectionRef.add(data3);

      // assert
      final addresses =
          await instance.collection('MacAddresses').getDocuments();
      String inputMac = "1010";
      bool macExist = false;

      print(instance.dump());
      for (var mac in addresses.documents) {
        for (var val in mac.data.values) {
          if (val == inputMac) {
            macExist = true;
            break;
          }
        }
      }
      expect(macExist, true);
    });
  });
}
