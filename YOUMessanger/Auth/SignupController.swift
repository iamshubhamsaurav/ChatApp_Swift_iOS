//
//  SignupController.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/18/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Add Photo button
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    //MARK: Add Photo Button Methods
    @objc fileprivate func handleAddPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let origionalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addPhotoButton.setImage(origionalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        setupCircularImage()
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupCircularImage() {
        addPhotoButton.layer.cornerRadius = 75
        addPhotoButton.layer.borderWidth = 3
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.clipsToBounds = true
    }
    
    // MARK:- TextField
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0.90, alpha: 1)
        tf.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        tf.layer.cornerRadius = 5
        return tf
    }()
    
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
        let isFormValid = usernameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signupButton.isEnabled = true
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccount: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have account?", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkText, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        attributedTitle.append(NSAttributedString(string: " Login now", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 149, green: 204, blue: 244)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleAlreadyHaveAccount() {
        dismiss(animated: true, completion: nil)
    }

    
    
    @objc fileprivate func handleSignUp() {
        guard let email = emailTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("failed to create a user: with error :", error)
                return
            }
            
            print("Successfully saved user with uid: ", user?.user.uid ?? "")
            
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("images").child(fileName)
            guard let image = self.addPhotoButton.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.7) else {return}
//            guard let image = self.plusPhotoButton.imageView?.image else {return}
//            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/jpeg"
            storageRef.putData(uploadData, metadata: metaDataForImage, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to save profile image: ", error)
                    return
                }
                
                print("Successfully saved profile image into storage: ")
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("Failed to download profile image url: ", error)
                        return
                    }
                    
                    print("Successfully downloaded profile image url: ", url?.absoluteString ?? "")
                    guard let profileImageUrl = url?.absoluteString else {return}
                    guard let uid = user?.user.uid else {return}
                    let databaseRef = Database.database().reference().child("users").child(uid)
                    
                    let dictionary = ["profileImageUrl": profileImageUrl,"uid": uid ,"username" : username]
                    databaseRef.updateChildValues(dictionary, withCompletionBlock: { (error, reference) in
                        if let error = error {
                            print("Failed to save user info into the database: ", error)
                            return
                        }
                        print("Successfully saved user info data into the database")
                        self.present(LatestMessages(), animated: true, completion: {
                            self.dismiss(animated: true, completion: nil)
                        })
                        
                    })
                    
                })
            })
            
        }
    }
    
    
    //MARK:- view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.addSubview(addPhotoButton)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        setupTextFields()
    }
    
    fileprivate func setupTextFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, signupButton, alreadyHaveAccount])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
}















