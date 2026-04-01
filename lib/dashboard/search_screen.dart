import 'package:demo_flutter_project/dashboard/dashboard_screen_2.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // --- STATE VARIABLES ---

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  // The complete list of products (our "database")
  final List<Map<String, dynamic>> _allProducts = [
    {'image': '🥗', 'name': 'Caesar Salad', 'category': 'Salad', 'price': 14.50, 'rating': 4.5},
    {'image': '🍕', 'name': 'Pepperoni Pizza', 'category': 'Pizza', 'price': 22.00, 'rating': 4.8},
    {'image': '🍩', 'name': 'Glazed Donuts', 'category': 'Donuts', 'price': 8.00, 'rating': 4.2},
    {'image': '🍔', 'name': 'Classic Burger', 'category': 'Burger', 'price': 18.00, 'rating': 4.7},
    {'image': '🥗', 'name': 'Greek Salad', 'category': 'Salad', 'price': 12.00, 'rating': 4.3},
    {'image': '🍕', 'name': 'Margherita Pizza', 'category': 'Pizza', 'price': 20.50, 'rating': 4.9},
    {'image': '🍰', 'name': 'Cheesecake', 'category': 'Donuts', 'price': 11.50, 'rating': 4.6},
    {'image': '🍔', 'name': 'Veggie Burger', 'category': 'Burger', 'price': 16.50, 'rating': 4.1},
    {'image': '🥐', 'name': 'Spaghetti', 'category': 'Pasta', 'price': 19.00, 'rating': 4.4},
  ];

  // The list of products that will be displayed on the screen after filtering
  List<Map<String, dynamic>> _filteredProducts = [];

  // Variables to hold the current state of our filters
  String _selectedCategory = 'All';
  RangeValues _currentPriceRange = const RangeValues(0, 50);
  String _sortBy = 'Rating';

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list is the full list
    _filteredProducts = _allProducts;
    _searchController.addListener(_runFilter);
  }

  @override
  void dispose() {
    _searchController.removeListener(_runFilter);
    _searchController.dispose();
    super.dispose();
  }

  // --- FILTERING LOGIC ---

  // This function is called whenever a filter or search term changes
  void _runFilter() {
    List<Map<String, dynamic>> results = [];
    
    // Start with the full list of products
    results = List.from(_allProducts);

    // 1. Filter by Search Text
    if (_searchController.text.isNotEmpty) {
      results = results
          .where((product) => product['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // 2. Filter by Category
    if (_selectedCategory != 'All') {
      results = results
          .where((product) => product['category'] == _selectedCategory)
          .toList();
    }

    // 3. Filter by Price Range
    results = results.where((product) {
      return product['price'] >= _currentPriceRange.start &&
          product['price'] <= _currentPriceRange.end;
    }).toList();

    // 4. Sort the results
    if (_sortBy == 'Rating') {
      results.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (_sortBy == 'Price: Low to High') {
      results.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_sortBy == 'Price: High to Low') {
      results.sort((a, b) => b['price'].compareTo(a['price']));
    }

    // Update the UI
    setState(() {
      _filteredProducts = results;
    });
  }

  // --- UI BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // Add an explicit back button
       leading: IconButton(
  icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
  onPressed: () {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // Agar root hai to close app ya Home le jao
      // Example: SystemNavigator.pop();  // exit app
      // ya phir ek HomeScreen pe le jao
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen2()), 
      );
    }
  },
),
        title: Text(
          'Search & Filter',
          style: TextStyle(
            color: Colors.grey[800], // Use a dark grey instead of pure black
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false, // We added a custom leading widget
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Expanded(child: _buildResultsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Search for products',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final theme = Theme.of(context);
    final List<String> categories = ['All', 'Salad', 'Pizza', 'Donuts', 'Burger', 'Pasta'];
    var boxDecoration = BoxDecoration(
                   color: Colors.grey[200],
                   borderRadius: BorderRadius.circular(8.0),
                   border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                 );
    return ExpansionTile(
      iconColor: const Color(0xFF00BFA5),
      collapsedIconColor: Colors.grey[600],
      title: const Text('Filters & Sorting', style: TextStyle(fontWeight: FontWeight.bold , color: Color.fromARGB(255, 39, 42, 41)) ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Filter
              const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 8.0,
                children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _runFilter();
                      });
                    },
                    selectedColor: const Color(0xFF00BFA5),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey[200],
                    side: BorderSide(color: Colors.grey.shade300),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Price Range Filter
              Text('Price Range: \$${_currentPriceRange.start.toStringAsFixed(0)} - \$${_currentPriceRange.end.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
              RangeSlider(
                values: _currentPriceRange,
                min: 0,
                max: 50,
                divisions: 10,
                labels: RangeLabels(
                  '\$${_currentPriceRange.start.round()}',
                  '\$${_currentPriceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentPriceRange = values;
                  });
                },
                onChangeEnd: (values) {
                  _runFilter(); // Filter only when user releases the slider
                },
                activeColor: const Color(0xFF00BFA5),
                inactiveColor: const Color(0xFF00BFA5).withOpacity(0.2),
              ),

              // Sort By Dropdown
               const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
                 decoration: boxDecoration,
                 child: DropdownButtonHideUnderline(
                   child: DropdownButton<String>(
                     dropdownColor: Colors.white,
                     isExpanded: true,
                     value: _sortBy,
                     items: <String>['Rating', 'Price: Low to High', 'Price: High to Low']
                         .map((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                     onChanged: (String? newValue) {
                       setState(() {
                         _sortBy = newValue!;
                         _runFilter();
                       });
                     },
                   ),
                 ),
               ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildResultsList() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'No products found matching your criteria.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Text(product['image'], style: const TextStyle(fontSize: 32)),
            title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            subtitle: Text(product['category'], style: TextStyle(color: Colors.grey[600])),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00BFA5)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${product['rating']}', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
