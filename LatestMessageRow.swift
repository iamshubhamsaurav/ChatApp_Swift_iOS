//
//  LatestMessageRow.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/21/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit

class LatestMessageRow: UITableViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let latestMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Some dummy message wil go over here in this line Some dummy message wil go over here in this line Some dummy message wil go over here in this line Some dummy message wil go over here in this line"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkText
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(profileImageView)
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, latestMessageLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
