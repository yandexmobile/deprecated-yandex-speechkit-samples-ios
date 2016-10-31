//
//  YSKPhraseSpotterViewController.swift
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

class YSKPhraseSpotterViewController: UIViewController, YSKPhraseSpotterDelegate {

    private var modelDirectory: String = ""

    init(modelDirectory: String) {
        super.init(nibName: nil, bundle: nil)
        self.modelDirectory = modelDirectory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        YSKPhraseSpotter.setDelegate(nil)
        YSKPhraseSpotter.setModel(nil)
    }

    //MARK :- UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PhraseSpotter Sample"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            try configureAndStartPhraseSpotter()
        } catch let error {
            showAlert(error: error)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        YSKPhraseSpotter.stop()
    }

    //MARK :- Internal

    private func configureAndStartPhraseSpotter() throws {
        let model = YSKPhraseSpotterModel(configDirectory: modelDirectory)
        var error = model?.load()
        if let error = error, errorContainsErrorCode(error: error) {
            throw error
        }

        error = YSKPhraseSpotter.setModel(model)
        if let error = error, errorContainsErrorCode(error: error) {
            throw error
        }

        error = YSKPhraseSpotter.start()
        if let error = error, errorContainsErrorCode(error: error) {
            throw error
        }

        YSKPhraseSpotter.setDelegate(self)
    }

    private func errorContainsErrorCode(error: Error) -> Bool {
        // If error code is equal to kYSKErrorOk, there is no error.
        return error._code != 0;
    }

    private func showAlert(error: Error) {
        let failAlert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        failAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(failAlert, animated: true, completion: nil)
    }

    //MARK :- YSKPhraseSpotterDelegate

    func phraseSpotterDidStarted() {
        // Use this callback for your own purpose.
    }

    func phraseSpotterDidStopped() {
        // Use this callback for your own purpose.
    }

    func phraseSpotterDidSpotPhrase(_ phrase: String!, with phraseIndex: Int32) {
        // Make an action when PhraseSpotter spotted the phrase.
        NSLog("[PhraseStopperSample] YSKPhraseSpotterViewController<%p> -phraseSpotterDidSpotPhrase:%@ withIndex:%d", self, phrase, phraseIndex);

        let message = "\"" + phrase.replacingOccurrences(of: "_", with: " ") + "\""
        let alertController = UIAlertController(title: "Your message is", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel) { [unowned self] alert in
            self.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func phraseSpotterDidFailWithError(_ error: Error!) {
        showAlert(error: error)
    }
}
