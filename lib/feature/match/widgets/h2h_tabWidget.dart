import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/head_to_head_controller.dart';
import '../models/head_to_head_model.dart';

class H2H extends StatefulWidget {
  final int fixtureId;

  const H2H({super.key, required this.fixtureId});

  @override
  State<H2H> createState() => _H2HState();
}

class _H2HState extends State<H2H> {
  final HeadToHeadController controller = Get.put(HeadToHeadController());

  @override
  void initState() {
    super.initState();
    controller.loadH2H(widget.fixtureId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      final data = controller.h2hData.value;
      if (data == null) {
        return Center(
          child: Text(
            "No data available",
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      final home = data.data.homeTeam;
      final away = data.data.awayTeam;
      final matches = data.data.matches;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // Home Team Last Games
            _buildSectionHeader('Last Games: ${home.name}', isDark, context),
            _buildMatchList(matches, controller.expandHome, home.id, isDark, context),
            if (!controller.expandHome.value && matches.length > 2)
              _buildSeeMoreButton(controller.expandHome, isDark, context),

            SizedBox(height: DynamicSize.large(context)),

            // Away Team Last Games
            _buildSectionHeader('Last Games: ${away.name}', isDark, context),
            _buildMatchList(matches, controller.expandAway, away.id, isDark, context),
            if (!controller.expandAway.value && matches.length > 2)
              _buildSeeMoreButton(controller.expandAway, isDark, context),

            SizedBox(height: DynamicSize.large(context)),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, bool isDark, BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(context),
        vertical: DynamicSize.small(context),
      ),
      child: Text(
        title,
        style: STextTheme.headLineBold().copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMatchList(
      List<H2HMatch> matches,
      RxBool expand,
      int teamId,
      bool isDark,
      BuildContext context,
      ) {
    if (matches.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        child: Center(
          child: Text(
            'No matches available',
            style: STextTheme.subHeadLine(),
          ),
        ),
      );
    }

    int count = expand.value
        ? matches.length
        : (matches.length >= 2 ? 2 : matches.length);

    return ListView.separated(
      itemCount: count,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
      ),
      itemBuilder: (context, index) {
        final match = matches[index];
        return _buildMatchCard(match, teamId, isDark, context);
      },
    );
  }

  Widget _buildMatchCard(
      H2HMatch match,
      int teamId,
      bool isDark,
      BuildContext context,
      ) {
    // Get team data from controller
    final data = controller.h2hData.value!.data;
    final homeTeam = data.homeTeam;
    final awayTeam = data.awayTeam;

    // Determine which team won from perspective of teamId
    String result;
    Color resultColor;

    // Check if our team was home or away in this match
    bool ourTeamWasHome = match.homeTeamWasHome == (teamId == homeTeam.id);

    if (match.winner == "draw") {
      result = "D";
      resultColor = Colors.grey;
    } else if (match.winner == "home") {
      // Home team won
      if (ourTeamWasHome) {
        result = "W";
        resultColor = Colors.green;
      } else {
        result = "L";
        resultColor = Colors.red;
      }
    } else {
      // Away team won
      if (!ourTeamWasHome) {
        result = "W";
        resultColor = Colors.green;
      } else {
        result = "L";
        resultColor = Colors.red;
      }
    }

    // Determine display order based on homeTeamWasHome
    String topTeamName, bottomTeamName, topTeamLogo, bottomTeamLogo;
    int topScore, bottomScore;

    if (match.homeTeamWasHome) {
      topTeamName = homeTeam.name;
      topTeamLogo = homeTeam.logo;
      topScore = match.homeTeamScore;
      bottomTeamName = awayTeam.name;
      bottomTeamLogo = awayTeam.logo;
      bottomScore = match.awayTeamScore;
    } else {
      topTeamName = awayTeam.name;
      topTeamLogo = awayTeam.logo;
      topScore = match.awayTeamScore;
      bottomTeamName = homeTeam.name;
      bottomTeamLogo = homeTeam.logo;
      bottomScore = match.homeTeamScore;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: DynamicSize.small(context),
        horizontal: DynamicSize.medium(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date
          SizedBox(
            width: 50,
            child: Text(
              _formatDate(match.date),
              style: STextTheme.subHeadLine().copyWith(
                fontSize: 12,
              ),
            ),
          ),

          SizedBox(width: 12),

          // Match Details
          Expanded(
            child: Column(
              children: [
                _buildTeamRow(
                  topTeamName,
                  topTeamLogo,
                  topScore.toString(),
                  isDark,
                ),
                SizedBox(height: 8),
                _buildTeamRow(
                  bottomTeamName,
                  bottomTeamLogo,
                  bottomScore.toString(),
                  isDark,
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // Result Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                result,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRow(
      String teamName, String teamLogo, String score, bool isDark) {
    return Row(
      children: [
        // Team Logo
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: teamLogo.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: teamLogo,
              fit: BoxFit.cover,
              placeholder: (context, url) => Icon(
                Icons.shield,
                size: 16,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.shield,
                size: 16,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            )
                : Icon(
              Icons.shield,
              size: 16,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),

        SizedBox(width: 8),

        // Team Name
        Expanded(
          child: Text(
            teamName,
            style: STextTheme.subHeadLine().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Score
        Text(
          score,
          style: STextTheme.headLineBold().copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSeeMoreButton(
      RxBool expandControl, bool isDark, BuildContext context) {
    return GestureDetector(
      onTap: () => expandControl(true),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: DynamicSize.small(context),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
        ),
        child: Text(
          "See More",
          style: STextTheme.headLineBold().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: SColor.primary,
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day}.${parsedDate.month}.';
    } catch (e) {
      return date;
    }
  }
}
