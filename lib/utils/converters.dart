List<double> pathSum(List<List> data) {
  List<double> sums = [];
  for (var sublist in data) {
    double sum = sublist.reduce((value, element) => value + element);
    sums.add(sum);
  }
  return sums;
}
