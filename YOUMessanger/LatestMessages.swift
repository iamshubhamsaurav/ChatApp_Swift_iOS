//
//  LatestMessages.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/19/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

class LatestMessages: UITableViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                self.present(loginController, animated: true, completion: nil)
            }
        }
        
        navigationItem.title = "Latest Messages"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleAddNewMessage))
        tableView.backgroundColor = .red
        tableView.tableFooterView = UIView()
        tableView.register(LatestMessageRow.self, forCellReuseIdentifier: cellId)
    }
    
    @objc fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
            print("Successfully logged out")
            let loginController = LoginController()
            present(loginController, animated: true, completion: nil)
            
        } catch let error {
            print("cannot Log out: due to : ", error)
        }
            
    }
    
    @objc fileprivate func handleAddNewMessage() {
        let newMessage = NewMessage()
        navigationController?.pushViewController(newMessage, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LatestMessageRow
//        cell.textLabel?.text = "TEXT TEXT TEXT"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
