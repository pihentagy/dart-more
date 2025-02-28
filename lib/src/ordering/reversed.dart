import 'ordering.dart';

class ReversedOrdering<T> extends Ordering<T> {
  const ReversedOrdering(this.ordering);

  final Ordering<T> ordering;

  @override
  int compare(T a, T b) => ordering.compare(b, a);

  @override
  Ordering<T> get reversed => ordering;
}
