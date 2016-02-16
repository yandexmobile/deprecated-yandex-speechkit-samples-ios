//
//  YSKRecognizerViewController.m
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

#import "YSKRecognizerViewController.h"

@interface YSKRecognizerViewController ()<YSKSpeechRecognitionViewControllerDelegate> {
    NSString *_recognizerModel;
    NSString *_recognizerLanguage;
}

@property (nonatomic, weak) IBOutlet UITextView *resultTextView;

- (IBAction)onRecognizerButtonTap:(id)sender;

@end

@implementation YSKRecognizerViewController

- (instancetype)initWithLanguage:(NSString *)language model:(NSString *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _recognizerModel = model;
        _recognizerLanguage = language;
    }
    return self;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Recognizer GUI Sample";
}

#pragma mark - Actions

- (IBAction)onRecognizerButtonTap:(id)sender
{
    // Initialize YSKSpeechRecognitionViewController instance with language and model.
    YSKSpeechRecognitionViewController *controller = [[YSKSpeechRecognitionViewController alloc] initWithLanguage:_recognizerLanguage model:_recognizerModel];
    controller.delegate = self;
    
    // Show YSKSpeechRecognitionViewController.
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - YSKSpeechRecognitionViewControllerDelegate

- (void)speechRecognitionViewController:(YSKSpeechRecognitionViewController *)speechRecognitionViewController didFinishWithResult:(NSString *)result
{
    // Show YSKSpeechRecognitionViewController result...
    _resultTextView.text = result;
    
    // and hide it.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)speechRecognitionViewController:(YSKSpeechRecognitionViewController *)speechRecognitionViewController didFailWithError:(NSError *)error
{
    // Show error alert if something goes wrong.
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [failAlert addAction:defaultAction];
    
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [wself presentViewController:failAlert animated:YES completion:nil];
    }];
}

- (void)speechRecognitionViewController:(YSKSpeechRecognitionViewController *)speechRecognitionViewController didChangeLanguage:(NSString *)language
{
    // Here you can remember selected language and use it when starting recognition next time.
}

@end
