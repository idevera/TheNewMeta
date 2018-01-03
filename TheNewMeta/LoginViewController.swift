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

var gamerTag = ""
var email = ""
var password = ""

// Inherits from the UIViewController
class LoginViewController: UIViewController {
    
    @IBOutlet weak var gamerTagField: UITextField!

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pwField: UITextField!
    
    // Sign in button function
    @IBAction func signIn(_ sender: Any) {
        gamerTag = gamerTagField.text!
        email = emailField.text!
        password = pwField.text!
        
        let realm = try! Realm()

        let matchingUser = realm.objects(User.self).filter("email == email")
        
        if matchingUser.count > 0 {
            print(matchingUser.count)
            // Move onto the next sign in page without a notification
        } else {
            createUser()
            // Move onto the next sign in page with a notification that a new user has been created
        }
    }
    
    func createUser() {
        let user = User()

        user.gamerTag = gamerTagField.text!
        user.email = emailField.text!
        user.password = pwField.text!

        let realm = try! Realm()

        try! realm.write {
            realm.add(user)
            print("Added \(user.gamerTag) User Object to Realm")
        }
    }

    
    // Call all functions here upon the load view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
