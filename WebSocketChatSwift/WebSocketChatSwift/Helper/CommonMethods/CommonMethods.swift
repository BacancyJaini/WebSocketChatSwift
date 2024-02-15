//
//  CommonMethods.swift
//  TextSpeechDemo
//
//  Created by Jaini on 15/02/24.
//

import Foundation
final class CommonMethods {
    static func getCurrentDateTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let dateTimeString = dateFormatter.string(from: currentDate)
        return dateTimeString
    }
}
