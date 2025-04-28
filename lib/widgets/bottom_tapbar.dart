import 'package:flutter/material.dart';

class TabItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  TabItem({required this.icon, required this.label, required this.onTap});
}

class BottomTabBar extends StatelessWidget {
  final List<TabItem> tabItems;

  const BottomTabBar({super.key, required this.tabItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 고정 너비 제거하고 화면 크기에 맞추기
      width: MediaQuery.of(context).size.width,
      height: 70, // 높이 줄이기
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabItems
            .map((tabItem) => Expanded(
                  child: GestureDetector(
                    onTap: tabItem.onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36, // 크기 줄이기
                            height: 36, // 크기 줄이기
                            decoration: ShapeDecoration(
                              color: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                tabItem.icon,
                                style: const TextStyle(
                                  fontSize: 24, // 크기 줄이기
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tabItem.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
