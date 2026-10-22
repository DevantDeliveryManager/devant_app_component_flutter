enum PriceFormat { inr, usd }

enum SessionType { online, inPerson }

extension SessionTypeExtension on SessionType {
  String get value {
    switch (this) {
      case SessionType.online:
        return 'online';
      case SessionType.inPerson:
        return 'in_person';
    }
  }
}
