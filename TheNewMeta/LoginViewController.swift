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

}
