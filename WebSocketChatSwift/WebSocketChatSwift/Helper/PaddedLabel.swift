//
//  PaddedLabel.swift
//  TextSpeechDemo
//
//  Created by Jaini on 13/02/24.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    // UIEdgeInsets to define the padding
    var padding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        return CGSize(width: contentSize.width + padding.left + padding.right,
                      height: contentSize.height + padding.top + padding.bottom)
    }
}
