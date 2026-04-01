import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.product['color'], // Use product color for background
      body: SafeArea(
        bottom: false, // Allow content to go to the bottom edge
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Stack(
                children: [
                  // This is the background image/illustration
                  Positioned.fill(
                    bottom: MediaQuery.of(context).size.height * 0.45,
                    child: Center(
                      child: Text(
                        widget.product['image'],
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),
                  // This is the white sheet with product details
                  DraggableScrollableSheet(
                    initialChildSize: 0.65,
                    minChildSize: 0.65,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProductInfo(),
                              const SizedBox(height: 24),
                              _buildIngredients(),
                              const SizedBox(height: 24),
                              _buildDescription(),
                              const SizedBox(height: 120), // Space for bottom bar
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Positioned bottom bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildAddToCartBar(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with back button and actions
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: Colors.black54),
                  onPressed: () {}),
              
            ],
          ),
        ],
      ),
    );
  }

  // Product name, price, and stats
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.product['name'] + ' Italiano Mariao',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${widget.product['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                const Text('12k sold', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 18),
            Text(' 4.5 review'),
            SizedBox(width: 16),
            Icon(Icons.delivery_dining, color: Colors.grey, size: 18),
            Text(' 12 min'),
            SizedBox(width: 16),
            Icon(Icons.location_on, color: Colors.grey, size: 18),
            Text(' 1.4 km'),
          ],
        ),
      ],
    );
  }

  // Ingredients section
  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ingredients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text('See all', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _IngredientCard(emoji: '🍅'),
            _IngredientCard(emoji: '🍋'),
            _IngredientCard(emoji: '🥛'),
            _IngredientCard(emoji: '🍝'),
          ],
        ),
      ],
    );
  }

  // Description section
  Widget _buildDescription() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        children: [
          TextSpan(
              text:
                  'Mariao\'s Spageti Italiano is an authentic Italian spaghetti dish with mouthwatering flavors. Spaghetti pasta cooked al dente is served with a signature marinara sauce, ...'),
          TextSpan(
            text: ' Read more',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Bottom bar for quantity and add to cart
  Widget _buildAddToCartBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          )
        ],
      ),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.black, // Changed color to black
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) _quantity--;
                    });
                  },
                ),
                Text('$_quantity',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.black, // Changed color to black
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add to bag button
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Add to bag', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget for ingredient cards
class _IngredientCard extends StatelessWidget {
  final String emoji;
  const _IngredientCard({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}


