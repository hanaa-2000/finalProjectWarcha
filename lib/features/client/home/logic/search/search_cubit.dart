import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_model.dart';

part 'search_state.dart';

enum SearchFilterType { all, workshops, products, mechanics }


class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إضافة متغير لتخزين المدينة أو السعر الذي سيتم تصفيته
  String? cityFilter;
  double? minPriceFilter;
  double? maxPriceFilter;




  List<WorkshopModel> _workshops = [];
  List<AccessoriesModel> _products = [];
  List<String> _mechanics = [];

  List<dynamic> searchResults = [];
  SearchFilterType currentFilter = SearchFilterType.all;

  Future<void> fetchAllData() async {
    emit(SearchFilterLoading());

    try {
      final workshopsSnapshot = await _firestore.collection('users').where('userType', isEqualTo: 'workshop').get();
      _workshops = workshopsSnapshot.docs.map((doc) => WorkshopModel.fromJson(doc.data(), doc.id)).toList();

      final productsSnapshot = await _firestore.collection('products').get();
      _products = productsSnapshot.docs.map((doc) => AccessoriesModel.fromDocument(doc, doc.id)).toList();

      // تحميل كل الميكانيكيين من كافة الورش
      List<String> allMechanics = [];

      for (var workshopDoc in workshopsSnapshot.docs) {
        final workshopId = workshopDoc.id;

        final mechanicsSnapshot = await _firestore
            .collection('mechanicals')
            .doc(workshopId)
            .collection('mechanics')
            .get();

        final mechanics = mechanicsSnapshot.docs
            .map((doc) => doc['name'] as String)
            .toList();

        allMechanics.addAll(mechanics);
      }

      _mechanics = allMechanics;
      emit(SearchFilterLoaded());
    } catch (e) {
      emit(SearchFilterError('حدث خطأ أثناء تحميل البيانات'));
    }
  }

  void searchFilter(String query , {bool isFromFilterButton = false}) {
    if (query.isEmpty && !isFromFilterButton) {
      searchResults = [];
      emit(SearchFilterLoaded());
      return;
    }

    final lowerQuery = query.toLowerCase();

    final workshopMatches = _workshops.where((w) => w.name.toLowerCase().contains(lowerQuery)||w.location!.toLowerCase().contains(lowerQuery)).toList();
    final productMatches = _products.where((p) => p!.companyName.toLowerCase().contains(lowerQuery)).toList();
    final mechanicMatches = _mechanics
        .where((name) => name.toLowerCase().contains(lowerQuery))
        .toList();
    switch (currentFilter) {
      case SearchFilterType.all:
        searchResults = [...workshopMatches, ...productMatches,
          ...mechanicMatches
        ];
        break;
      case SearchFilterType.workshops:
        searchResults = [...workshopMatches];
        break;
      case SearchFilterType.products:
        searchResults = [...productMatches];
        break;
      case SearchFilterType.mechanics:
        searchResults = [];
       [...mechanicMatches];
        break;
    }

    emit(SearchFilterLoaded());
  }

  // void updateFilter(SearchFilterType filterType, String currentQuery) {
  //   currentFilter = filterType;
  //   search(currentQuery);
  // }
 // bool isFromFilterButton= false;
  void updateFilter(SearchFilterType filter, String query) {
    currentFilter = filter;
      if (filter == SearchFilterType.mechanics) {
        searchResults = _mechanics.where((name) => name.contains(query)).toList();
      }

    searchFilter(query, isFromFilterButton: true); // هنا نمرر فلتر مخصوص
  }


  Future<void> fetchData() async {
    try {
      emit(SearchLoading());

      // جلب بيانات المنتجات
      final productsSnapshot = await _firestore.collection(productCollection).get();
      final products = productsSnapshot.docs.map((doc) => doc.data()).toList();
      // جلب بيانات الورش
      // final workshopsSnapshot = await _firestore.collection('workshops').get();
      // final workshops = workshopsSnapshot.docs.map((doc) => doc.data()).toList();

      final querySnapshot = await _firestore
          .collection(usersCollection)
          .where("userType", isEqualTo: "workshop")
          .get();
      final workshops = querySnapshot.docs.map((doc) => doc.data()).toList();
      final List<Map<String ,dynamic>> allItems = [...products, ...workshops];

      emit(SearchLoaded(allItems: allItems));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }


  // البحث
  void search(String query) {

    if (state is SearchLoaded) {
      final allItems = (state as SearchLoaded).allItems;

      // فلترة حسب المدينة أو السعر إذا تم تحديد فلاتر
      final filteredItems = allItems.where((item) {
        final name = item['userName']?.toLowerCase() ?? '';
        final phone = item['phone']?.toLowerCase() ?? '';
        final location = item['location']?.toLowerCase() ?? '';
        final carType = item['specifications']?.toLowerCase() ?? '';
        final productName = item['companyName']?.toLowerCase() ?? '';
        final city = item['countryManufacture']?.toLowerCase() ?? ''; // المدينة
        final price = item['price'] ?? ''; // السعر

        bool matchesQuery = name.contains(query.toLowerCase()) ||
            phone.contains(query.toLowerCase()) ||
            location.contains(query.toLowerCase()) ||
            carType.contains(query.toLowerCase()) ||
            productName.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase()) ||
            price.contains(query.toLowerCase()) ||

            productName.contains(query.toLowerCase());

        bool matchesCity = cityFilter == null || city.contains(cityFilter!.toLowerCase());
        bool matchesPrice = (minPriceFilter == null || price >= minPriceFilter!) &&
            (maxPriceFilter == null || price <= maxPriceFilter!);

        return matchesQuery && matchesCity && matchesPrice;
      }).toList();
      print("All fetched items: ${allItems.length}");
      print("First item: ${allItems[0]}");
      emit(SearchLoaded(allItems: allItems, filteredItems: filteredItems));
    }
  }

  // دالة لتعيين الفلاتر الخاصة بالمدينة والسعر
  void setCityFilter(String? city) {
    cityFilter = city;
    search(''); // أعد البحث بعد تغيير الفلتر
  }

  void setPriceFilter(double? minPrice, double? maxPrice) {
    minPriceFilter = minPrice;
    maxPriceFilter = maxPrice;
    search(''); // أعد البحث بعد تغيير الفلتر
  }

}
