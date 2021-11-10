import 'dart:math';

class RandomUtils {
  static double randomDouble(double min, double max) {
    Random random = new Random();
    double value = random.nextDouble();
    return min + value * (max - min);
  }

  static bool randomBool() {
    Random random = new Random();
    return random.nextBool();
  }
}
