//
//  YSKVocalizerViewController.swift
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

class YSKVocalizerViewController: UIViewController, YSKVocalizerDelegate, UITextViewDelegate {

    private var vocalizer: YSKOnlineVocalizer?

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var synthesisTextView: UITextView!
    @IBOutlet weak var logTextView: YSKTextView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK :- UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vocalizer Sample";
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
                    self.createVocalizer()
                    self.startButton.isEnabled = true
                    self.stopButton.isEnabled = true
                }
            }
        }
    }

    //MARK: - Actions

    @IBAction func onStartButtonTap() {
        // Start vocalizer.
        vocalizer?.synthesize(synthesisTextView.text, mode: .append)
    }

    @IBAction func onStopButtonTap() {
        // Stop vocalizer.
        vocalizer?.cancel()
        logTextView.append(text: "Stop playing")
    }

    //MARK: - Internal

    private func createVocalizer() {
        let settings = YSKOnlineVocalizerSettings(language: YSKLanguage.russian())
        //Optional settings
        settings.voice = YSKVoice.ermil()
        settings.emotion = YSKEmotion.good()

        vocalizer = YSKOnlineVocalizer(settings: settings)
        vocalizer?.delegate = self
        vocalizer?.prepare()
    }

    //MARK: - YSKVocalizerDelegate

    func vocalizer(_ vocalizer: YSKVocalizing, didReceivePartialSynthesis synthesis: YSKSynthesis) {
        // Update UI when synthesis was begun.
        logTextView.append(text: "Synthesis: " + synthesis.description)
    }

    func vocalizerDidStartPlaying(_ vocalizer: YSKVocalizing) {
        // Update UI when playing was begun.
        logTextView.append(text: "Start playing")
    }

    func vocalizerDidFinishPlaying(_ vocalizer: YSKVocalizing) {
        // Update UI when playing was finished.
        logTextView.append(text: "Finish playing")
    }

    func vocalizer(_ vocalizer: YSKVocalizing, didFailWithError error: Error) {
        logTextView.append(text: error.localizedDescription)
    }

    //MARK: - UITextViewDelegate

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}
