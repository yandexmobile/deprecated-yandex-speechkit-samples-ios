//
//  YSKRecognizerViewController.swift
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

import UIKit

class YSKRecognizerViewController: UIViewController, YSKRecognizerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var logTextView: YSKTextView!

    var recognizer: YSKOnlineRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recognizer Swift Sample"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Before start recording or playing you should activate application's audio session.
        // See YSKAudioSessionHandler class for details of why YandexSpeechKit needed audio session.
        // Read more about AVAudioSession here https://developer.apple.com/documentation/avfoundation/avaudiosession.
        DispatchQueue.global(qos: .default).async { [unowned self] in
            var activationError: Error?
            do {
                // This process could take much time, so it's recommended to call this method in background thread.
                try YSKAudioSessionHandler.sharedInstance().activateAudioSession()
            } catch let error {
                activationError = error
            }

            DispatchQueue.main.async {
                if let error = activationError {
                    self.logTextView.append(text: error.localizedDescription)
                } else {
                    self.createRecognizer()
                    self.startButton.isEnabled = true
                    self.stopButton.isEnabled = true
                }
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func onStartButtonTap() {
        // Start recognition.
        recognizer?.startRecording()
    }
    
    @IBAction func onStopButtonTap() {
        //Stop recognition
        recognizer?.stopRecording()
    }

    // MARK: - Internal

    private func createRecognizer() {
        let settings = YSKOnlineRecognizerSettings(language: YSKLanguage.russian(), model: YSKOnlineModel.queries())
        //Optional settings
        settings.disableAntimat = true
        settings.enablePunctuation = false

        recognizer = YSKOnlineRecognizer(settings: settings)
        recognizer?.delegate = self
        recognizer?.prepare()
    }
    
    // MARK: - YSKRecognizerDelegate
    
    func recognizerDidStartRecording(_ recognizer: YSKRecognizing) {
        logTextView.append(text: "Start recording...")

        // Start showing voice "power" line.
        progressView.progress = 0.0
    }
    
    func recognizerDidFinishRecording(_ recognizer: YSKRecognizing) {
        logTextView.append(text: "Finish recording")

        // Stop showing voice "power" line.
        progressView.progress = 0.0
    }
    
    func recognizer(_ recognizer: YSKRecognizing, didReceivePartialResults results: YSKRecognition, withEndOfUtterance endOfUtterance: Bool) {
        logTextView.append(text: "Hypotheses: " + results.description)

        if endOfUtterance {
            logTextView.append(text: "Best result: " + results.bestResultText);
        }
    }
    
    func recognizerDidFinishRecognition(_ recognizer: YSKRecognizing) {
        logTextView.append(text: "Finish recognition process")
    }
    
    func recognizer(_ recognizer: YSKRecognizing, didUpdatePower power: Float) {
        // Show voice "power" line.
        progressView.progress = power
    }
    
    func recognizer(_ recognizer: YSKRecognizing, didFailWithError error: Error) {
        logTextView.append(text: error.localizedDescription)
    }

}
