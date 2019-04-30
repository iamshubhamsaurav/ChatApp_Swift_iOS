//
//  ChatMessageRow.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/21/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//


import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var fromUser: User? 
    
    var chatMessage: ChatMessage! {
    
        didSet {
            
            if fromUser?.uid == chatMessage.fromId {
                bubbleBackgroundView.backgroundColor = .gray
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                bubbleBackgroundView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                trailingConstraint.isActive = true
                leadingConstraint.isActive = false
            }
            
            messageLabel.text = chatMessage.text
            
            
        }
    }
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = 12
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                           messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                           messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                           
                           bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
                           bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
                           bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
                           bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
                           ]
        NSLayoutConstraint.activate(constraints)
        
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

