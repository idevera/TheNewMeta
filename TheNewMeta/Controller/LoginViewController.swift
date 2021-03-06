//
//  ViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift
//import Lottie // Not actively used at this point https://airbnb.design/lottie/
//import RxSwift // Not actively used at this point https://github.com/ReactiveX/RxSwift
import Hue // Created by https://www.hyper.no/

// Inherits from the UIViewController
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // Properties
    
    var gamerTag = ""
    var email = ""
    var password = ""
    lazy var gradient: CAGradientLayer = [
        UIColor(hex: "#FD4340"),
        UIColor(hex: "#CE2BAE")
        ].gradient { gradient in
            gradient.speed = 1
            gradient.timeOffset = 1
            return gradient
    }

    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradient)
        setupLayout()
        self.emailTagView.delegate = self
        self.pwTagView.delegate = self
        self.gamerTagView.delegate = self
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.gradient.frame = self.view.bounds
    }
    
    // Keyboard returns after editing the text field
    
    func textFieldShouldReturn( _ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Private Functions
    
    // Sign in button function
    @objc private func signIn(_ sender: Any) {
        if checkInputs() {
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
    }
    
    private func checkInputs() -> Bool {
        if gamerTagView.text == "" || emailTagView.text == "" || pwTagView.text == "" {
            failAlert()
            return false
        }
        return true
    }
    
    // Need to add a arrow function to the declare the type that is being returned. Else it will return as a void function.
    private func createUser() -> String {
        let user = User()
        
        print("This is the user's gamer tag in the login view controller:", user.gamerTag)
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
    
    private func failAlert() {
        let alert = UIAlertController(title: "Try again", message: "Your fields cannot be blank", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Create Views
    
    // Add a closure for the imageview - Anonymous functions
    let joystickImageView: UIImageView = {
        
        // Icon made by [https://www.flaticon.com/packs/linear-game-design-elements] from www.flaticon.com
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "manipulator (1)"))
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
        textView.textColor = .black
        textView.font = UIFont(name: "Helvetica Neue", size: 32)
        textView.font = UIFont.boldSystemFont(ofSize: 24.0)
        return textView
    }()
    
    let gamerTagView: UITextField = {
        let gamerTag = UITextField()
        gamerTag.translatesAutoresizingMaskIntoConstraints = false
        gamerTag.backgroundColor = .white
        gamerTag.layer.cornerRadius = 5
        gamerTag.textAlignment = .center
        gamerTag.placeholder = "Handle"
        gamerTag.autocapitalizationType = .none
        return gamerTag
    }()
    
    let emailTagView: UITextField = {
        let emailView = UITextField()
        emailView.translatesAutoresizingMaskIntoConstraints = false
        emailView.backgroundColor = .white
        emailView.layer.cornerRadius = 5
        emailView.textAlignment = .center
        emailView.placeholder = "Email"
        emailView.autocapitalizationType = .none
        return emailView
    }()
    
    let pwTagView: UITextField = {
        let pwView = UITextField()
        pwView.translatesAutoresizingMaskIntoConstraints = false
        pwView.backgroundColor = .white
        pwView.layer.cornerRadius = 5
        pwView.textAlignment = .center
        pwView.isSecureTextEntry = true
        pwView.placeholder = "Password"
        pwView.autocapitalizationType = .none
        return pwView
    }()
    
    let loginButtonView: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(hex: "#404E5C")
        loginButton.setTitle("LOGIN", for: .normal)
        // TODO: Need to change main font type
        loginButton.layer.cornerRadius = 1
        return loginButton
    }()
    
    @objc private func setupLayout() {
        // Add container which controls the top half of the screen
        let topImageContainerView = UIView()
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
        
        // Joystick constraints
        
        topImageContainerView.addSubview(joystickImageView)
        joystickImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        joystickImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor, constant: 20).isActive = true
        joystickImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        // Title
        
        topImageContainerView.addSubview(appTitleView)
        appTitleView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        appTitleView.centerYAnchor.constraint(equalTo: joystickImageView.bottomAnchor, constant: 30).isActive = true
    
        // Add Bottom View
        
        let bottomViewContainer = UIView()
        // Uncomment if you want to see what it looks like

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
        gamerTagView.heightAnchor.constraint(equalTo: emailTagView.heightAnchor).isActive = true

        // Email View
        
        emailTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        emailTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        emailTagView.topAnchor.constraint(equalTo: gamerTagView.bottomAnchor, constant: 20).isActive = true
        gamerTagView.heightAnchor.constraint(equalTo: pwTagView.heightAnchor).isActive = true
        
        // PW View
        
        pwTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        pwTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        pwTagView.topAnchor.constraint(equalTo: emailTagView.bottomAnchor, constant: 20).isActive = true
        pwTagView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        // Login Button
        
        loginButtonView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
        loginButtonView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
        loginButtonView.topAnchor.constraint(equalTo: pwTagView.bottomAnchor, constant: 40).isActive = true
        loginButtonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        loginButtonView.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
}

// TODO: This is a custom underline styling that we could use at a later time
//    override func viewDidLayoutSubviews() {
//        self.gamerTagView.underlined(borderColor: .black)
//        self.emailTagView.underlined(borderColor: .black)
//        self.pwTagView.underlined(borderColor: .black)
////        self.loginButtonView.loginStyle()
//    }
