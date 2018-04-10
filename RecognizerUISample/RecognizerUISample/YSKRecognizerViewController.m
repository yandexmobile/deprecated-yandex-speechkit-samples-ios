//
//  YSKRecognizerViewController.m
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
#import "YSKRecognizerViewController.h"
#import "YSKTextView.h"

@interface YSKRecognizerViewController ()<YSKRecognizerDialogControllerDelegate> {
    IBOutlet UIButton *_startButton;
    IBOutlet YSKTextView *_logTextView;
}
- (IBAction)onStartButtonTap:(id)sender;
@end

@implementation YSKRecognizerViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Recognizer GUI Sample";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Before start recording or playing you should activate application's audio session.
    // See YSKAudioSessionHandler class for details of why YandexSpeechKit needed audio session.
    // Read more about AVAudioSession here https://developer.apple.com/documentation/avfoundation/avaudiosession.
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(wself) sself = wself;
        if (sself == nil) return;

        NSError *error;
        // This process could take much time, so it's recommended to call this method in background thread.
        BOOL success = [[YSKAudioSessionHandler sharedInstance] activateAudioSession:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                sself->_startButton.enabled = YES;
            }
            else {
                [sself->_logTextView appendText:error.localizedDescription];
            }
        });
    });
}

#pragma mark - Action

- (IBAction)onStartButtonTap:(id)sender
{
    YSKOnlineRecognizerSettings *recognizerSettings = [[YSKOnlineRecognizerSettings alloc] initWithLanguage:[YSKLanguage russian] model:[YSKOnlineModel queries]];
    YSKRecognizerDialogController *controller = [[YSKRecognizerDialogController alloc] initWithRecognizerSettings:recognizerSettings];
    controller.delegate = self;
    [controller presentRecognizerDialogOverPresentingController:self animated:YES completion:nil];
}

#pragma mark - YSKRecognizerDialogControllerDelegate

- (void)recognizerDialogController:(YSKRecognizerDialogController *)controller didFinishWithResult:(NSString *)result
{
    // Show YSKRecognizerDialogController result.
    [_logTextView appendText:result];
}

- (void)recognizerDialogController:(YSKRecognizerDialogController *)controller didFailWithError:(NSError *)error
{
    // Show error alert if something goes wrong.
    [_logTextView appendText:error.localizedDescription];
}

- (void)recognizerDialogControllerDidClose:(YSKRecognizerDialogController *)controller automatically:(BOOL)automatically
{
    [_logTextView appendText:[NSString stringWithFormat:@"Dialog was closed %@", automatically ? @"automatically" : @"by user"]];
}

@end
