//
//  YSKVocalizerViewController.m
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
#import "YSKVocalizerViewController.h"
#import "YSKTextView.h"

@interface YSKVocalizerViewController ()<YSKVocalizerDelegate, UITextViewDelegate> {
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_stopButton;
    IBOutlet YSKTextView *_synthesisTextView;
    IBOutlet YSKTextView *_logTextView;

    YSKOnlineVocalizer *_vocalizer;
}
- (IBAction)onStartButtonTap:(id)sender;
- (IBAction)onStopButtonTap:(id)sender;
@end

@implementation YSKVocalizerViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Vocalizer Sample";
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
                [sself createVocalizer];
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

- (IBAction)onStartButtonTap:(id)sender;
{
    // Start vocalizer.
    [_vocalizer synthesize:_synthesisTextView.text mode:YSKTextSynthesizingModeAppend];
}

- (IBAction)onStopButtonTap:(id)sender
{
    // Stop vocalizer.
    [_vocalizer cancel];
    [_logTextView appendText:@"Stop playing"];
}

#pragma mark - Internal

- (void)createVocalizer
{
    YSKOnlineVocalizerSettings *settings = [[YSKOnlineVocalizerSettings alloc] initWithLanguage:[YSKLanguage russian]];
    //Optional settings
    settings.voice = [YSKVoice ermil];
    settings.emotion = [YSKEmotion good];

    _vocalizer = [[YSKOnlineVocalizer alloc] initWithSettings:settings];
    _vocalizer.delegate = self;
    [_vocalizer prepare];
}

#pragma mark - YSKVocalizerDelegate

- (void)vocalizer:(id<YSKVocalizing>)vocalizer didReceivePartialSynthesis:(YSKSynthesis *)synthesis
{
    // Update UI when synthesis was begun.
    [_logTextView appendText:[NSString stringWithFormat:@"Synthesis: %@", synthesis.description]];
}

- (void)vocalizerDidStartPlaying:(id<YSKVocalizing>)vocalizer
{
    // Update UI when playing was begun.
    [_logTextView appendText:@"Start playing..."];
}

- (void)vocalizerDidFinishPlaying:(id<YSKVocalizing>)vocalizer
{
    // Update UI when playing was finished.
    [_logTextView appendText:@"Finish playing"];
}

- (void)vocalizer:(id<YSKVocalizing>)vocalizer didFailWithError:(NSError*)error
{
    // Show error alert if something goes wrong.
    [_logTextView appendText:error.localizedDescription];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

@end
