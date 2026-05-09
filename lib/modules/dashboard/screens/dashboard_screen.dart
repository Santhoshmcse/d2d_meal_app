import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';
import 'package:d2d_meal_app/modules/employees/screens/employee_screen.dart';
import 'package:d2d_meal_app/modules/inventory/screen/inventory_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen>
    with TickerProviderStateMixin {

  late AnimationController _headerController;
  late AnimationController _cardsController;

  late Animation<double> _headerFade;

  late Animation<Offset> _headerSlide;

  final List<_CardData> _cards = [

    _CardData(
      title: "Employees",
      subtitle: "Manage Staff",
      icon: Icons.people_alt_rounded,
      gradientColors: [
        AppColors.green1,
        AppColors.green2,
      ],
      count: "24",
      countLabel: "Active",
    ),

    _CardData(
      title: "Meal Punch",
      subtitle: "Track Meals",
      icon: Icons.restaurant_rounded,
      gradientColors: [
        AppColors.accentAmber,
        const Color(0xFFC87000),
      ],
      count: "128",
      countLabel: "Today",
    ),

    _CardData(
      title: "Inventory",
      subtitle: "Stock Items",
      icon: Icons.inventory_2_rounded,
      gradientColors: [
        AppColors.accentBlue,
        const Color(0xFF0369A1),
      ],
      count: "342",
      countLabel: "Items",
    ),

    _CardData(
      title: "Reports",
      subtitle: "View Analytics",
      icon: Icons.bar_chart_rounded,
      gradientColors: [
        AppColors.accentPurple,
        const Color(0xFF7C3AED),
      ],
      count: "12",
      countLabel: "Reports",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerController.forward();

    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        if (mounted) {
          _cardsController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    return Scaffold(

      backgroundColor:
      const Color(0xFF111827),

      bottomNavigationBar:
      _buildBottomNav(),

      body: Stack(
        children: [

          _buildBackground(),

          SafeArea(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                _buildHeader(),

                _buildStatsStrip(),

                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    14,
                  ),
                  child: Text(
                    "QUICK ACCESS",
                    style: TextStyle(
                      color:
                      Colors.white.withOpacity(
                        0.45,
                      ),
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),

                Expanded(
                  child: _buildGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Stack(
      children: [

        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green1
                  .withOpacity(0.15),
            ),
          ),
        ),

        Positioned(
          bottom: -140,
          right: -100,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green2
                  .withOpacity(0.10),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _buildHeader() {

    return FadeTransition(
      opacity: _headerFade,

      child: SlideTransition(
        position: _headerSlide,

        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(
            24,
            22,
            24,
            0,
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "Good Morning 👋",
                    style: TextStyle(
                      color:
                      Colors.white.withOpacity(
                        0.55,
                      ),
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "D2D Meal App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                      FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient:
                  AppColors.primaryGradient,

                  boxShadow:
                  AppColors.greenGlow(
                    blur: 20,
                    offset:
                    const Offset(0, 8),
                  ),
                ),

                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _buildStatsStrip() {

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        24,
        22,
        24,
        0,
      ),

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(24),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),

          child: Container(
            padding:
            const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),

            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(
                0.05,
              ),

              borderRadius:
              BorderRadius.circular(24),

              border: Border.all(
                color:
                Colors.white.withOpacity(
                  0.06,
                ),
              ),
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,

              children: [

                _statItem(
                  "504",
                  "Total Meals",
                ),

                _statDivider(),

                _statItem(
                  "24",
                  "Employees",
                ),

                _statDivider(),

                _statItem(
                  "₹12.4K",
                  "Revenue",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _statItem(
      String value,
      String label,
      ) {

    return Column(
      children: [

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight:
            FontWeight.w800,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: TextStyle(
            color:
            Colors.white.withOpacity(
              0.45,
            ),

            fontSize: 11,

            fontWeight:
            FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _statDivider() {

    return Container(
      width: 1,
      height: 34,

      color:
      Colors.white.withOpacity(
        0.08,
      ),
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _buildGrid() {

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: GridView.builder(

        physics:
        const BouncingScrollPhysics(),

        itemCount: _cards.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,

          childAspectRatio: 0.82,
        ),

        itemBuilder: (
            context,
            index,
            ) {

          return AnimatedBuilder(

            animation: _cardsController,

            builder: (context, child) {

              final delay =
                  index * 0.12;

              final t =
              ((_cardsController.value -
                  delay) /
                  (1 - delay))
                  .clamp(0.0, 1.0);

              final curved =
              Curves.easeOutBack
                  .transform(t);

              return Opacity(
                opacity:
                t.clamp(0.0, 1.0),

                child:
                Transform.translate(
                  offset: Offset(
                    0,
                    30 * (1 - curved),
                  ),

                  child: child,
                ),
              );
            },

            child: _DashboardCard(

              data: _cards[index],

              onTap: () {

                if (index == 0) {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (_) =>
                          EmployeeScreen(),
                    ),
                  );

                } else if (index == 2) {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (_) =>
                          InventoryScreen(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────────

  Widget _buildBottomNav() {

    return Container(
      margin: const EdgeInsets.all(20),

      height: 72,

      decoration: BoxDecoration(

        color:
        Colors.white.withOpacity(
          0.06,
        ),

        borderRadius:
        BorderRadius.circular(28),

        border: Border.all(
          color:
          Colors.white.withOpacity(
            0.08,
          ),
        ),
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,

        children: const [

          Icon(
            Icons.home_rounded,
            color: AppColors.green1,
          ),

          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white54,
          ),

          CircleAvatar(
            radius: 22,
            backgroundColor:
            AppColors.green1,

            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),

          Icon(
            Icons.bar_chart_rounded,
            color: Colors.white54,
          ),

          Icon(
            Icons.person_outline_rounded,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────

class _CardData {

  final String title;
  final String subtitle;

  final IconData icon;

  final List<Color> gradientColors;

  final String count;
  final String countLabel;

  const _CardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.count,
    required this.countLabel,
  });
}

// ─────────────────────────────────────────────────────────

class _DashboardCard
    extends StatefulWidget {

  final _CardData data;

  final VoidCallback? onTap;

  const _DashboardCard({
    required this.data,
    this.onTap,
  });

  @override
  State<_DashboardCard> createState() =>
      _DashboardCardState();
}

// ─────────────────────────────────────────────────────────

class _DashboardCardState
    extends State<_DashboardCard>
    with SingleTickerProviderStateMixin {

  late AnimationController
  _pressController;

  late Animation<double>
  _scaleAnim;

  @override
  void initState() {
    super.initState();

    _pressController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 120,
          ),
        );

    _scaleAnim =
        Tween<double>(
          begin: 1,
          end: 0.96,
        ).animate(
          CurvedAnimation(
            parent: _pressController,
            curve: Curves.easeOut,
          ),
        );
  }

  @override
  void dispose() {

    _pressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTapDown:
          (_) => _pressController.forward(),

      onTapUp: (_) {

        _pressController.reverse();

        widget.onTap?.call();
      },

      onTapCancel:
          () => _pressController.reverse(),

      child: ScaleTransition(

        scale: _scaleAnim,

        child: Container(

          decoration: BoxDecoration(

            gradient: LinearGradient(

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [

                widget.data.gradientColors[0]
                    .withOpacity(0.92),

                widget.data.gradientColors[1]
                    .withOpacity(0.75),
              ],
            ),

            borderRadius:
            BorderRadius.circular(30),

            boxShadow: [

              BoxShadow(

                color:
                widget.data.gradientColors[0]
                    .withOpacity(0.30),

                blurRadius: 24,

                offset:
                const Offset(0, 10),
              ),
            ],
          ),

          child: Stack(
            children: [

              Positioned(
                top: -20,
                right: -20,

                child: Container(
                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color:
                    Colors.white.withOpacity(
                      0.10,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                right: 14,

                child: Container(
                  width: 30,
                  height: 30,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color:
                    Colors.white.withOpacity(
                      0.12,
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(30),

                    border: Border.all(
                      color:
                      Colors.white.withOpacity(
                        0.08,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    Container(
                      width: 52,
                      height: 52,

                      decoration: BoxDecoration(

                        color:
                        Colors.white.withOpacity(
                          0.16,
                        ),

                        borderRadius:
                        BorderRadius.circular(16),
                      ),

                      child: Icon(
                        widget.data.icon,

                        color: Colors.white,

                        size: 28,
                      ),
                    ),

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Row(
                          children: [

                            Text(
                              widget.data.count,

                              style:
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),

                              decoration: BoxDecoration(

                                color:
                                Colors.white
                                    .withOpacity(
                                  0.14,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(
                                widget.data.countLabel,

                                style: TextStyle(
                                  color:
                                  Colors.white
                                      .withOpacity(
                                    0.90,
                                  ),

                                  fontSize: 10,

                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.data.title,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          widget.data.subtitle,

                          style: TextStyle(
                            color:
                            Colors.white.withOpacity(
                              0.65,
                            ),

                            fontSize: 11,

                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}