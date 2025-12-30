import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../feature/home/models/leage_list_model.dart';
import '../../feature/ligue/views/ligue_match_list_screen.dart';
import '../theme/SColor.dart';

class LeagueListWidget extends StatelessWidget {
  final List<League> leagues;
  final bool showDivider;
  final Function(int index, League league) onToggleFavorite;
  final Function(League league)? onLeagueTap;

  const LeagueListWidget({
    required this.leagues,
    required this.onToggleFavorite,
    this.showDivider = false,
    this.onLeagueTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        final league = leagues[index];
        final hasMatchCount = league.matchCount != null && league.matchCount! > 0;

        return Column(
          children: [
            InkWell(
              onTap: () {
                if (onLeagueTap != null) {
                  onLeagueTap!(league);
                } else {
                  Get.to(() => LigueMatchListScreen(), arguments: {
                    'leagueId': league.id,
                    'leagueName': league.name,
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // ===== FAVORITE BUTTON =====
                    GestureDetector(
                      onTap: () => onToggleFavorite(index, league),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: league.isFavorite
                              ? Colors.amber.withOpacity(0.1)
                              : (isDark ? Color(0xFF3E3E3E) : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          league.isFavorite ? Icons.star : Icons.star_border,
                          color: league.isFavorite ? Colors.amber : Colors.grey[400],
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // ===== LEAGUE LOGO =====
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Color(0xFF3E3E3E) : Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Image.network(
                        league.logo,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.sports_soccer,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // ===== LEAGUE INFO =====
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            league.name,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (league.country.flag.isNotEmpty)
                                Image.network(
                                  league.country.flag,
                                  width: 16,
                                  height: 12,
                                  errorBuilder: (_, __, ___) => SizedBox.shrink(),
                                ),
                              if (league.country.flag.isNotEmpty)
                                const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  league.country.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ===== MATCH COUNT BADGE (if available) =====
                    if (hasMatchCount)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SColor.primary,
                              SColor.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: SColor.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sports_soccer,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${league.matchCount}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                    // Arrow icon for leagues without match count
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
            if (showDivider)
              Padding(
                padding: const EdgeInsets.only(left: 86),
                child: Divider(
                  height: 1,
                  color: isDark ? Color(0xFF3E3E3E) : Colors.grey[200],
                ),
              ),
          ],
        );
      },
    );
  }
}