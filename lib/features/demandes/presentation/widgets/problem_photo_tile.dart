import 'package:flutter/material.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class ProblemPhotoTile extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const ProblemPhotoTile({
    super.key,
    required this.url,
    this.width = 152,
    this.height = 112,
  });

  const ProblemPhotoTile.asset({
    super.key,
    required String imagePath,
    this.width = 152,
    this.height = 112,
  }) : url = imagePath;

  bool get _isNetwork => url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget;
    final Widget viewerImage;

    if (_isNetwork) {
      viewerImage = Image.network(url, fit: BoxFit.contain);
      imageWidget = Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
                width: width,
                height: height,
                color: AppColors.grey200,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: AppColors.grey200,
          child: const Icon(Icons.broken_image, color: AppColors.grey400),
        ),
      );
    } else {
      viewerImage = Image.asset(url, fit: BoxFit.contain);
      imageWidget = Image.asset(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: AppColors.grey200,
          child: const Icon(Icons.broken_image, color: AppColors.grey400),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            body: Center(
              child: InteractiveViewer(
                child: viewerImage,
              ),
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imageWidget,
      ),
    );
  }
}
