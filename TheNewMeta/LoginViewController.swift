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
    
    @IBOutlet weak var gamerTagField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Sign in button function
    @IBAction func signIn(_ sender: Any) {
        gamerTag = gamerTagField.text!
        email = emailField.text!
        password = pwField.text!
        
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
        pwField.text! = ""
        let tabController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
        
        present(tabController, animated: true, completion: nil)
    }
    
    // Private Functions
    
    // Need to add a arrow function to the declare the type that is being returned. Else it will return as a void function.
    // TODO: Could this be a self method?
    private func createUser() -> String {
        let user = User()

        user.gamerTag = gamerTagField.text!
        user.email = emailField.text!
        user.password = pwField.text!

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
        
//        view.addSubview(appTextView)
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
//        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.gamerTagField.underlined(borderColor: UIColor.white)
        self.emailField.underlined(borderColor: UIColor.white)
        self.pwField.underlined(borderColor: UIColor.white)
        self.loginButton.loginStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Styling
    
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
        return textView
    }()
    
    let gamerTagView: UITextField = {
        let gamerTag = UITextField()
         gamerTag.translatesAutoresizingMaskIntoConstraints = false
        return gamerTag
    }()
    
    private func setupLayout() {
        // Add container which controls the top half of the screen
        let topImageContainerView = UIView()
        // Uncomment if you want to see what it looks like
        topImageContainerView.backgroundColor = .blue
        // Add container to the view
        view.addSubview(topImageContainerView)
        // This enables autolayout for our imageView
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        // Makes it 50% of the views size
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        // Attaches to the top of the view
        topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        // Instead of left and right anchor we use leading and trailing anchor.
        // It does the same thing. Video explains why we prefer it (convention)
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // Add the image to the container
        topImageContainerView.addSubview(joystickImageView)
        
        // Joystick constraints
        joystickImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        joystickImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor, constant: 20).isActive = true
        joystickImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        // Test
        
        topImageContainerView.addSubview(appTitleView)
        appTitleView.topAnchor.constraint(equalTo: joystickImageView.bottomAnchor, constant: 8).isActive = true
        appTitleView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        appTitleView.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
//        handleTextView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor, constant: 20).isActive = true


        
        // Handle text label constraints
//        handleTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
//        handleTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        handleTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        handleTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Text Field Constraints
//        gamerTagView.centerXAnchor.constraint(equalTo: handleTextView.centerXAnchor).isActive = true
    }
}
