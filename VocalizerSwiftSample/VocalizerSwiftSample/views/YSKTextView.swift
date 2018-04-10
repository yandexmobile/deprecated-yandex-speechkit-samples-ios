//
//  YSKTextView.swift
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

class YSKTextView: UITextView {

    private let dataFormatter = DateFormatter()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    override func awakeFromNib() {
        initialSetup()
    }

    fileprivate func initialSetup() {
        self.backgroundColor = YSKAppearanceSettings.backgroundColor()
        self.font = YSKAppearanceSettings.font(14.0)

        self.layer.borderWidth = 1/UIScreen.main.scale
        self.layer.borderColor = YSKAppearanceSettings.tintColor().cgColor
        self.layer.cornerRadius = 4.0

        dataFormatter.dateFormat = "HH:mm:ss:SSS"
    }

    func append(text: String) {
        self.text = self.text + "\n" + "[" + dataFormatter.string(from: Date()) + "]" + text
        self.scrollRangeToVisible(NSMakeRange(self.text.count - 1, 1))
    }
}
