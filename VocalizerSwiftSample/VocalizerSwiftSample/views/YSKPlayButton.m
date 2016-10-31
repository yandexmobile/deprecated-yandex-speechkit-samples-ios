//
//  YSKPlayButton.m
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

#import "YSKPlayButton.h"
#import "UIColor+Brightness.h"
#import "UIColor+Hex.h"

@implementation YSKPlayButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = self.enabled ? [UIColor YSKBackgroundColor] : [[UIColor YSKBackgroundColor] setBrightness:0.7f];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, 0.f, 0.f);
    CGContextAddLineToPoint(context, 0.f, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, floorf(0.5f * self.frame.size.height));
    CGContextClosePath(context);
    
    CGContextFillPath(context);
}

@end
