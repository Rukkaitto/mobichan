import 'dart:math';

class RandomUtils {
  static double randomDouble(double min, double max) {
    Random random = Random();
    double value = random.nextDouble();
    return min + value * (max - min);
  }

  static int randomInt(int min, int max) {
    Random random = Random();
    return random.nextInt(max - min) + min;
  }

  static bool randomBool() {
    Random random = Random();
    return random.nextBool();
  }
}
