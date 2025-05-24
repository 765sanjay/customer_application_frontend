import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/repository/providers/profile_provider.dart';
import 'package:sklyit/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:sklyit/repository/providers/toggle_provider.dart';

class AppHeader extends StatefulWidget {
  final TextEditingController searchController;
  final Function(bool) onSearchStateChanged;

  static const Color primaryColor = Color(0xFF009085);
  static const Color secondaryColor = Color(0xFF2F4858);
  static const Color accentColor = Color(0xFFF6C445);
  static const Color darkAccent = Color(0xFF006B7C);
  static const Color lightAccent = Color(0xFFFDD90D);

  const AppHeader({
    Key? key,
    required this.searchController,
    required this.onSearchStateChanged,
  }) : super(key: key);

  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> with SingleTickerProviderStateMixin {
  bool isSearching = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final isCurrentlySearching = widget.searchController.text.isNotEmpty;
    if (isCurrentlySearching != isSearching) {
      setState(() {
        isSearching = isCurrentlySearching;
      });
      widget.onSearchStateChanged(isSearching);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<ToggleProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final double toggleWidth = MediaQuery.of(context).size.width * 0.5 - 25;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSearching ? Colors.white : null,
        gradient: isSearching ? null : LinearGradient(
          colors: [Color(0xFF009085), Color(0xFF006B7C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSearching) ...[
            // Enhanced Toggle Switch
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background highlight
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    left: toggleProvider.isSklyFlashSelected ? 0 : toggleWidth,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: toggleWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: toggleProvider.isSklyFlashSelected
                              ? [Color(0xFFF5F5F5), Color(0xFFEEEEEE)]
                              : [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  // Active indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    left: toggleProvider.isSklyFlashSelected ? 4 : toggleWidth + 4,
                    top: 4,
                    bottom: 4,
                    child: Container(
                      width: toggleWidth - 8,
                      decoration: BoxDecoration(
                        color: toggleProvider.isSklyFlashSelected
                            ? Colors.white
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Toggle options
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!toggleProvider.isSklyFlashSelected) {
                              toggleProvider.toggle(true);
                              _animationController.forward(from: 0);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: toggleProvider.isSklyFlashSelected
                                  ? _buildActiveToggleOption(
                                'assets/images/toggle 1.png',
                                size: 52,
                              )
                                  : _buildInactiveToggleOption(
                                'assets/images/toggle 1.png',
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (toggleProvider.isSklyFlashSelected) {
                              toggleProvider.toggle(false);
                              _animationController.forward(from: 0);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: !toggleProvider.isSklyFlashSelected
                                  ? _buildActiveToggleOption(
                                'assets/images/toggle 2_dup.png',
                                size: 52,
                              )
                                  : _buildInactiveToggleOption(
                                'assets/images/toggle 2_dup.png',
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Animated title
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 400),
              crossFadeState: toggleProvider.isSklyFlashSelected
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Text(
                "8 minutes delivery",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              secondChild: Text(
                "Marketplace",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Address selector
            GestureDetector(
              onTap: () {
                _showAddressDropdown(context, profileProvider);
              },
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppHeader.lightAccent, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      profileProvider.selectedAddress.isNotEmpty
                          ? profileProvider.selectedAddress
                          : "Select Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],

          // Search field
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.searchController,
              decoration: InputDecoration(
                hintText: "Search for products...",
                prefixIcon: Icon(Icons.search, color: AppHeader.secondaryColor),
                suffixIcon: isSearching
                    ? IconButton(
                  icon: Icon(Icons.clear, color: AppHeader.secondaryColor),
                  onPressed: () {
                    widget.searchController.clear();
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveToggleOption(String imagePath, {double size = 52}) {
    return Container(
      key: ValueKey('active_$imagePath'),
      child: SizedBox(
        height: size,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildInactiveToggleOption(String imagePath, {double size = 48}) {
    return Container(
      key: ValueKey('inactive_$imagePath'),
      child: SizedBox(
        height: size,
        child: Opacity(
          opacity: 0.7,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void _showAddressDropdown(BuildContext context, ProfileProvider profileProvider) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Delivery Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: profileProvider.savedAddresses.length,
                  itemBuilder: (context, index) {
                    final address = profileProvider.savedAddresses[index];
                    return ListTile(
                      leading: Icon(Icons.location_on,
                          color: AppHeader.primaryColor),
                      title: Text(address),
                      onTap: () {
                        profileProvider.updateSelectedAddress(address);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}