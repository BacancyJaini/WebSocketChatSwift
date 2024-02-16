//
//  ViewController.swift
//  WebSocketChatSwift
//
//  Created by Jaini on 15/02/24.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {

    let synthesizer = AVSpeechSynthesizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func listenClick(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: "Transcription permission was declined.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        synthesizer.speak(utterance)
    }

    @IBAction func webSocketChatClick(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func socketChatClick(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SocketChatViewController") as? SocketChatViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

