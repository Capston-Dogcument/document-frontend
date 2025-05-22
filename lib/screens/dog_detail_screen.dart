import 'package:document/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/services/dog_info_service.dart';

class DogDetailScreen extends StatefulWidget {
  final int dogId;

  const DogDetailScreen({
    super.key,
    required this.dogId,
  });

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
  final DogInfoService _dogInfoService = DogInfoService();
  bool _isLoading = true;
  Map<String, dynamic>? _dogDetail;

  @override
  void initState() {
    super.initState();
    _loadDogDetail();
  }

  Future<void> _loadDogDetail() async {
    try {
      final detail = await _dogInfoService.getDogDetail(widget.dogId);
      setState(() {
        _dogDetail = detail;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadDogDetail,
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
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              '강아지 상세보기',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 강아지 정보 헤더
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: _dogDetail?['profileImg'] != null &&
                                      _dogDetail!['profileImg'].isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        _dogDetail!['profileImg'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'images/basic_dog.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    )
                                  : Image.asset(
                                      'images/basic_dog.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _dogDetail?['dogName'] ?? '이름 없음',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 구분선
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),

                      // 기본 정보 섹션
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    '예방접종',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    '중성화',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    '질병',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: _buildInfoChip(
                                      _dogDetail?['isVaccinated'] == true
                                          ? '접종 완료'
                                          : '미접종'),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: _buildInfoChip(
                                      _dogDetail?['isNeutered'] == true
                                          ? '중성화 완료'
                                          : '미중성화'),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_dogDetail?['disease'] != null &&
                                          (_dogDetail!['disease'] as List)
                                              .isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('질병 목록'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (var disease
                                                    in _dogDetail!['disease'])
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Text(
                                                        '• ${disease['name']}'),
                                                  ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('확인'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: _dogDetail?['disease'] != null &&
                                            (_dogDetail!['disease'] as List)
                                                .isNotEmpty
                                        ? _buildInfoChip((_dogDetail!['disease']
                                                        as List)
                                                    .length >
                                                1
                                            ? '${(_dogDetail!['disease'][0]['name'] as String)} 외 ${(_dogDetail!['disease'] as List).length - 1}개'
                                            : (_dogDetail!['disease'][0]['name']
                                                as String))
                                        : _buildInfoChip('질병 없음'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 사료량 섹션
                      _buildSection(
                        title: '추천 사료량',
                        children: [
                          _buildFoodCard('건식 사료',
                              '${_dogDetail?['dryFoodAmount'] ?? 0}g/일'),
                          _buildFoodCard('습식 사료',
                              '${_dogDetail?['wetFoodAmount'] ?? 0}g/일'),
                        ],
                      ),

                      // 약 섹션
                      if (_dogDetail?['medication'] != null &&
                          (_dogDetail!['medication'] as List).isNotEmpty)
                        _buildSection(
                          title: '약',
                          children: [
                            _buildFoodCard(_dogDetail!['medication'][0]['name'],
                                '${_dogDetail!['medication'][0]['timesPerInterval']}회/일'),
                          ],
                        ),

                      // 비만도 섹션
                      _buildSection(
                        title: '비만도',
                        children: [
                          _buildObesityCard(
                              'BMI', _dogDetail?['obesityLevel'] ?? '정보 없음'),
                          _buildObesityCard(
                              '체중', '${_dogDetail?['weight'] ?? 0}kg'),
                        ],
                      ),

                      // 나이 섹션
                      _buildSection(
                        title: '예상 나이',
                        children: [
                          _buildAgeCard('현재 나이', '${_dogDetail?['age'] ?? 0}세'),
                          _buildAgeCard(
                              '평균수명', '${_dogDetail?['avgAge'] ?? 0}세'),
                        ],
                      ),

                      // 삭제 버튼
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('삭제 확인'),
                                content: const Text('정말로 이 강아지 정보를 삭제하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('삭제'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                final service = DogInfoService();
                                final result =
                                    await service.deleteDogInfo(widget.dogId);
                                if (result && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('삭제되었습니다.')),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardScreen()),
                                    (route) => false,
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('삭제 실패: $e')),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text('삭제',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomTabBar(
        tabItems: [
          TabItem(
              icon: '🏠',
              label: '대시보드',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              }),
          TabItem(icon: '🐶', label: '등록', onTap: () {}),
          TabItem(icon: '📊', label: '건강', onTap: () {}),
          TabItem(icon: '🏡', label: '입양', onTap: () {}),
          TabItem(icon: '🛠️', label: '설정', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
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
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObesityCard(String title, String value) {
    return Expanded(
      child: Container(
        height: 100,
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
          ],
        ),
      ),
    );
  }

  Widget _buildAgeCard(String title, String value) {
    return Expanded(
      child: Container(
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
          ],
        ),
      ),
    );
  }
}
