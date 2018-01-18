//
//  ViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// Inherits from the UIViewController
class LoginViewController: UIViewController {
    
    var gamerTag = ""
    var email = ""
    var password = ""
    
    // Sign in button function
    @objc func signIn(_ sender: Any) {
        gamerTag = gamerTagView.text!
        email = emailTagView.text!
        password = pwTagView.text!
        
        let realm = try! Realm()

        let matchingUser = realm.objects(User.self).filter("email == '\(email)'").first
        
        if matchingUser != nil {
            print("User was found with a matching email: \(String(describing: matchingUser?.userID))!")
            assignUserID(userID: matchingUser!.userID)
            // TODO: Move onto the next sign in page with a welcome a notification
        } else {
            let savedUserID = createUser()
            assignUserID(userID: savedUserID)
            // TODO: Move onto the next sign in page with a welcome notification that a new user has been created
        }
        // Clear the password text field
        pwTagView.text! = ""
        let tabController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
        
        present(tabController, animated: true, completion: nil)
    }
    
    // Private Functions
    
    // Need to add a arrow function to the declare the type that is being returned. Else it will return as a void function.
    // TODO: Could this be a self method?
    private func createUser() -> String {
        let user = User()

        user.gamerTag = gamerTag
        user.email = email
        user.password = password

        let realm = try! Realm()

        try! realm.write {
            realm.add(user)
            print("After the adding of a new user")
            print("Added new gamerTag: \(user.gamerTag) \(user.userID) User Object to Realm")
        }
        return user.userID
    }
    
    private func assignUserID(userID: String) {
        UserDefaults.standard.set(userID, forKey: "userID")
        UserDefaults.standard.synchronize()
    }
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // TODO: Decide if I want to use this
//    override func viewDidLayoutSubviews() {
//        self.gamerTagField.underlined(borderColor: UIColor.white)
//        self.emailField.underlined(borderColor: UIColor.white)
//        self.pwField.underlined(borderColor: UIColor.white)
//        self.loginButton.loginStyle()
//    }
    
    // Create Views
    
    // Add a closure for the imageview - Anonymous functions
    let joystickImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "joystick"))
        // This enables autoLayout for our imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // This forces the image to keep the same aspect ratio regardless of screen orientation or size
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Handle form label
    let appTitleView: UITextView = {
        let textView = UITextView()
        textView.text = "the new meta"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont(name: "Arial", size: 18)
        return textView
    }()
    
    let gamerTagView: UITextField = {
        let gamerTag = UITextField()
        gamerTag.translatesAutoresizingMaskIntoConstraints = false
        gamerTag.backgroundColor = .white
        gamerTag.layer.cornerRadius = 10
        gamerTag.textAlignment = .center
        gamerTag.placeholder = "handle"
        return gamerTag
    }()
    
    let emailTagView: UITextField = {
        let emailView = UITextField()
        emailView.translatesAutoresizingMaskIntoConstraints = false
        emailView.backgroundColor = .white
        emailView.layer.cornerRadius = 10
        emailView.textAlignment = .center
        emailView.placeholder = "email"
        return emailView
    }()
    
    let pwTagView: UITextField = {
        let pwView = UITextField()
        pwView.translatesAutoresizingMaskIntoConstraints = false
        pwView.backgroundColor = .white
        pwView.layer.cornerRadius = 10
        pwView.textAlignment = .center
        pwView.placeholder = "password"
        return pwView
    }()
    
    let loginButtonView: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .yellow
        loginButton.layer.cornerRadius = 10
        return loginButton
    }()
    
    @objc private func setupLayout() {
        // Add container which controls the top half of the screen
        let topImageContainerView = UIView()
        // Uncomment if you want to see what it looks like
        topImageContainerView.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)
        // Add container to the view
        view.addSubview(topImageContainerView)
        // This enables autolayout for our imageView
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        // Makes it 50% of the views size
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        // Attaches to the top of the view
        topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        // Instead of left and right anchor we use leading and trailing anchor.
        // It does the same thing. Video explains why we prefer it (convention)
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Add the image to the container
        topImageContainerView.addSubview(joystickImageView)
        
        // Joystick constraints
        joystickImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        joystickImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        joystickImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        // Title
        
        topImageContainerView.addSubview(appTitleView)
        appTitleView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        appTitleView.centerYAnchor.constraint(equalTo: joystickImageView.bottomAnchor, constant: 20).isActive = true
    
        // Add Bottom View
        
        let bottomViewContainer = UIView()
        // Uncomment if you want to see what it looks like
        bottomViewContainer.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)
        // Add container to the view
        view.addSubview(bottomViewContainer)
        
        bottomViewContainer.translatesAutoresizingMaskIntoConstraints = false
        // Makes it 50% of the views size
        bottomViewContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        bottomViewContainer.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        // Instead of left and right anchor we use leading and trailing anchor.
        // It does the same thing. Video explains why we prefer it (convention)
        bottomViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomViewContainer.addSubview(gamerTagView)
        bottomViewContainer.addSubview(emailTagView)
        bottomViewContainer.addSubview(pwTagView)
        bottomViewContainer.addSubview(loginButtonView)
        
        // GamerTagView
        
        gamerTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        gamerTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        gamerTagView.topAnchor.constraint(equalTo: bottomViewContainer.topAnchor, constant: 20).isActive = true
        
        // Email View
        
        emailTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        emailTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        emailTagView.topAnchor.constraint(equalTo: gamerTagView.bottomAnchor, constant: 20).isActive = true
        
        // PW View
        
        pwTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        pwTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        pwTagView.topAnchor.constraint(equalTo: emailTagView.bottomAnchor, constant: 20).isActive = true
        
        // Login Button
        
        loginButtonView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        loginButtonView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        loginButtonView.topAnchor.constraint(equalTo: pwTagView.bottomAnchor, constant: 40).isActive = true
        loginButtonView.setTitle("Login", for: .normal)
        loginButtonView.setTitleColor(UIColor.darkGray, for: .normal)
        loginButtonView.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
}