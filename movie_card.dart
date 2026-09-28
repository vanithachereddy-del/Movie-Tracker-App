import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final bool isCompact;

  const MovieCard({
    Key? key,
    required this.movie,
    this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isHovered ? 1.04 : 1.0;
    final elevation = _isHovered ? (widget.isCompact ? 8.0 : 12.0) : (widget.isCompact ? 4.0 : 6.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedPhysicalModel(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOut,
          elevation: elevation,
          color: Colors.white,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(widget.isCompact ? 10 : 12),
          shape: BoxShape.rectangle,
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.movie.posterUrl.isNotEmpty
                    ? Image.network(
                        widget.movie.posterUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.movie, size: 32),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.movie, size: 32),
                      ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.movie.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.movie.formattedReleaseYear,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        // Get the updated movie from provider
        final updatedMovie = movieProvider.getMovieById(widget.movie.id) ?? widget.movie;
        
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Poster
                  Container(
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: updatedMovie.posterUrl.isNotEmpty
                          ? Image.network(
                              updatedMovie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.movie, size: 32),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.movie, size: 32),
                            ),
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  // Movie Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Year
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                updatedMovie.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Status Icons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (updatedMovie.isWatched)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (updatedMovie.isWatched && updatedMovie.isWatchlisted)
                                  SizedBox(width: 4),
                                if (updatedMovie.isWatchlisted)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        
                        // Year and Runtime
                        Row(
                          children: [
                            Text(
                              updatedMovie.formattedReleaseYear,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              updatedMovie.formattedRuntime,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        
                        // OTT Platform
                        Row(
                          children: [
                            Icon(
                              updatedMovie.ottPlatform == 'Not Released Yet' 
                                  ? Icons.schedule 
                                  : Icons.play_circle_outline,
                              color: updatedMovie.ottPlatform == 'Not Released Yet' 
                                  ? Colors.orange 
                                  : Colors.green,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              updatedMovie.ottPlatform == 'Not Released Yet' 
                                  ? 'Release Date: ${updatedMovie.releaseDate}'
                                  : 'Available on: ${updatedMovie.ottPlatform}',
                              style: TextStyle(
                                color: updatedMovie.ottPlatform == 'Not Released Yet' 
                                    ? Colors.orange[700] 
                                    : Colors.green[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        
                        // Genres
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: updatedMovie.genres.take(3).map((genre) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.deepPurple[200]!,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.deepPurple[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        
                        // Rating and User Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text(
                              updatedMovie.voteAverage.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (updatedMovie.userRating != null && updatedMovie.userRating! > 0) ...[
                              SizedBox(width: 12),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Your rating: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < updatedMovie.userRating!
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 12,
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        
                        // Overview (truncated)
                        Text(
                          updatedMovie.overview,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Buttons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Watch Toggle
                      InkWell(
                        onTap: () {
                          movieProvider.toggleWatched(updatedMovie);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: updatedMovie.isWatched 
                                ? Colors.green[50] 
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: updatedMovie.isWatched 
                                  ? Colors.green[300]! 
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            updatedMovie.isWatched 
                                ? Icons.visibility 
                                : Icons.visibility_outlined,
                            size: 16,
                            color: updatedMovie.isWatched 
                                ? Colors.green[700] 
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      // Watchlist Toggle
                      InkWell(
                        onTap: () {
                          movieProvider.toggleWatchlist(updatedMovie);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: updatedMovie.isWatchlisted 
                                ? Colors.orange[50] 
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: updatedMovie.isWatchlisted 
                                  ? Colors.orange[300]! 
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            updatedMovie.isWatchlisted 
                                ? Icons.bookmark 
                                : Icons.bookmark_border,
                            size: 16,
                            color: updatedMovie.isWatchlisted 
                                ? Colors.orange[700] 
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    if (widget.isCompact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }
}