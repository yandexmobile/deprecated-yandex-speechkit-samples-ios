//
//  YSKTextView.m
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
#import "YSKTextView.h"
#import "YSKAppearanceSettings.h"

@implementation YSKTextView {
    NSDateFormatter *_dateFormatter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initialSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    self.backgroundColor = [YSKAppearanceSettings backgroundColor];
    self.font = [YSKAppearanceSettings fontWithSize:14.f];

    self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.layer.borderColor = [YSKAppearanceSettings tintColor].CGColor;
    self.layer.cornerRadius = 4.0;

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"HH:mm:ss:SSS";
}

- (void)appendText:(NSString *)text
{
    NSString *time = [_dateFormatter stringFromDate:[NSDate date]];
    self.text = [NSString stringWithFormat:@"%@\n[%@] %@", self.text, time, text];
    [self scrollRangeToVisible:NSMakeRange(self.text.length - 1, 1)];
}

@end
