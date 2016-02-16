//
//  YSKPhraseSpotterViewController.m
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

#import "YSKPhraseSpotterViewController.h"

@interface YSKPhraseSpotterViewController ()<YSKPhraseSpotterDelegate> {
    NSString *_modelConfigDirectory;
}
@end

@implementation YSKPhraseSpotterViewController

- (instancetype)initWithModelConfigDirectory:(NSString *)configDirectory
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _modelConfigDirectory = configDirectory;
    }
    return self;
}

- (void)dealloc
{
    [YSKPhraseSpotter setDelegate:nil];
    [YSKPhraseSpotter setModel:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PhraseSpotter Sample";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    
    if (![self configureAndStartPhraseSpotterWithError:&error]) {
        [self showAllertWithError:error];
    }
    
    [YSKPhraseSpotter setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [YSKPhraseSpotter stop];
}

#pragma mark - Internal

- (BOOL)configureAndStartPhraseSpotterWithError:(NSError **)error
{
    // Create YSKPhraseSpotterModel with config file directory.
    // For config file format see documentation or sample config.
    // To create custom phrase spotting model please refer documentation.
    YSKPhraseSpotterModel *model = [[YSKPhraseSpotterModel alloc] initWithConfigDirectory:_modelConfigDirectory];
    
    // Load model with pre-setted config and check for error.
    *error = [model load];
    if (![self noErrorForError:*error])
        return NO;
    
    // Set model to PhraseSpotter and check for error.
    *error = [YSKPhraseSpotter setModel:model];
    if (![self noErrorForError:*error])
        return NO;

    // Start PhraseSpotter and check for error.
    *error = [YSKPhraseSpotter start];
    
    return [self noErrorForError:*error];
}

- (void)showAllertWithError:(NSError *)error
{
    // Show error alert if something goes wrong.
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [failAlert addAction:defaultAction];
    [self presentViewController:failAlert animated:YES completion:nil];
}

- (BOOL)noErrorForError:(NSError *)error
{
    // If error code is equal to kYSKErrorOk, there is no error.
    return error.code == kYSKErrorOk;
}

#pragma mark - YSKPhraseSpotterDelegate

- (void)phraseSpotterDidStarted
{
    // Use this callback for your own purpose.
}

- (void)phraseSpotterDidStopped
{
    // Use this callback for your own purpose.
}

- (void)phraseSpotterDidSpotPhrase:(NSString *)phrase withIndex:(int)phraseIndex
{
    // Make an action when PhraseSpotter spotted the phrase.
    NSLog(@"[PhraseStopperSample] YSKPhraseSpotterViewController<%p> -phraseSpotterDidSpotPhrase:%@ withIndex:%d", self, phrase, phraseIndex);
    
    NSString *message = [phrase stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    message = [NSString stringWithFormat:@"\"%@\"", message];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your message is" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) wself = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)phraseSpotterDidFailWithError:(NSError *)error
{
    [self showAllertWithError:error];
}

@end
