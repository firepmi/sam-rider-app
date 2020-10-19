class Globals {
  static int stops = 1;
  static PriceOptional duration = PriceOptional.small;
  static CarSizeOptional carSize = CarSizeOptional.autoMobile;
  static WeightOptional weight = WeightOptional.option1;
}

enum PriceOptional { small, medium, large }
enum CarSizeOptional { autoMobile, suv, pickup, van, trailer, truck }
enum WeightOptional { option1, option2, option3, option4, option5, option6 }
