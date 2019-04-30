//
//  User.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/20/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}
