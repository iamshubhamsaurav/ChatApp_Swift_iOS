//
//  NewMessageRow.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/19/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

class NewMessageRow: UITableViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let imageString = user?.profileImageUrl else {return}
            guard let imageUrl = URL(string: imageString) else {return}
            
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Failed to download image profile image: ", error)
                    return
                }
                
                guard let imageData = data else {return}
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: imageData)
                    self.setupCircularImage()
                }
            }.resume()
        }
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    fileprivate func setupCircularImage() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.clipsToBounds = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
