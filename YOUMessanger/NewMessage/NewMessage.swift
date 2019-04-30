//
//  NewMessage.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/19/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

class NewMessage: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Message"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(NewMessageRow.self, forCellReuseIdentifier: cellId)
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            dictionary.forEach({ (key, value) in
                print(value)
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(dictionary: userDictionary)
                self.users.append(user)
                print("######## ", user.username)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }) { (error) in
            print("Failed to fetch users: ", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewMessageRow
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatLogController = ChatLogController()
        chatLogController.user = users[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}
