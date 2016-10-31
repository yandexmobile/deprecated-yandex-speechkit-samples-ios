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
        self.init(style: .plain)
        
        recognizerLanguage = language
        recognizerModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Recognizer Swift Sample"
        
        sectionHeaderView = YSKRecognizerSectionHeaderView.loadFromNIB() as? YSKRecognizerSectionHeaderView
        
        sectionHeaderView?.recognizeButton?.addTarget(self, action: #selector(YSKRecognizerViewController.onRecognizerButtonTap), for: .touchUpInside)
        sectionHeaderView?.stopButton?.addTarget(self, action: #selector(YSKRecognizerViewController.onStopButtonTap), for: .touchUpInside)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: "YSKRecognizerCell", bundle: nil), forCellReuseIdentifier: kTableViewCellReuseIdentifier)
    }

    // MARK: - Actions
    
    func onRecognizerButtonTap() {
        // Create new YSKRecognizer instance for every request.
        recognizer = YSKRecognizer(language: recognizerLanguage, model: recognizerModel)
        recognizer?.delegate = self
        recognizer?.isVADEnabled = true
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognition?.hypotheses?.count ?? 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellReuseIdentifier, for: indexPath) as? YSKRecognizerCell

        // Use recognition YSKRecognition -bestResultText value for the best recognition result.
        // Or -hypotheses for displaying all options.
        let hypothesis = recognition!.hypotheses[indexPath.row] as! YSKRecognitionHypothesis
        cell!.resultLabel?.text = hypothesis.normalized
        cell!.percentLabel?.text = String(format: "%ld%%", (100 * hypothesis.confidence))
        
        return cell!
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72.0
    }
    
    // MARK: - YSKRecognizerDelegate
    
    func recognizerDidStartRecording(_ recognizer: YSKRecognizer!) {
        tableView.reloadData()
        sectionHeaderView?.recognizeButton?.isEnabled = false
        
        // Start showing voice "power" line.
        sectionHeaderView?.powerView?.power = 0.0
    }
    
    func recognizerDidFinishRecording(_ recognizer: YSKRecognizer!) {
        // Stop showing voice "power" line.
        sectionHeaderView?.powerView?.power = 0.0
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        recognition = results
        tableView.reloadData()
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        recognition = results
        tableView.reloadData()
        
        self.recognizer = nil;
        sectionHeaderView?.recognizeButton?.isEnabled = true
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didUpdatePower power: Float) {
        // Show voice "power" line.
        sectionHeaderView?.powerView?.power = CGFloat(power)
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didFailWithError error: Error!) {
        let failAlert = UIAlertController.init(title: nil, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        failAlert.addAction(action)
        
        self.present(failAlert, animated: true, completion: nil);
        
        self.recognizer = nil;
        sectionHeaderView?.recognizeButton?.isEnabled = true
    }

}
