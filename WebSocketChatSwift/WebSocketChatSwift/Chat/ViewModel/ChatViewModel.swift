//
//  ChatViewModel.swift
//  TextSpeechDemo
//
//  Created by Jaini on 12/02/24.
//

import Foundation
import Combine

final class ChatViewModel {
    let webSocketManager: WebSocketManager?
    @Published var messageDataModel = [MessageDataModel]()
    static var receiverStream = PassthroughSubject<MessageDataModel, Never>()
    private var cancellable: AnyCancellable?
    var message = ""

    init(webSocketManager: WebSocketManager?) {
        self.webSocketManager = webSocketManager

        cancellable = ChatViewModel.receiverStream
            .sink(receiveValue: { [weak self] data in
                guard let self else { return }
                messageDataModel.append(data)
            })
    }

    func connect() {
        webSocketManager?.connect()
    }

    func sendMessage() {
        guard !message.isEmpty else { return }
        webSocketManager?.sendMessage(message)
        messageDataModel.append(MessageDataModel(isFromReceiver: false, message: message, dateTime: CommonMethods.getCurrentDateTime()))
    }

    func disConnect() {
        webSocketManager?.disconnect()
    }
}
