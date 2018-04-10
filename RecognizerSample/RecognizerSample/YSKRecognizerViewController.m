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

static NSString *const kTableViewCellReuseIdentifier = @"hypothesesCellID";

@interface YSKRecognizerViewController ()<YSKRecognizerDelegate> {
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_stopButton;
    IBOutlet UIProgressView *_progressView;
    IBOutlet YSKTextView *_logTextView;

    YSKOnlineRecognizer *_recognizer;
}
- (IBAction)onStartButtonTap:(id)sender;
- (IBAction)onStopButtonTap:(id)sender;
@end

@implementation YSKRecognizerViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Recognizer Sample";
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
                [sself createRecognizer];
                sself->_startButton.enabled = YES;
                sself->_stopButton.enabled = YES;
            }
            else {
                [sself->_logTextView appendText:error.localizedDescription];
            }
        });
    });
}

#pragma mark - Actions

- (IBAction)onStartButtonTap:(id)sender
{
    [_recognizer startRecording];
}

- (IBAction)onStopButtonTap:(id)sender
{
    [_recognizer stopRecording];
}

#pragma mark - Internal

- (void)createRecognizer
{
    YSKOnlineRecognizerSettings *settings = [[YSKOnlineRecognizerSettings alloc] initWithLanguage:[YSKLanguage russian] model:[YSKOnlineModel queries]];
    // Optional settings
    settings.disableAntimat = YES;
    settings.enablePunctuation = NO;

    _recognizer = [[YSKOnlineRecognizer alloc] initWithSettings:settings];
    _recognizer.delegate = self;
    [_recognizer prepare];
}

#pragma mark - YSKRecognizerDelegate

- (void)recognizerDidStartRecording:(id<YSKRecognizing>)recognizer
{
    [_logTextView appendText:@"Start recording..."];

    // Start showing voice "power" line.
    _progressView.progress = 0.f;
}

- (void)recognizerDidFinishRecording:(id<YSKRecognizing>)recognizer
{
    [_logTextView appendText:@"Finish recording"];

    // Stop showing voice "power" line.
    _progressView.progress = 0.f;
}

- (void)recognizer:(id<YSKRecognizing>)recognizer didReceivePartialResults:(YSKRecognition *)results withEndOfUtterance:(BOOL)endOfUtterance
{
    [_logTextView appendText:[NSString stringWithFormat:@"Hypotheses: %@", [results.hypotheses componentsJoinedByString:@", "]]];

    if (endOfUtterance) {
        [_logTextView appendText:[NSString stringWithFormat:@"Best result: %@", results.bestResultText]];
    }
}

- (void)recognizerDidFinishRecognition:(id<YSKRecognizing>)recognizer
{
    [_logTextView appendText:@"Finish recognition process"];
}

- (void)recognizer:(id<YSKRecognizing>)recognizer didUpdatePower:(float)power
{
    // Show voice "power" line.
    _progressView.progress = power;
}

- (void)recognizer:(id<YSKRecognizing>)recognizer didFailWithError:(NSError *)error
{
    [_logTextView appendText:error.localizedDescription];
}

@end
