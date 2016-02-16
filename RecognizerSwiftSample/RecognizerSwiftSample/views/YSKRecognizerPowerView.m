//
//  YSKRecognizerPowerView.m
//
//  This file is a part of the samples for Yandex SpeechKit Mobile SDK.
//  Version for iOS © 2016 Yandex LLC.
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

#import "YSKRecognizerPowerView.h"
#import "UIColor+Hex.h"

@implementation YSKRecognizerPowerView {
    CALayer *_powerLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialSetup];
}

- (void)initialSetup
{
    _powerLayer = [CALayer layer];
    _powerLayer.backgroundColor = [UIColor YSKBackgroundColor].CGColor;
    [self.layer addSublayer:_powerLayer];
    
    self.power = 0.f;
}

- (void)setPower:(CGFloat)power
{
    NSAssert(power >= 0 || power <= 1.f, @"Progress value should be in range [0, 1]");
    
    _power = power;
    
    CGFloat width = self.bounds.size.width * _power;
    _powerLayer.frame = CGRectMake(floorf(0.5f * (self.bounds.size.width - width)), 0.f, width, self.bounds.size.height);
    
}

@end
