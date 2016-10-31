//
//  YSKVocalizerViewController.swift
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

class YSKVocalizerViewController: UIViewController, YSKVocalizerDelegate {

    private var vocalizer: YSKVocalizer?
    private var vocalizerLanguage: String!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var processStateLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!

    init(language: String) {
        super.init(nibName: nil, bundle: nil)
        vocalizerLanguage = language
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK :- UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Vocalizer Sample";

        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShowNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHideNotification(notification:)), name: .UIKeyboardWillHide, object: nil)

        let tapRecognizer = UITapGestureRecognizer(target: textView, action: #selector(resignFirstResponder))
        let swipeRecognizer = UISwipeGestureRecognizer(target: textView, action: #selector(resignFirstResponder))
        swipeRecognizer.direction = .down

        view.addGestureRecognizer(tapRecognizer)
        view.addGestureRecognizer(swipeRecognizer)
    }

    //MARK :- Actions

    @IBAction func onPlayButtonTap() {
        // Create new YSKVocalizer instance for every request, for more options see YSKVocalizer.h.
        vocalizer = YSKVocalizer(text: textView.text, language: vocalizerLanguage, autoPlay: true, voice: "omazh")
        vocalizer?.delegate = self

        // Start vocalizer.
        vocalizer?.start()

        playButton.isEnabled = false;
    }

    @IBAction func onStopButtonTap() {
        // Stop vocalizer.
        vocalizer?.cancel()
    }

    func onKeyboardWillShowNotification(notification: Notification) {
        let rawFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue;
        let keyboardFrame = view.convert(rawFrame, from: nil)
        let bottomGap = view.frame.size.height - textView.frame.maxY;

        textViewBottomConstraint.constant = keyboardFrame.size.height - bottomGap + 40
        textView.setNeedsUpdateConstraints()
    }

    func onKeyboardWillHideNotification(notification: Notification) {
        textViewBottomConstraint.constant = 20
        textView.setNeedsUpdateConstraints()
    }

    //MARK :- YSKVocalizerDelegate

    func vocalizerDidBeginSynthesis(_ vocalizer: YSKVocalizer!) {
        // Update UI when synthesis was begun.
        processStateLabel.text = "Synthesizing in progress..."
    }

    func vocalizerDidStartPlaying(_ vocalizer: YSKVocalizer!) {
        // Update UI when playing was begun.
        processStateLabel.text = "Playing";
    }

    func vocalizerDidFinishPlaying(_ vocalizer: YSKVocalizer!) {
        // Update UI when playing was finished.
        playButton.isEnabled = true;
        processStateLabel.text = "Put your text here";
        self.vocalizer = nil;
    }

    func vocalizer(_ vocalizer: YSKVocalizer!, didFailWithError error: Error!) {
        let failAlert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        failAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(failAlert, animated: true, completion: nil)

        playButton.isEnabled = true;
    }
}
