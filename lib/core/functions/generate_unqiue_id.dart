import 'package:uuid/uuid.dart';

String generateUniqueID() {
  const uuid = Uuid();
  String uniqueId = uuid.v4();
  return uniqueId;
}
