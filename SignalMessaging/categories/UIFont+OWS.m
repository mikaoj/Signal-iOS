//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "UIFont+OWS.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIFont (OWS)

+ (UIFont *)ows_thinFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}

+ (UIFont *)ows_lightFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
}

+ (UIFont *)ows_regularFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

+ (UIFont *)ows_mediumFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

+ (UIFont *)ows_boldFontWithSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}

#pragma mark - Icon Fonts

+ (UIFont *)ows_fontAwesomeFont:(CGFloat)size
{
    return [UIFont fontWithName:@"FontAwesome" size:size];
}

+ (UIFont *)ows_dripIconsFont:(CGFloat)size
{
    return [UIFont fontWithName:@"dripicons-v2" size:size];
}

+ (UIFont *)ows_elegantIconsFont:(CGFloat)size
{
    return [UIFont fontWithName:@"ElegantIcons" size:size];
}

#pragma mark - Dynamic Type

+ (UIFont *)ows_dynamicTypeTitle1Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
}

+ (UIFont *)ows_dynamicTypeTitle2Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
}

+ (UIFont *)ows_dynamicTypeTitle3Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
}

+ (UIFont *)ows_dynamicTypeHeadlineFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

+ (UIFont *)ows_dynamicTypeSubheadlineFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

+ (UIFont *)ows_dynamicTypeBodyFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

+ (UIFont *)ows_dynamicTypeFootnoteFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

+ (UIFont *)ows_dynamicTypeCaption1Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (UIFont *)ows_dynamicTypeCaption2Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

#pragma mark - Styles

- (UIFont *)ows_italic
{
    return [self styleWithSymbolicTraits:UIFontDescriptorTraitItalic];
}

- (UIFont *)styleWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symbolicTraits
{
    UIFontDescriptor *fontDescriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits];
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:0];
    OWSAssert(font);
    return font ?: self;
}

- (UIFont *)ows_medium
{
    // The recommended approach of deriving "medium" weight fonts for dynamic
    // type fonts is:
    //
    // [UIFontDescriptor fontDescriptorByAddingAttributes:...]
    //
    // But this doesn't seem to work in practice on iOS 11 using UIFontWeightMedium.

    UIFont *derivedFont = [UIFont systemFontOfSize:self.pointSize weight:UIFontWeightMedium];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(11, 0)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        return [[UIFontMetrics defaultMetrics] scaledFontForFont:derivedFont];
#pragma clang diagnostic pop
    } else {
        return derivedFont;
    }
}

@end

NS_ASSUME_NONNULL_END
