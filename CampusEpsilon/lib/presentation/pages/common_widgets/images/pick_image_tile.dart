import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/device/utils/image_helper.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/images/pick_image_provider.dart';

class PickImageTile extends StatelessWidget {
  final double size;
  final int index;
  final String? label;

  const PickImageTile(
      {Key? key, this.label, required this.index, required this.size})
      : super(key: key);

  void pickImage(BuildContext context) async {
    final ImageSource? imageSource = await showModalBottomSheet(
      context: context,
      builder: (context) => const ImageSourceSelectionBottomSheet(),
    );
    if (imageSource == null) return;
    final image = await ImageHelper.getAndCropImage(imageSource: imageSource);

    if (image != null && context.mounted) {
      Provider.of<PickImageProvider>(context, listen: false).addImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PickImageProvider>(builder: (context, value, child) {
      final pickedImage = value.getImage(index);
      Widget? imageWidget;
      if (pickedImage == null) {
        imageWidget = Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.black54,
          size: size / 3,
        );
      } else if (pickedImage is File) {
        imageWidget = Image.file(pickedImage, fit: BoxFit.cover);
      } else if (pickedImage is String) {
        imageWidget = CachedNetworkImage(
          imageUrl: pickedImage,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (_, __, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      }
      return Stack(
        children: [
          GestureDetector(
            onTap: () => pickImage(context),
            child: Container(
              width: size,
              height: size,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
              ),
              child: imageWidget,
            ),
          ),
          if (pickedImage != null && label != null)
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                  margin: const EdgeInsets.all(5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    label!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.white),
                  )),
            ),
          if (pickedImage != null)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  backgroundColor: Colors.black26,

                  // backgroundColor:
                ),
                onPressed: () => value.removeImage(index),
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
        ],
      );
    });
  }
}

class ImageSourceSelectionBottomSheet extends StatelessWidget {
  const ImageSourceSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: Column(children: const [
                Icon(Icons.camera_alt_rounded),
                Text("Camera"),
              ]),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: Column(children: const [
                Icon(Icons.photo_library_rounded),
                Text("Gallery"),
              ]),
            ),
          ]),
        ],
      ),
    );
  }
}
