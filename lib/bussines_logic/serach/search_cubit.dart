import 'package:bloc/bloc.dart';

import '../../model/restaurant/restaurant_model.dart';
part 'search_state.dart';

class SearchLogic extends Cubit<SearchState> {
  SearchLogic() : super(SearchInitial()) {
    resSearch = Restaurant.restaurantsByCategory;
  }

  List<Restaurant> resSearch = [];

  void searchFuncation({required String keyWord}) {
    resSearch = Restaurant.restaurantsByCategory.where((restaurant) {
      final title = restaurant.name.toString().toLowerCase();
      final input = keyWord.toLowerCase();
      return title.contains(input);
    }).toList();
    emit(SearchSuccess());
  }
}
