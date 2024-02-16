//
//  SocketIOManager.swift
//  WebSocketChatSwift
//
//  Created by Jaini on 15/02/24.
//

import Foundation
import SocketIO
import UIKit

//https://test-rn-social-sockets.herokuapp.com
//192.168.1.91:3001

let kHost = "http://192.168.1.91:3001"
let kConnectUser = "connectUser"
let kUserList = "userList"
let kExitUser = "exitUser"

final class SocketIOManager: NSObject {
    static let shared = SocketIOManager()

    private var manager: SocketManager?
    private var socket: SocketIOClient?

    override init() {
        super.init()
        configureSocket()
    }

    private func configureSocket() {
        guard let url = URL(string: kHost) else {
            return
        }

        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .forceWebsockets(true)])

        guard let manager = manager else {
            return
        }

        socket = manager.defaultSocket
        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
    }

    func connect() {
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendMessage(_ message: String) {
        print("message to send:", message)
        socket?.emit("chatmessage", message)
    }

    func receiveMessages() {
        socket?.on("new message") { data, ack in
            if let message = data.first as? String {
                print("New message received: \(message)")
                let model = MessageDataModel(message: message, dateTime: CommonMethods.getCurrentDateTime())
                ChatViewModel.receiverStream.send(model)
            }
        }
    }

    func joinChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.emit(kConnectUser, nickname)
        completion()
    }

    func leaveChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else{
            return
        }
        socket.emit(kExitUser, nickname)
        completion()
    }

    /*func participantList(completion: @escaping (_ userList: [User]?) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on(kUserList) { [weak self] (result, ack) -> Void in
            guard result.count > 0,
                let _ = self,
                let user = result.first as? [[String: Any]],
                let data = UIApplication.jsonData(from: user) else {
                    return
            }
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completion(userModel)

            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }*/
}
