import 'dart:io';
import 'package:flutter/material.dart';

class ImageGridBuilder {
  static Widget buildImageGrid(List<String> imageUrls) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = 350;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(2), // Border thickness
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: _buildImageContent(imageUrls, maxWidth, maxHeight),
          ),
        );
      },
    );
  }

  static Widget _buildImageContent(List<String> imageUrls, double maxWidth, double maxHeight) {
    switch (imageUrls.length) {
      case 1:
        return _buildSingleImage(imageUrls[0], maxWidth, maxHeight);
      case 2:
        return _buildTwoImages(imageUrls, maxWidth, maxHeight);
      case 3:
        return _buildThreeImages(imageUrls, maxWidth, maxHeight);
      case 4:
        return _buildFourImages(imageUrls, maxWidth, maxHeight);
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget _buildSingleImage(String imageUrl, double maxWidth, double maxHeight) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: _buildImage(imageUrl, maxWidth, maxHeight),
      ),
    );
  }

  static Widget _buildTwoImages(List<String> imageUrls, double maxWidth, double maxHeight) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildImage(imageUrls[0], maxWidth, maxHeight),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildImage(imageUrls[1], maxWidth, maxHeight),
          ),
        ),
      ],
    );
  }

static Widget _buildThreeImages(List<String> imageUrls, double maxWidth, double maxHeight) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: AspectRatio(
          aspectRatio: 1,
          child: _buildImage(imageUrls[0], maxWidth, maxHeight),
        ),
      ),
      const SizedBox(width: 2),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[1], maxWidth, maxHeight),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              fit: FlexFit.loose,
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[2], maxWidth, maxHeight),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



  static Widget _buildFourImages(List<String> imageUrls, double maxWidth, double maxHeight) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImage(imageUrls[0], maxWidth, maxHeight)),
                const SizedBox(width: 2),
                Expanded(child: _buildImage(imageUrls[1], maxWidth, maxHeight)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImage(imageUrls[2], maxWidth, maxHeight)),
                const SizedBox(width: 2),
                Expanded(child: _buildImage(imageUrls[3], maxWidth, maxHeight)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildImage(String imageUrl, double maxWidth, double maxHeight) {
    return (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: maxWidth,
            height: maxHeight,
          )
        : Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            width: maxWidth,
            height: maxHeight,
          );
  }
}
