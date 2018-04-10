//
//  YSKAppearanceSettings.m
//
//  This file is a part of the samples for Yandex SpeechKit Mobile SDK.
//  Version for iOS © 2018 Yandex LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "YSKAppearanceSettings.h"
#import "UIColor+Hex.h"

@implementation YSKAppearanceSettings

+ (void)apply
{
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName: [YSKAppearanceSettings font]};
    [UINavigationBar appearance].tintColor = [YSKAppearanceSettings tintColor];
    [UIProgressView appearance].progressTintColor = [YSKAppearanceSettings backgroundColorWithAlpha:.8f];
    [UIProgressView appearance].trackTintColor = [YSKAppearanceSettings tintColorWithAlpha:.8f];
}

+ (UIColor *)tintColor
{
    return [self tintColorWithAlpha:1.f];
}

+ (UIColor *)tintColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHex:@"0x4065A0" alpha:alpha];
}

+ (UIColor *)backgroundColor
{
    return [self backgroundColorWithAlpha:1.f];
}

+ (UIColor *)backgroundColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHex:@"0xFFFFFF" alpha:alpha];
}

+ (UIFont *)font
{
    return [self fontWithSize:17.f];
}

+ (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

@end
