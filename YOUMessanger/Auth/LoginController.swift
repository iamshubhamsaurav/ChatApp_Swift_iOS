//
//  LoginController.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/19/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0.90, alpha: 1)
        tf.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0.90, alpha: 1)
        tf.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    @objc fileprivate func handleTextField() {
        let isFormValid = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to login user", error)
                return
            }
            
            print("Successfully logged in user using UID: ", user?.user.uid ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have account?", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkText, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        attributedTitle.append(NSAttributedString(string: " Signup now", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 149, green: 204, blue: 244)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleDontHaveAccount() {
        let signupController = SignupController()
        present(signupController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFields()
    }
    
    fileprivate func setupTextFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, dontHaveAccountButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
//        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
//        view.addSubview(dontHaveAccountButton)
//        dontHaveAccountButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
//        dontHaveAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
//        dontHaveAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
//        dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
