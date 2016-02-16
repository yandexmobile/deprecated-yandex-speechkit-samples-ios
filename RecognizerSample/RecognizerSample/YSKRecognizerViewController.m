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
#import "UIView+NIB.h"
#import "YSKRecognizerSectionHeaderView.h"
#import "YSKRecognizerPowerView.h"
#import "YSKRecognizerCell.h"

static NSString *const kTableViewCellReuseIdentifier = @"hypothesesCellID";

@interface YSKRecognizerViewController ()<YSKRecognizerDelegate> {
    YSKRecognizerSectionHeaderView *_sectionHeaderView;
    
    YSKRecognition *_recognition;
    YSKRecognizer *_recognizer;
    
    NSString *_recognizerModel;
    NSString *_recognizerLanguage;
}

@end

@implementation YSKRecognizerViewController

- (instancetype)initWithRecognizerModel:(NSString *)model language:(NSString *)language
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _recognizerLanguage = language;
        _recognizerModel = model;
    }
    return self;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Recognizer Sample";
    
    _sectionHeaderView = [YSKRecognizerSectionHeaderView loadFromNIB];
    [_sectionHeaderView.recognizeButton addTarget:self action:@selector(onRecognizeButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeaderView.stopButton addTarget:self action:@selector(onStopButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"YSKRecognizerCell" bundle:nil] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
}

#pragma mark - Actions

- (void)onRecognizeButtonTap
{
    // Create new YSKRecognizer instance for every request.
    _recognizer = [[YSKRecognizer alloc] initWithLanguage:_recognizerLanguage model:_recognizerModel];
    _recognizer.delegate = self;
    _recognizer.VADEnabled = YES;
    
    // Cleanup previouse result.
    _recognition = nil;

    // Start recognition.
    [_recognizer start];
}

- (void)onStopButtonTap
{
    // Stop recognition.
    [_recognizer cancel];
    _recognizer = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recognition.hypotheses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSKRecognizerCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    // Use recognition YSKRecognition -bestResultText value for the best recognition result.
    // Or -hypotheses for displaying all options.
    YSKRecognitionHypothesis *hypothesis = (YSKRecognitionHypothesis *)_recognition.hypotheses[indexPath.row];
    cell.resultLabel.text = hypothesis.normalized;
    cell.percentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)(100 * hypothesis.confidence)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72.f;
}

#pragma mark - YSKRecognizerDelegate

- (void)recognizerDidStartRecording:(YSKRecognizer *)recognizer
{
    [self.tableView reloadData];
    _sectionHeaderView.recognizeButton.enabled = NO;
    
    // Start showing voice "power" line.
    _sectionHeaderView.powerView.power = 0.f;
}

- (void)recognizerDidFinishRecording:(YSKRecognizer *)recognizer
{
    // Stop showing voice "power" line.
    _sectionHeaderView.powerView.power = 0.f;
}

- (void)recognizer:(YSKRecognizer *)recognizer didReceivePartialResults:(YSKRecognition *)results withEndOfUtterance:(BOOL)endOfUtterance
{
    _recognition = results;
    [self.tableView reloadData];
}

- (void)recognizer:(YSKRecognizer *)recognizer didCompleteWithResults:(YSKRecognition *)results
{
    _recognition = results;
    [self.tableView reloadData];
    
    _recognizer = nil;
    _sectionHeaderView.recognizeButton.enabled = YES;
}

- (void)recognizer:(YSKRecognizer *)recognizer didUpdatePower:(float)power
{
    // Show voice "power" line.
    _sectionHeaderView.powerView.power = power;
}

- (void)recognizer:(YSKRecognizer *)recognizer didFailWithError:(NSError *)error
{
    // Show error alert if something goes wrong.
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [failAlert addAction:defaultAction];
    [self presentViewController:failAlert animated:YES completion:nil];
    
    _recognizer = nil;
    _sectionHeaderView.recognizeButton.enabled = YES;
}

@end
