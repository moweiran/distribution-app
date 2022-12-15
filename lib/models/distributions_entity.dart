import 'package:distribution_app/models/enums/distribution_platform.dart';

class DistributionEntity {
  int id;
  String name;
  int platform;
  String env;
  String workingDirectory;
  String cmdText;
  Function? kill;
  DistributionEntity({
    required this.id,
    required this.name,
    required this.platform,
    required this.env,
    required this.workingDirectory,
    required this.cmdText,
    this.kill,
  });
}

extension DistributionEntityExtension on DistributionEntity {
  String get platformText {
    final p = DistributionPlatform.values[platform];
    switch (p) {
      case DistributionPlatform.android:
        return "Android";
      case DistributionPlatform.ios:
        return "iOS";
    }
  }
}
