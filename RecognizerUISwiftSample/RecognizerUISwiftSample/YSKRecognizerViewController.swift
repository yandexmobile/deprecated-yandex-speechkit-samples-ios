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

class YSKRecognizerViewController: UIViewController, YSKSpeechRecognitionViewControllerDelegate {

    private var recognizerModel: String!
    private var recognizerLanguage: String!

    @IBOutlet weak var textView: UITextView!

    init(language: String, model: String) {
        super.init(nibName: nil, bundle: nil)
        recognizerLanguage = language
        recognizerModel = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recognizer GUI Sample"
    }

    //MARK :- Actions

    @IBAction func onRecognizerButtonTap() {
        let recognitionController = YSKSpeechRecognitionViewController(language: recognizerLanguage, model: recognizerModel)
        recognitionController?.delegate = self
        present(recognitionController!, animated: true, completion: nil)
    }

    //MARK :- YSKSpeechRecognitionViewControllerDelegate

    func speechRecognitionViewController(_ speechRecognitionViewController: YSKSpeechRecognitionViewController!, didFinishWithResult result: String!) {
        textView.text = result
        dismiss(animated: true, completion: nil)
    }

    func speechRecognitionViewController(_ speechRecognitionViewController: YSKSpeechRecognitionViewController!, didFailWithError error: Error!) {
        let failAlert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        failAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        dismiss(animated: true) { [unowned self] in
            self.present(failAlert, animated: true, completion: nil)
        }
    }

    func speechRecognitionViewController(_ speechRecognitionViewController: YSKSpeechRecognitionViewController!, didChangeLanguage language: String!) {
        // Here you can remember selected language and use it when starting recognition next time.
    }

}
