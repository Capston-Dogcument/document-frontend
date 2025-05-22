import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:document/services/dashboard_service.dart';
import 'package:intl/intl.dart';
import 'package:document/screens/basic_information_screen.dart';
import 'package:document/screens/dog_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await _dashboardService.getDashboardData();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터 로드 실패: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatNextFeedingTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '시간 정보 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 상단 앱바
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Dogcument',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // 현재 상태 섹션
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildStatusItem(
                              '🐶',
                              '보호중인 유기견 수',
                              '${_dashboardData?['totalDogs'] ?? 0}',
                            ),
                            _buildStatusItem(
                              '⏰',
                              '다음 사료 줄 시간',
                              _formatNextFeedingTime(
                                  _dashboardData?['nextFeedingTime'] ?? ''),
                            ),
                            _buildStatusItem('🏡', '입양 요청', '2 new requests'),
                          ],
                        ),
                      ),

                      // 대시보드 섹션
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    '중성화 비율',
                                    '${_dashboardData?['neuteredRate'] ?? 0}%',
                                    '+5%',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildStatCard(
                                    '예방접종 비율',
                                    '${_dashboardData?['vaccinationRate'] ?? 0}%',
                                    '-2%',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 강아지 목록 섹션
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Dogs',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        '상세보기',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward_ios, size: 12),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (_dashboardData?['homeDogList'] != null)
                              SizedBox(
                                height: 240, // 카드 높이 + 패딩을 고려한 높이
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      (_dashboardData!['homeDogList'] as List)
                                          .length,
                                  itemBuilder: (context, index) {
                                    final dog =
                                        _dashboardData!['homeDogList'][index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DogDetailScreen(
                                                dogId: dog['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          width: 160,
                                          child: _buildDogCard(
                                            dog['name'] ?? '이름 없음',
                                            '${dog['age'] ?? 0} years old',
                                            dog['gender'] ?? 'Unknown',
                                            dog['profileImg'],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomTabBar(
        tabItems: [
          TabItem(icon: '🏠', label: '대시보드', onTap: () {}),
          TabItem(
            icon: '🐶',
            label: '등록',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BasicInformationScreen(),
                ),
              );
            },
          ),
          TabItem(icon: '📊', label: '건강', onTap: () {}),
          TabItem(icon: '🏡', label: '입양', onTap: () {}),
          TabItem(icon: '🛠️', label: '설정', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String emoji, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
                if (title == '입양 요청')
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            change,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDogCard(
      String name, String age, String gender, String? imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 164,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'images/basic_dog.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/basic_dog.png',
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      gender,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  age,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
