//
//  WebSocketManager.swift
//  TextSpeechDemo
//
//  Created by Jaini on 12/02/24.
//

import Foundation
final class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?

    func connect() {
        let baseURL = "wss://socketsbay.com/wss/v2/1/demo/"
        //wss://ws.postman-echo.com/raw/
        //wss://socketsbay.com/wss/v2/1/demo/
        //.replacingOccurrences(of: "https", with: "wss")
        guard let url = URL(string: "\(baseURL)") else { return }
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessages()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }

    func sendMessage(_ message: String) {
        print("message to send:", message)
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }

    private func receiveMessages() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received message: \(text)")
                    let model = MessageDataModel(message: text, dateTime: CommonMethods.getCurrentDateTime())
                    ChatViewModel.receiverStream.send(model)
                case .data(let data):
                    print("Received data: \(data)")
                default:
                    fatalError()
                }
                self.receiveMessages() // Continue receiving messages
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(String(describing: reason))")
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if let error = error {
            print("Error urlSession: \(error.localizedDescription)")
        }
    }
}
