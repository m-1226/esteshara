// features/home/presentation/views/widgets/specialist_details_view_body.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpecialistDetailsViewBody extends StatefulWidget {
  final SpecialistModel specialist;

  const SpecialistDetailsViewBody({
    super.key,
    required this.specialist,
  });

  @override
  State<SpecialistDetailsViewBody> createState() =>
      _SpecialistDetailsViewBodyState();
}

class _SpecialistDetailsViewBodyState extends State<SpecialistDetailsViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpecialistInfo(),
                const SizedBox(height: 24),
                _buildHighlights(),
                const SizedBox(height: 24),
                _buildTabBar(),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAboutTab(),
              _buildExperienceTab(),
              _buildReviewsTab(),
            ],
          ),
        ),
        // Add some space at the bottom for the floating action button
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'specialist_${widget.specialist.id}',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getSpecializationColor(widget.specialist.specialization)
                      .withOpacity(0.8),
                  _getSpecializationColor(widget.specialist.specialization)
                      .withOpacity(0.4),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (widget.specialist.photoUrl.isNotEmpty)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        widget.specialist.photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => Container(),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.specialist.photoUrl.isNotEmpty
                            ? NetworkImage(widget.specialist.photoUrl)
                            : null,
                        child: widget.specialist.photoUrl.isEmpty
                            ? Text(
                                widget.specialist.name.isNotEmpty
                                    ? widget.specialist.name[0].toUpperCase()
                                    : '',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.specialist.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.specialist.specialization,
                              style: TextStyle(
                                color: _getSpecializationColor(
                                    widget.specialist.specialization),
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
              // Handle favorite action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to favorites'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            onPressed: () {
              // Handle share action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share profile'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSpecialistInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildInfoItem(
              Icons.star,
              Colors.amber,
              '${widget.specialist.rating}',
              '${widget.specialist.reviewCount} reviews',
            ),
            const SizedBox(width: 24),
            _buildInfoItem(
              Icons.medical_services_outlined,
              Colors.blue,
              '5+ years',
              'Experience',
            ),
            const SizedBox(width: 24),
            _buildInfoItem(
              Icons.people_outline,
              Colors.green,
              '500+',
              'Patients',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              _getAvailabilityText(),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.black54),
            const SizedBox(width: 8),
            const Text(
              'Cairo, Egypt',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.specialist.price.toInt()} EGP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      'Consultation Fee',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      '30 min',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Session Duration',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      IconData icon, Color color, String title, String subtitle) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Highlights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildHighlightItem(
          'Specialized in',
          _getSpecializationHighlight(widget.specialist.specialization),
        ),
        _buildHighlightItem(
          'Languages',
          'Arabic, English',
        ),
        _buildHighlightItem(
          'Available for',
          'Online Consultation, Video Call',
        ),
      ],
    );
  }

  Widget _buildHighlightItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'About'),
            Tab(text: 'Experience'),
            Tab(text: 'Reviews'),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the Specialist',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.specialist.bio.isNotEmpty
                ? widget.specialist.bio
                : 'Dr. ${widget.specialist.name} is a highly qualified ${widget.specialist.specialization.toLowerCase()} with several years of experience in the field. They provide personalized care and treatment plans tailored to each patient\'s specific needs. Their approach combines evidence-based medicine with compassionate care to ensure the best possible outcomes for all patients.',
            style: const TextStyle(
              height: 1.5,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Working Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildWorkingHours(),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    final dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final availableDays =
        widget.specialist.availableTimes.map((time) => time.day).toSet();

    // Sort days in correct order
    final sortedTimes = List.of(widget.specialist.availableTimes);
    sortedTimes.sort(
        (a, b) => dayOrder.indexOf(a.day).compareTo(dayOrder.indexOf(b.day)));

    return Column(
      children: dayOrder.map((day) {
        final isAvailable = availableDays.contains(day);
        final timeSlot = isAvailable
            ? sortedTimes.firstWhere((time) => time.day == day)
            : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isAvailable ? Colors.grey.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAvailable ? Colors.grey.shade200 : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight:
                        isAvailable ? FontWeight.w500 : FontWeight.normal,
                    color: isAvailable ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
              Text(
                isAvailable
                    ? '${timeSlot!.startTime} - ${timeSlot.endTime}'
                    : 'Unavailable',
                style: TextStyle(
                  fontWeight: isAvailable ? FontWeight.w500 : FontWeight.normal,
                  color: isAvailable
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExperienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Education',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildExperienceItem(
            'Cairo University',
            'Bachelor of Medicine, 2015',
            '2009 - 2015',
            Icons.school,
          ),
          _buildExperienceItem(
            'Cairo University',
            'Master\'s Degree in ${widget.specialist.specialization}',
            '2015 - 2018',
            Icons.school,
          ),
          const SizedBox(height: 24),
          const Text(
            'Work Experience',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildExperienceItem(
            'Cairo International Hospital',
            widget.specialist.specialization,
            '2018 - Present',
            Icons.work,
          ),
          _buildExperienceItem(
            'El-Salam Hospital',
            'Resident Doctor',
            '2015 - 2018',
            Icons.work,
          ),
          const SizedBox(height: 24),
          const Text(
            'Certifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildExperienceItem(
            'Egyptian Medical Syndicate',
            'License to Practice Medicine',
            '2015',
            Icons.verified,
          ),
          _buildExperienceItem(
            'American Board of Medical Specialties',
            'Certified in ${widget.specialist.specialization}',
            '2018',
            Icons.verified,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
      String title, String subtitle, String date, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${widget.specialist.rating}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < widget.specialist.rating.floor()
                                ? Icons.star
                                : index < widget.specialist.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on ${widget.specialist.reviewCount} reviews',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildRatingBar('5', 0.9),
                  _buildRatingBar('4', 0.7),
                  _buildRatingBar('3', 0.2),
                  _buildRatingBar('2', 0.05),
                  _buildRatingBar('1', 0.01),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildReviewItem(
                'Ahmed Mohamed',
                'assets/images/avatar1.jpg',
                5.0,
                'Great doctor! Very knowledgeable and professional. The consultation was very helpful.',
                '2 days ago',
              ),
              _buildReviewItem(
                'Sara Ahmed',
                'assets/images/avatar2.jpg',
                4.5,
                'Very good experience. The doctor was attentive and gave me great advice. Would recommend.',
                '1 week ago',
              ),
              _buildReviewItem(
                'Mohamed Ali',
                'assets/images/avatar3.jpg',
                5.0,
                'Excellent specialist. Very thorough in the examination and clear in explanations.',
                '2 weeks ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(String rating, double percentage) {
    return Expanded(
      child: Column(
        children: [
          Text(
            rating,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 60,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              heightFactor: percentage,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String avatarAsset, double rating,
      String comment, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getAvailabilityText() {
    final today = DateTime.now();
    final todayName = DateFormat('EEEE').format(today);

    final isAvailableToday =
        widget.specialist.availableTimes.any((time) => time.day == todayName);

    if (isAvailableToday) {
      final time = widget.specialist.availableTimes
          .firstWhere((time) => time.day == todayName);
      return 'Available today: ${time.startTime} - ${time.endTime}';
    } else {
      // Find next available day
      final dayOrder = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      final todayIndex = dayOrder.indexOf(todayName);

      for (int i = 1; i <= 7; i++) {
        final nextDayIndex = (todayIndex + i) % 7;
        final nextDay = dayOrder[nextDayIndex];

        final isAvailable =
            widget.specialist.availableTimes.any((time) => time.day == nextDay);
        if (isAvailable) {
          return 'Next available: $nextDay';
        }
      }

      return 'Currently unavailable';
    }
  }

  String _getSpecializationHighlight(String specialization) {
    final Map<String, String> specializationHighlights = {
      'Cardiologist': 'Heart diseases, Hypertension, Cardiac arrhythmias',
      'Dermatologist': 'Skin disorders, Hair loss, Cosmetic procedures',
      'Pediatrician': 'Child healthcare, Development assessment, Vaccinations',
      'Business Consultant': 'Business Strategy, Marketing, Financial Analysis',
      'Career Coach':
          'Career Development, Interview Preparation, Resume Building',
      'Neurologist': 'Brain disorders, Stroke, Epilepsy, Headaches',
      'Psychiatrist': 'Mental health, Anxiety, Depression, PTSD',
    };

    return specializationHighlights[specialization] ?? 'General consultation';
  }

  Color _getSpecializationColor(String specialization) {
    final Map<String, Color> specializationColors = {
      'Cardiologist': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
    };

    return specializationColors[specialization] ?? Colors.blue.shade600;
  }
}
