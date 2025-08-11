import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class QAPage extends StatefulWidget {
  const QAPage({super.key});

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  final TextEditingController _questionController = TextEditingController();

  final List<Map<String, dynamic>> _questions = [
    {
      'userName': 'Alice Johnson',
      'userImage': 'https://randomuser.me/api/portraits/women/65.jpg',
      'text': 'What are the benefits of drinking warm water in the morning?',
      'image': null,
      'videoUrl': null,
      'upvotes': 12,
      'downvotes': 1,
      'answers': ['It improves digestion.', 'Boosts metabolism.'],
    },
    {
      'userName': 'John Doe',
      'userImage': 'https://randomuser.me/api/portraits/men/32.jpg',
      'text': 'Is meditation useful for anxiety?',
      'image':
          'https://images.unsplash.com/photo-1558478551-1a378f63328e?auto=format&fit=crop&w=800&q=80',
      'videoUrl': null,
      'upvotes': 35,
      'downvotes': 2,
      'answers': ['Absolutely, it helps calm the mind and body.'],
    },
    {
      'userName': 'Emma Watson',
      'userImage': 'https://randomuser.me/api/portraits/women/44.jpg',
      'text': 'What are the top exercises for beginners?',
      'image': null,
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'upvotes': 27,
      'downvotes': 0,
      'answers': ['Try walking, bodyweight squats, or light stretching.'],
    },
    {
      'userName': 'Michael Lee',
      'userImage': 'https://randomuser.me/api/portraits/men/21.jpg',
      'text': 'Where can I read more about plant-based diets?',
      'image': null,
      'videoUrl': null,
      'upvotes': 14,
      'downvotes': 0,
      'answers': [
        'Check this article: https://www.healthline.com/nutrition/plant-based-diet-guide'
      ],
    },
  ];

  void _postQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _questions.insert(0, {
        'userName': 'You',
        'userImage': 'https://randomuser.me/api/portraits/lego/1.jpg',
        'text': text,
        'image': null,
        'videoUrl': null,
        'upvotes': 0,
        'downvotes': 0,
        'answers': [],
      });
      _questionController.clear();
    });
  }

  Widget _buildAnswer(String answer) {
    final urlRegex = RegExp(r'https?:\/\/\S+');
    final match = urlRegex.firstMatch(answer);

    if (match != null) {
      final url = match.group(0)!;
      final before = answer.substring(0, match.start);
      final after = answer.substring(match.end);

      return RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 14.sp),
          children: [
            TextSpan(text: before),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Text(
                  url,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            TextSpan(text: after),
          ],
        ),
      );
    } else {
      return Text('- $answer', style: TextStyle(fontSize: 14.sp));
    }
  }

  Widget _buildPost(Map<String, dynamic> question) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info + name
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: question['userImage'] != null
                    ? NetworkImage(question['userImage'])
                    : null,
                backgroundColor: Colors.grey[300],
                child: question['userImage'] == null
                    ? Icon(Icons.person, color: Colors.white, size: 20.r)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  question['userName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              // More options icon
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey, size: 24.r),
                onPressed: () {},
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Question Text
          Text(
            question['text'],
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.4,
            ),
          ),

          SizedBox(height: 12.h),

          // Image (optional)
          if (question['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                question['image'],
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),

          // Video placeholder (optional)
          if (question['videoUrl'] != null)
            Container(
              margin: EdgeInsets.only(top: 12.h),
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(Icons.play_circle_fill,
                    size: 60.r, color: Colors.black54),
              ),
            ),

          SizedBox(height: 12.h),

          // Answers Section
          if (question['answers'].isNotEmpty) ...[
            Text(
              'Answers',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.sp, height: 1.3),
            ),
            SizedBox(height: 6.h),
            ...question['answers'].map<Widget>((ans) {
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: _buildAnswer(ans),
              );
            }).toList(),
          ],

          SizedBox(height: 12.h),

          // Upvote/Downvote/Share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _VoteButton(
                icon: Icons.thumb_up_alt_outlined,
                count: question['upvotes'],
                onTap: () {
                  setState(() {
                    question['upvotes']++;
                  });
                },
              ),
              SizedBox(width: 16.w),
              _VoteButton(
                icon: Icons.thumb_down_alt_outlined,
                count: question['downvotes'],
                onTap: () {
                  setState(() {
                    question['downvotes']++;
                  });
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.share_outlined, color: Colors.grey, size: 24.r),
                onPressed: () {
                  // Implement share logic or use share_plus package
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share pressed', style: TextStyle(fontSize: 14.sp))),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Community Q/A',
          style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Column(
        children: [
          // Question input field
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20.r,
                  child: Icon(Icons.person, size: 20.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'What do you want to ask or share?',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colors.teal.shade300, width: 2.w),
                      ),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(14.r),
                    backgroundColor: Colors.teal,
                    elevation: 2,
                  ),
                  onPressed: _postQuestion,
                  child: Icon(Icons.send, color: Colors.white, size: 20.r),
                ),
              ],
            ),
          ),

          // Questions list
          Expanded(
            child: _questions.isEmpty
                ? Center(child: Text('No questions yet.', style: TextStyle(fontSize: 16.sp)))
                : RefreshIndicator(
                    onRefresh: () async {
                      // You can add refresh logic here if needed
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) => _buildPost(_questions[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const _VoteButton({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: Colors.grey[700]),
          SizedBox(width: 6.w),
          Text(
            count.toString(),
            style: TextStyle(
                color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
