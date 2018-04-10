//
//  YSKAppDelegate.m
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

#import <YandexSpeechKit/YandexSpeechKit.h>

#import "YSKAppDelegate.h"
#import "YSKRecognizerViewController.h"
#import "YSKAppearanceSettings.h"

@implementation YSKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure SpeechKit lib, this method should be called _before_ any SpeechKit functions.
    // Generate your own app key for this purpose.
    [YSKSpeechKit sharedInstance].apiKey = @"developer_app_key";

    // [OPTIONAL] Set SpeechKit log level, for more options see YSKLogLevel enum.
    [YSKSpeechKit sharedInstance].logLevel = YSKLogLevelWarn;

    // Required for online requests
    [YSKSpeechKit sharedInstance].uuid = @"application_uuid";

    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    [YSKAppearanceSettings apply];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[YSKRecognizerViewController new]];
    navigationController.navigationBar.translucent = NO;
    _window.rootViewController = navigationController;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
