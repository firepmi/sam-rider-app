class Globals {
  static int stops = 0;
  static PriceOptional duration = PriceOptional.small;
  static CarSizeOptional carSize = CarSizeOptional.motorScooter;
  static WeightOptional weight = WeightOptional.pound1to5;
}

enum PriceOptional { small, medium, large }
enum CarSizeOptional { motorScooter, autoMobile, suv, pickup, van, truck }
enum WeightOptional { pound1to5, pound6to49, pound50more }
