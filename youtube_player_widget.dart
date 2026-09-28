import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerPlayer extends StatefulWidget {
  final String videoId;
  final String title;

  const MovieTrailerPlayer({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<MovieTrailerPlayer> createState() => _MovieTrailerPlayerState();
}

class _MovieTrailerPlayerState extends State<MovieTrailerPlayer> {
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    try {
      _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      );
      _isControllerInitialized = true;
    } catch (e) {
      print('Error initializing YouTube controller: $e');
      _isControllerInitialized = false;
    }
  }

  @override
  void dispose() {
    if (_controller != null && _isControllerInitialized) {
      try {
        _controller!.dispose();
      } catch (e) {
        print('Error disposing YouTube controller: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized || _controller == null) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Unable to load video'),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Trailer: ${widget.title}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
          onReady: () {
            setState(() {
              _isPlayerReady = true;
            });
          },
          onEnded: (YoutubeMetaData metaData) {
            // Handle video end
          },
        ),
      ],
    );
  }
} 