//
//  YSKRecognizerViewController.swift
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

import UIKit

class YSKRecognizerViewController: UITableViewController, YSKRecognizerDelegate {

    let kTableViewCellReuseIdentifier = "cellID"
    
    var recognizer: YSKRecognizer?
    var recognition: YSKRecognition?
    
    var recognizerLanguage: String?
    var recognizerModel: String?
    
    var sectionHeaderView: YSKRecognizerSectionHeaderView?
    
    convenience init(recognizerLanguage language: String?, recognizerModel model: String?) {
        self.init(style: UITableViewStyle.Plain)
        
        recognizerLanguage = language
        recognizerModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recognizer Swift Sample"
        
        sectionHeaderView = YSKRecognizerSectionHeaderView.loadFromNIB() as? YSKRecognizerSectionHeaderView
        
        sectionHeaderView?.recognizeButton?.addTarget(self, action: "onRecognizerButtonTap", forControlEvents: UIControlEvents.TouchUpInside)
        sectionHeaderView?.stopButton?.addTarget(self, action: "onStopButtonTap", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib.init(nibName: "YSKRecognizerCell", bundle: nil), forCellReuseIdentifier: kTableViewCellReuseIdentifier)
    }

    // MARK: - Actions
    
    func onRecognizerButtonTap() {
        // Create new YSKRecognizer instance for every request.
        recognizer = YSKRecognizer.init(language: recognizerLanguage, model: recognizerModel)
        recognizer?.delegate = self
        recognizer?.VADEnabled = true
        
        // Cleanup previouse result.
        recognition = nil;

        // Start recognition.
        recognizer?.start();
    }
    
    func onStopButtonTap() {
        //Stop recognition
        recognizer?.cancel()
        recognizer = nil
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognition?.hypotheses?.count ?? 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kTableViewCellReuseIdentifier, forIndexPath: indexPath) as? YSKRecognizerCell

        // Use recognition YSKRecognition -bestResultText value for the best recognition result.
        // Or -hypotheses for displaying all options.
        let hypothesis = recognition!.hypotheses[indexPath.row]
        cell!.resultLabel?.text = hypothesis.normalized
        cell!.percentLabel?.text = String(format: "%ld%%", (100 * hypothesis.confidence))
        
        return cell!
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72.0
    }
    
    // MARK: - YSKRecognizerDelegate
    
    func recognizerDidStartRecording(recognizer: YSKRecognizer!) {
        self.tableView.reloadData()
        sectionHeaderView?.recognizeButton?.enabled = false
        
        // Start showing voice "power" line.
        sectionHeaderView?.powerView?.power = 0.0
    }
    
    func recognizerDidFinishRecording(recognizer: YSKRecognizer!) {
        // Stop showing voice "power" line.
        sectionHeaderView?.powerView?.power = 0.0
    }
    
    func recognizer(recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        recognition = results
        self.tableView.reloadData()
    }
    
    func recognizer(recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        recognition = results
        self.tableView.reloadData()
        
        self.recognizer = nil;
        sectionHeaderView?.recognizeButton?.enabled = true
    }
    
    func recognizer(recognizer: YSKRecognizer!, didUpdatePower power: Float) {
        // Show voice "power" line.
        sectionHeaderView?.powerView?.power = CGFloat(power)
    }
    
    func recognizer(recognizer: YSKRecognizer!, didFailWithError error: NSError!) {
        let failAlert = UIAlertController.init(title: nil, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        failAlert.addAction(action)
        
        self.presentViewController(failAlert, animated: true, completion: nil);
        
        self.recognizer = nil;
        sectionHeaderView?.recognizeButton?.enabled = true
    }

}
