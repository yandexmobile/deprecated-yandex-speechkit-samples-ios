//
//  YSKPhraseSpotterViewController.swift
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

class YSKPhraseSpotterViewController: UIViewController, YSKPhraseSpotterDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var logTextView: YSKTextView!

    private var phraseSpotter: YSKPhraseSpotter?

    //MARK :- UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PhraseSpotter Sample"
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
                    self.createPharseSpotter()
                    self.startButton.isEnabled = true
                    self.stopButton.isEnabled = true
                }
            }
        }
    }

    //MARK :- Actions

    @IBAction func onStartButtonTap() {
        phraseSpotter?.start()
    }

    @IBAction func onStopButtonTap() {
        phraseSpotter?.stop()
    }

    //MARK: - Internal

    private func createPharseSpotter() {
        let modelPath = Bundle.main.resourcePath?.appending("/phrase_spotter_model")
        guard let path = modelPath else {
            logTextView.append(text: "Unable to load phrase spotter model.")
            return
        }

        let settings = YSKPhraseSpotterSettings(modelPath: path)
        phraseSpotter = YSKPhraseSpotter(settings: settings)
        phraseSpotter?.delegate = self
        phraseSpotter?.prepare()
    }

    //MARK :- YSKPhraseSpotterDelegate

    func phraseSpotterDidStarted(_ phraseSpotter: YSKPhraseSpotter) {
        // Use this callback for your own purpose.
        logTextView.append(text: "Start spotting process...")
    }

    func phraseSpotter(_ phraseSpotter: YSKPhraseSpotter, didSpotPhrase phrase: String, with phraseIndex: Int) {
        // Make an action when PhraseSpotter spotted the phrase.
        logTextView.append(text: "Spot phrase: " + phrase.replacingOccurrences(of: "-", with: " "))
    }

    func phraseSpotter(_ phraseSpotter: YSKPhraseSpotter, didFailWithError error: Error) {
        logTextView.append(text: error.localizedDescription)
    }
}
