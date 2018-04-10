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

class YSKRecognizerViewController: UIViewController, YSKRecognizerDialogControllerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logTextView: YSKTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recognizer GUI Sample"
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
                    self.startButton.isEnabled = true
                }
            }
        }
    }

    //MARK: - Internal

    @IBAction func onStartButtonTap() {
        let recognizerSettings = YSKOnlineRecognizerSettings(language: YSKLanguage.russian(), model: YSKOnlineModel.queries())
        let recognitionController = YSKRecognizerDialogController(recognizerSettings: recognizerSettings)
        recognitionController.delegate = self
        recognitionController.presentRecognizerDialogOverPresenting(self, animated: true, completion: nil)
    }

    //MARK: - YSKRecognizerDialogControllerDelegate

    func recognizerDialogController(_ controller: YSKRecognizerDialogController, didFinishWithResult result: String) {
        logTextView.append(text: result)
    }

    func recognizerDialogController(_ controller: YSKRecognizerDialogController, didFailWithError error: Error) {
        logTextView.append(text: error.localizedDescription)
    }

    func recognizerDialogControllerDidClose(_ controller: YSKRecognizerDialogController, automatically: Bool) {
        logTextView.append(text: "Dialog was closed " + (automatically ? "automatically" : "by user"))
    }

}
