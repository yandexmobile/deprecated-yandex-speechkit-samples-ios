//
//  YSKAppDelegate.m
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

#import <YandexSpeechKit/SpeechKit.h>

#import "YSKAppDelegate.h"
#import "YSKRecognizerViewController.h"

@implementation YSKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure SpeechKit lib, this method should be called _before_ any SpeechKit functions.
    // Generate your own app key for this purpose.
    [[YSKSpeechKit sharedInstance] configureWithAPIKey:@"069b6659-984b-4c5f-880e-aaedcfd84102"];

    // [OPTIONAL] Set SpeechKit log level, for more options see YSKLogLevel enum.
    [[YSKSpeechKit sharedInstance] setLogLevel:YSKLogLevelWarn];
    
    // [OPTIONAL] Set YSKSpeechKit parameters, for all parameters and possible values see documentation.
    [[YSKSpeechKit sharedInstance] setParameter:YSKDisableAntimat withValue:@"false"];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    YSKRecognizerViewController *controller = [[YSKRecognizerViewController alloc] initWithRecognizerModel:YSKRecognitionModelGeneral language:YSKRecognitionLanguageRussian];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBar.translucent = NO;
    _window.rootViewController = navigationController;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
