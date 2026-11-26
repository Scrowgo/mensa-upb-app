import 'package:material_ui/material_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/ui/core/theme/tokens.dart';
import 'package:mix/mix.dart';
import '../../../domain/models/dish/dish.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onDetailsTap;
  final VoidCallback onFavoriteTap;

  const DishCard({
    super.key,
    required this.dish,
    required this.onDetailsTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorToken appColor = Theme.of(
      context,
    ).extension<AppColorToken>()!;
    final AppRadiusToken appRadius = Theme.of(
      context,
    ).extension<AppRadiusToken>()!;
    final AppSpaceToken appSpace = Theme.of(
      context,
    ).extension<AppSpaceToken>()!;
    final TextTheme appText = TextTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appRadius.medium),
        color: appColor.background,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appRadius.medium),
        border: Border.all(color: appColor.border, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          // Image section
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: dish.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    color: appColor.backgroundDark,
                    child: Center(
                      child: CircularProgressIndicator(color: appColor.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    color: appColor.backgroundLight,
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        color: appColor.primary,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              // Tags
              Positioned(
                top: appSpace.medium,
                left: appSpace.medium,
                child: Wrap(
                  children: dish.tags.map((tag) {
                    return Padding(
                      padding: EdgeInsets.only(right: appSpace.small),
                      child: DishTagChip(tag: tag),
                    );
                  }).toList(),
                ),
              ),
              // Favorite button
              Positioned(
                top: appSpace.medium,
                right: appSpace.medium,
                child: FavoriteButton(onTap: onFavoriteTap),
              ),
            ],
          ),
          // Content section
          Padding(
            padding: EdgeInsets.only(
              top: appSpace.small,
              left: appSpace.large,
              right: appSpace.large,
              bottom: appSpace.large,
            ),
            child: Column(
              crossAxisAlignment: .end,
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: appText.bodyLarge,
                      ),
                    ),
                    SizedBox(width: appSpace.extraLarge),
                    Text(
                      '${dish.studentPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: appColor.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appSpace.medium),
                DetailsButton(onTap: onDetailsTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DishTagChip extends StatelessWidget {
  final DishTag tag;

  const DishTagChip({super.key, required this.tag});

  Color _getTagTextColor(DishTag tag, AppColorToken appColor) {
    switch (tag) {
      case DishTag.vegan || DishTag.vegetarian:
        return appColor.onPrimary;
      default:
        return appColor.text;
    }
  }

  Color _getTagBgColor(DishTag tag, AppColorToken appColor) {
    switch (tag) {
      case DishTag.vegan || DishTag.vegetarian:
        return appColor.primary;
      default:
        return appColor.backgroundDark.withValues(alpha: 0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorToken appColor = Theme.of(
      context,
    ).extension<AppColorToken>()!;
    final TextTheme appText = TextTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: _getTagBgColor(tag, appColor),
        shape: StadiumBorder(),
      ),
      child: Text(
        tag.displayName,
        style: appText.labelSmall!.copyWith(
          fontWeight: .bold,
          color: _getTagTextColor(tag, appColor),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.onTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorToken appColor = Theme.of(
      context,
    ).extension<AppColorToken>()!;

    final focused = BoxStyler().border(
      .color(isFavorite ? appColor.primary : Colors.white).width(1.5),
    );

    final button = BoxStyler()
        .size(40, 40)
        .color(appColor.backgroundDark.withValues(alpha: 0.8))
        .alignment(.center)
        .shape(.circle())
        .onPressed(.scale(0.85))
        .onFocusVisible(focused)
        .animate(.easeOut(140.ms));

    final icon = IconStyler()
        .color(isFavorite ? appColor.primary : Colors.white)
        .size(20)
        .icon(isFavorite ? Icons.favorite : Icons.favorite_border)
        .animate(.easeInOut(300.ms));

    return button.pressable(onPress: onTap, child: icon());
  }
}

class DetailsButton extends StatelessWidget {
  final VoidCallback onTap;

  const DetailsButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppColorToken appColor = Theme.of(
      context,
    ).extension<AppColorToken>()!;
    final AppRadiusToken appRadius = Theme.of(
      context,
    ).extension<AppRadiusToken>()!;
    final AppSpaceToken appSpace = Theme.of(
      context,
    ).extension<AppSpaceToken>()!;
    final TextTheme appText = TextTheme.of(context);

    final focused = BoxStyler().border(.color(appColor.primary).width(1.5));

    final button = BoxStyler()
        .color(appColor.primary)
        .padding(.symmetric(horizontal: 16, vertical: 10))
        .borderRadius(.all(Radius.circular(appRadius.extraSmall)))
        .onPressed(.scale(0.95))
        .onFocusVisible(focused)
        .animate(.easeOut(140.ms));

    final icon = IconStyler()
        .color(appColor.onPrimary)
        .size(20)
        .icon(Icons.arrow_forward);

    return button.pressable(
      child: Row(
        mainAxisSize: .min,
        spacing: appSpace.small,
        children: [
          Text(
            'Details',
            style: appText.bodyMedium!.copyWith(
              color: appColor.onPrimary,
              fontWeight: .w700,
            ),
          ),
          icon(),
        ],
      ),
    );
  }
}
