//
//  YSKVocalizerViewController.m
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

#import "YSKVocalizerViewController.h"

@interface YSKVocalizerViewController ()<YSKVocalizerDelegate> {
    NSString *_vocalizerLanguage;
    YSKVocalizer *_vocalizer;
}

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *processStateLabel;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewBottomConstraint;

- (IBAction)onPlayButtonTap:(id)sender;
- (IBAction)onStopButtonTap:(id)sender;

@end

@implementation YSKVocalizerViewController

- (instancetype)initWithLanguage:(NSString *)language
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _vocalizerLanguage = language;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Vocalizer Sample";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_textView action:@selector(resignFirstResponder)];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:_textView action:@selector(resignFirstResponder)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:swipeRecognizer];
}

#pragma mark - Actions

- (IBAction)onPlayButtonTap:(id)sender;
{
    // Create new YSKVocalizer instance for every request, for more options see YSKVocalizer.h.
    _vocalizer = [[YSKVocalizer alloc] initWithText:_textView.text language:_vocalizerLanguage autoPlay:YES voice:@"omazh"];
    _vocalizer.delegate = self;
    
    // Start vocalizer.
    [_vocalizer start];
    
    _playButton.enabled = NO;
}

- (IBAction)onStopButtonTap:(id)sender
{
    // Stop vocalizer.
    [_vocalizer cancel];
}

- (void)onKeyboardWillShowNotification:(NSNotification *)notification
{
    CGRect rawFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat bottomGap = self.view.frame.size.height - CGRectGetMaxY(_textView.frame);
    
    _textViewBottomConstraint.constant = keyboardFrame.size.height - bottomGap + 40.f;
    [_textView setNeedsUpdateConstraints];
}

- (void)onKeyboardWillHideNotification:(NSNotification *)notofication
{
    _textViewBottomConstraint.constant = 20.f;
    [_textView setNeedsUpdateConstraints];
}

#pragma mark - YSKVocalizerDelegate

- (void)vocalizerDidBeginSynthesis:(YSKVocalizer *)vocalizer
{
    // Update UI when synthesis was begun.
    _processStateLabel.text = @"Synthesizing in progress...";
}

- (void)vocalizerDidStartPlaying:(YSKVocalizer *)vocalizer
{
    // Update UI when playing was begun.
    _processStateLabel.text = @"Playing";
}

- (void)vocalizerDidFinishPlaying:(YSKVocalizer *)vocalizer
{
    // Update UI when playing was finished.
    _playButton.enabled = YES;
    _processStateLabel.text = @"Put your text here";
    _vocalizer = nil;
}

- (void)vocalizer:(YSKVocalizer *)vocalizer didFailWithError:(NSError*)error
{
    // Show error alert if something goes wrong.
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [failAlert addAction:defaultAction];
    [self presentViewController:failAlert animated:YES completion:nil];
    
    _playButton.enabled = YES;
}

@end
