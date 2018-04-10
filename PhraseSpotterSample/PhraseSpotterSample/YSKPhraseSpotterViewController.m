//
//  YSKPhraseSpotterViewController.m
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
#import "YSKPhraseSpotterViewController.h"
#import "YSKTextView.h"

@interface YSKPhraseSpotterViewController () <YSKPhraseSpotterDelegate> {
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_stopButton;
    IBOutlet YSKTextView *_logTextView;

    YSKPhraseSpotter *_phraseSpotter;
}
- (IBAction)onStartButtonTap:(id)sender;
- (IBAction)onStopButtonTap:(id)sender;
@end

@implementation YSKPhraseSpotterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PhraseSpotter Sample";
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
                [sself createPhraseSpotter];
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
    [_phraseSpotter start];
}

- (IBAction)onStopButtonTap:(id)sender
{
    [_phraseSpotter stop];
    [_logTextView appendText:@"Stop spotting process"];
}

#pragma mark - Internal

- (void)createPhraseSpotter
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"phrase_spotter_model"];
    YSKPhraseSpotterSettings *settings = [[YSKPhraseSpotterSettings alloc] initWithModelPath:path];
    _phraseSpotter = [[YSKPhraseSpotter alloc] initWithSettings:settings];
    _phraseSpotter.delegate = self;
    [_phraseSpotter prepare];
}

#pragma mark - YSKPhraseSpotterDelegate

- (void)phraseSpotterDidStarted:(YSKPhraseSpotter *)phraseSpotter
{
    [_logTextView appendText:@"Start spotting process..."];
}

- (void)phraseSpotter:(YSKPhraseSpotter *)phraseSpotter didSpotPhrase:(NSString *)phrase withIndex:(NSInteger)phraseIndex
{
    // Make an action when PhraseSpotter spotted the phrase.
    NSString *message = [phrase stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    [_logTextView appendText:[NSString stringWithFormat:@"Spot pharse: %@", message]];
}

- (void)phraseSpotter:(YSKPhraseSpotter *)phraseSpotter didFailWithError:(NSError *)error
{
    [_logTextView appendText:error.localizedDescription];
}

@end
