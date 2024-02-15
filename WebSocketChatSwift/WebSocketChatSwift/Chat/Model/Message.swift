//
//  Message.swift
//  TextSpeechDemo
//
//  Created by Jaini on 13/02/24.
//

import Foundation
struct MessageDataModel {
    let isFromReceiver: Bool
    let message: String
    let dateTime: String

    init(isFromReceiver: Bool = true, message: String, dateTime: String) {
        self.isFromReceiver = isFromReceiver
        self.message = message
        self.dateTime = dateTime
    }
}
