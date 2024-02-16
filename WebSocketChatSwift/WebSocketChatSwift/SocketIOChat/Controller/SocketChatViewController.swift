//
//  SocketChatViewController.swift
//  WebSocketChatSwift
//
//  Created by Jaini on 16/02/24.
//

import UIKit
import Combine

class SocketChatViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var scrollToBottomButton: UIButton!

    @IBOutlet weak var backgroundViewBottomConst: NSLayoutConstraint!

    @IBOutlet weak var messageTextViewHeightConst: NSLayoutConstraint!

    var socketChatViewModel: SocketChatViewModel?
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Welcome"
        scrollToBottomButton.layer.cornerRadius = 10.0
        messageTextView.layer.cornerRadius = 15.0
        messageTextView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 5.0)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        chatTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderTableViewCell")
        chatTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverTableViewCell")

        // Do any additional setup after loading the view.
        socketChatViewModel = SocketChatViewModel(socketManager: SocketIOManager())
        socketChatViewModel?.connect()

        cancellable = socketChatViewModel?.$messageDataModel
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self, !data.isEmpty else { return }
                self.chatTableView.reloadData()
                if !(data.last?.isFromReceiver ?? false) {
                    self.scrollToBottom()
                }
            })
    }

    override func viewDidDisappear(_ animated: Bool) {
        socketChatViewModel?.disConnect()
    }

    private func scrollToBottom() {
        let indexPath = IndexPath(row: (socketChatViewModel?.messageDataModel.count ?? 1) - 1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private func sendMessage() {
        socketChatViewModel?.message = messageTextView.text ?? ""
        socketChatViewModel?.sendMessage()
        messageTextView.text = ""
        messageTextViewHeightConst.constant = 37.0
    }
}

extension SocketChatViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.backgroundViewBottomConst.constant = keyboardSize.height - 25
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundViewBottomConst.constant = 0
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRows = chatTableView.indexPathsForVisibleRows ?? []
        if let lastVisibleIndexPath = visibleRows.last {
            let endOfScroll = lastVisibleIndexPath.row == (socketChatViewModel?.messageDataModel.count ?? 1) - 1
            scrollToBottomButton.isHidden = endOfScroll
        }
    }
}

extension SocketChatViewController {
    @IBAction func sendClick(_ sender: UIButton) {
        sendMessage()
    }

    @IBAction func scrollDownClick(_ sender: UIButton) {
        scrollToBottom()
    }
}

extension SocketChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socketChatViewModel?.messageDataModel.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = socketChatViewModel?.messageDataModel[indexPath.row] {
            if model.isFromReceiver {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as? ReceiverTableViewCell else { return UITableViewCell() }
                cell.messageConfiguration(model: model)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as? SenderTableViewCell else { return UITableViewCell() }
                cell.messageConfiguration(model: model)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension SocketChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendMessage()
            return false
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        messageTextViewHeightConst.constant = newSize.height > 100.0 ? 100.0 : newSize.height
    }
}