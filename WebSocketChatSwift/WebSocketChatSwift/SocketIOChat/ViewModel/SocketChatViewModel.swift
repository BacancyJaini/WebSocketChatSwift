//
//  SocketChatViewModel.swift
//  WebSocketChatSwift
//
//  Created by Jaini on 16/02/24.
//

import Foundation
import Combine

final class SocketChatViewModel {
    let socketManager: SocketIOManager?
    @Published var messageDataModel = [MessageDataModel]()
    static var receiverStream = PassthroughSubject<MessageDataModel, Never>()
    private var cancellable: AnyCancellable?
    var message = ""

    init(socketManager: SocketIOManager?) {
        self.socketManager = socketManager

        cancellable = ChatViewModel.receiverStream
            .sink(receiveValue: { [weak self] data in
                guard let self else { return }
                messageDataModel.append(data)
            })

        receiveMessage()
    }

    func connect() {
        socketManager?.connect()
        socketManager?.joinChatRoom(nickname: "ja", completion: {
            print("inside join chat room")
        })
    }

    func sendMessage() {
        guard !message.isEmpty else { return }
        socketManager?.sendMessage(message)
        messageDataModel.append(MessageDataModel(isFromReceiver: false, message: message, dateTime: CommonMethods.getCurrentDateTime()))
    }

    private func receiveMessage() {
        socketManager?.receiveMessages()
    }

    func disConnect() {
        socketManager?.disconnect()
    }
}
