//
//  ChatLogController.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/20/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

struct ChatMessage {
    let id: String
    let text: String
    let fromId: String
    let toId: String
    let timestamp: Double = 0
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
//        self.timestamp = dictionary as? Double ?? 0
    }
    
}

class ChatLogController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let chatLogTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add new message"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleSendMessage() {
        guard let messageText = messageTextField.text else {return}
        if messageText.isEmpty {
            return
        }
        guard let toId = user?.uid else {return}
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        let id = NSUUID().uuidString
        
        let fromRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(id)
        let toRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(id)
        
        let values = ["fromId": fromId, "id": id, "text": messageText, "timestamp": Date().timeIntervalSince1970, "toId": toId] as [String: Any]
        fromRef.updateChildValues(values)
        toRef.updateChildValues(values)
        
        let latestMessageFromRef = Database.database().reference().child("latest-messages").child(fromId).child(toId).child(id)
        latestMessageFromRef.updateChildValues(values)
        let latestMessageToRef = Database.database().reference().child("latest-messages").child(toId).child(fromId).child(id)
        latestMessageToRef.updateChildValues(values)
        print("Successfully saved message into DB")
        messageTextField.text = ""
    }
    
    var chatMesages = [ChatMessage]()
    
    let cellId = "cellid"
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.username
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatLogTableView.dataSource = self
        chatLogTableView.delegate = self
        chatLogTableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        view.backgroundColor = .white
        chatLogTableView.tableFooterView = UIView()
        chatLogTableView.separatorStyle = .none
        setupUI()
        listenForMessages()
    }
    
    fileprivate func listenForMessages() {
        
        guard let toId = user?.uid else {return}
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        
        
        let fromRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
        fromRef.observe(.childAdded , with: { (snapshot) in
//            print(snapshot.value)
            guard let chatDictionary = snapshot.value as? [String: Any] else {return}
            let chatMessage = ChatMessage(dictionary: chatDictionary)
            print(chatDictionary)
            self.chatMesages.append(chatMessage)
            DispatchQueue.main.async {
                self.chatLogTableView.reloadData()
            }
        }) { (error) in
            print("Failed to fetch messages: ", error)
        }
        
    }
    
    fileprivate func setupUI() {
        view.addSubview(sendMessageButton)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        sendMessageButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(messageTextField)
        messageTextField.topAnchor.constraint(equalTo: sendMessageButton.topAnchor).isActive = true
        messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: sendMessageButton.bottomAnchor).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: 10).isActive = true
        
        
        view.addSubview(chatLogTableView)
        chatLogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        chatLogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatLogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chatLogTableView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMesages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let chatMessage = chatMesages[indexPath.row]
        cell.fromUser = user
        cell.chatMessage = chatMessage
        return cell
    }
    
    
}
