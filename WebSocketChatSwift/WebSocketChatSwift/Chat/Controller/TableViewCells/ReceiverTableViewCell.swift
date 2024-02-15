//
//  ReceiverTableViewCell.swift
//  TextSpeechDemo
//
//  Created by Jaini on 14/02/24.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: PaddedLabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 10.0
        messageLabel.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func messageConfiguration(model: MessageDataModel) {
        guard !model.message.isEmpty else {
            return
        }
        messageLabel.text = model.message
        dateTimeLabel.text = model.dateTime
    }
}
