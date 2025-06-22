import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';
import 'package:warcha_final_progect/features/client/home/logic/search/search_cubit.dart';
import 'package:warcha_final_progect/features/client/home/ui/warcha_screen.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_model.dart';
//
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
//
// class _SearchScreenState extends State<SearchScreen> {
//   final searchController = TextEditingController();
//   final minPriceController = TextEditingController();
//   final maxPriceController = TextEditingController();
//
//   String? selectedCity;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<SearchCubit>().fetchData();
//   }
//
//   void _resetFilters() {
//     searchController.clear();
//     minPriceController.clear();
//     maxPriceController.clear();
//     selectedCity = null;
//
//     context.read<SearchCubit>().setCityFilter(null);
//     context.read<SearchCubit>().setPriceFilter(null, null);
//     context.read<SearchCubit>().search('');
//     setState(() {}); // لتحديث الواجهة
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Search"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _resetFilters,
//             tooltip: "Delete Filter",
//           )
//         ],
//       ),
//       body: Padding(
//         padding:  EdgeInsets.all(16.0.r),
//         child: Column(
//           children: [
//             // 🔍 حقل البحث
//
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 filled: true,
//                 fillColor: Colors.grey[50],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16.r),
//                     borderSide: BorderSide(color: Colors.blue.shade200)
//                 ),
//                 focusedBorder:OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16.r),
//                   borderSide: BorderSide(color: Colors.blue.shade200,width: 1)
//                                   ),
//                 enabledBorder:OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16.r),
//                     borderSide: BorderSide(color: Colors.black,width: 1)
//                 ),
//                 suffixIcon: Icon(Icons.search, color: Colors.blue),
//               ),
//               onChanged: (value) => context.read<SearchCubit>().search(value),
//             ),
//
//              SizedBox(height: 10.h),
//
//             // 🎯 فلاتر المدينة والسعر
//             // Row(
//             //   children: [
//             //     Expanded(
//             //       flex: 2,
//             //       child: DropdownButtonFormField<String>(
//             //         value: selectedCity,
//             //         decoration: InputDecoration(
//             //           labelText: "",
//             //           fillColor: Colors.blue[50],
//             //           filled: true,
//             //           border: OutlineInputBorder(),
//             //         ),
//             //         items: ["", "القاهرة", "الجيزة", "الاسكندرية"].map((city) {
//             //           return DropdownMenuItem(
//             //             value: city.isEmpty ? null : city,
//             //             child: Text(city.isEmpty ? "الكل" : city),
//             //           );
//             //         }).toList(),
//             //         onChanged: (val) {
//             //           selectedCity = val;
//             //           context.read<SearchCubit>().setCityFilter(val);
//             //         },
//             //       ),
//             //     ),
//             //     const SizedBox(width: 10),
//             //     Expanded(
//             //       child: TextField(
//             //         controller: minPriceController,
//             //         keyboardType: TextInputType.number,
//             //         decoration: InputDecoration(
//             //           labelText: "أقل",
//             //           fillColor: Colors.blue[50],
//             //           filled: true,
//             //           border: OutlineInputBorder(),
//             //         ),
//             //         onChanged: (val) {
//             //           final min = double.tryParse(val);
//             //           final max = double.tryParse(maxPriceController.text);
//             //           context.read<SearchCubit>().setPriceFilter(min, max);
//             //         },
//             //       ),
//             //     ),
//             //     const SizedBox(width: 10),
//             //     Expanded(
//             //       child: TextField(
//             //         controller: maxPriceController,
//             //         keyboardType: TextInputType.number,
//             //         decoration: InputDecoration(
//             //           labelText: "أعلى",
//             //           fillColor: Colors.blue[50],
//             //           filled: true,
//             //           border: OutlineInputBorder(),
//             //         ),
//             //         onChanged: (val) {
//             //           final max = double.tryParse(val);
//             //           final min = double.tryParse(minPriceController.text);
//             //           context.read<SearchCubit>().setPriceFilter(min, max);
//             //         },
//             //       ),
//             //     ),
//             //   ],
//             // ),
//
//              SizedBox(height: 20.h),
//
//             // 📋 النتائج
//             Expanded(
//               child: BlocBuilder<SearchCubit, SearchState>(
//                 builder: (context, state) {
//                   if (state is SearchLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is SearchLoaded) {
//                     final items = state.filteredItems ?? state.allItems;
//
//                     if (items.isEmpty) return CustomEmptyList(title: "No Fiend Data");
//
//                     return ListView.separated(
//                       itemCount: items.length,
//                       separatorBuilder: (_, __) => Divider(),
//                       itemBuilder: (context, index) {
//                         final item = items[index];
//                         final name = item['userName'] ?? item['companyName'] ?? "No Name";
//                         final location = item['location'] ??"No Location";
//                         //final price = item['price'] != null ? "${item['price']} EG" : "";
//                         final phone = item['phone']?? "No Phone";
//                         final carType = item['specifications']?? "No Name Type";
//                         final productName = item['companyName']?? "No Product";
//                         final city = item['countryManufacture']?? "No Location";
//
//                         final isProduct = item.containsKey('companyName') || item.containsKey('price');
//
//                         final title = isProduct
//                             ? (item['companyName'] ?? "No product Name")
//                             : (item['userName'] ?? "No Workshop Name");
//
//                         final subtitle = item['location'] ?? "No Location";
//                         final price = item['price'] != null ? "${item['price']} EGP" : "";
//
//                         return ListTile(
//                           onTap: () {
//                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => WarchaScreen(list:WorkshopModel(id: item['id'] , name: item['userName'] , phone:  item['phone'] ,image:  item['profileImage'],longitude:  item['longitude'],latitude:  item['latitude'],location:  item['location'], ) ,),));
//                           },
//                           leading: Icon(isProduct ? Icons.shopping_bag : Icons.business, color: Colors.blue),
//                           title: Text(title),
//                           subtitle: Text(subtitle),
//                           trailing: isProduct
//                               ? Text(price, style: TextStyle(color: Colors.blue))
//                               : null,
//                         );
//                       },
//                     );
//                   } else if (state is SearchError) {
//                     return Center(child: Text("Error : ${state.error}"));
//                   }
//
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TextEditingController();
  //   context.read<SearchCubit>().fetchAllData();
  // }
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    context.read<SearchCubit>().fetchAllData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget buildFilterButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       filterButton('الكل', SearchFilterType.all),
  //       filterButton('ورش', SearchFilterType.workshops),
  //       filterButton('منتجات', SearchFilterType.products),
  //       filterButton('ميكانيكيين', SearchFilterType.mechanics),
  //     ],
  //   );
  // }
  //
  // Widget filterButton(String title, SearchFilterType type) {
  //  // final cubit = context.read<SearchCubit>();
  //   final cubit = context.watch<SearchCubit>();
  //
  //   final isSelected = cubit.currentFilter == type;
  //
  //   return ElevatedButton(
  //     onPressed: () {
  //       cubit.updateFilter(type, _controller.text);
  //     },
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
  //       foregroundColor: isSelected ? Colors.white : Colors.black,
  //     ),
  //     child: Text(title),
  //   );
  // }

  Widget buildFilterButtons() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300), // تعيين مدة التحويل
      child: Row(
        key: ValueKey<int>(context.read<SearchCubit>().currentFilter.index), // استخدام key لضمان التغيير عند التبديل
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          filterButton('All', SearchFilterType.all),
          filterButton('Workshops', SearchFilterType.workshops),
          filterButton('Products', SearchFilterType.products),
         filterButton('Mechanics', SearchFilterType.mechanics),
        ],
      ),
    );
  }

  Widget filterButton(String title, SearchFilterType type) {
    final cubit = context.watch<SearchCubit>(); // استخدام watch لالتقاط التغيير التلقائي
    final isSelected = cubit.currentFilter == type; // تحقق من ما إذا كان هذا الفلتر محددًا

    return ElevatedButton(
      key: ValueKey<SearchFilterType>(type), // key لتمييز الزر عند التبديل
      onPressed: () {
        cubit.updateFilter(type, _controller.text); // تحديث الفلتر
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // شكل الزر
        ),
      ),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        surfaceTintColor: Colors.white12,
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search...',
            fillColor: Colors.white12,
            filled: true,
            border: InputBorder.none,
          ),
          onChanged: (value) {

            context.read<SearchCubit>().searchFilter(value);
          },
        ),
      ),
      body: Column(
        children: [
          buildFilterButtons(), // الفلاتر فوق
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchFilterLoading) {
                  return CustomLoadingWidget();
                } else if (state is SearchFilterLoaded) {
                  final searchResults = context.read<SearchCubit>().searchResults;
                  if(searchResults.isEmpty ){
                    return CustomEmptyList(title: "No Result Now");
                  }
                  return Column(
                    children: [

                      Expanded(
                        child: searchResults.isEmpty
                            ? Center(child: Text('No Result Now'))
                            : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];

                            if (item is WorkshopModel) {
                              return ListTile(
                                title: Text(item.name),
                                subtitle: Text(item.location ?? ''),
                                onTap: () {
                                  // روح لصفحة الورشة مع الـ item
                                },
                              );
                            } else if (item is AccessoriesModel) {
                              return ListTile(
                                title: Text(item.companyName),
                                subtitle: Text(item.specifications ?? ''),
                                onTap: () {
                                  // روح لصفحة المنتج مع الـ item
                                },
                              );
                            }
                            else if (item is String) {
                              return ListTile(
                               // leading: CircleAvatar(child: Text(item[0])), // أول حرف من الاسم
                                title: Text(item),
                                trailing: Icon(Icons.build, color: Colors.blue),
                                onTap: () {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text('تم اختيار: $item')),
                                  // );
                                },
                              );
                            }


                            else {
                              return SizedBox(); // لو مفيش حاجة معروفة
                            }
                          },

                        ),
                      ),
                    ],
                  );
                } else if (state is SearchFilterError) {
                  return CustomErrorWidget(errorMessage: state.message);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
