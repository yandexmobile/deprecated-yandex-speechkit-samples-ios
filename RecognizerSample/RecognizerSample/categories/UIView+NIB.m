//
//  UIView+NIB.m
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

#import "UIView+NIB.h"

@implementation UIView (NIB)

+ (instancetype)loadFromNIB
{
    return [self loadFromNIBWithOwner:self];
}

+ (instancetype)loadFromNIBWithOwner:(id)owner
{
    return [self loadFromNIB:[self description] owner:owner];
}

+ (instancetype)loadFromNIB:(NSString*)nibName
{
    return [self loadFromNIB:nibName owner:self];
}

+ (instancetype)loadFromNIB:(NSString*)nibName owner:(id)owner
{
    Class klass = [self class];
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    
    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return object;
        }
    }
    
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(klass)];
    
    return nil;
}

@end
