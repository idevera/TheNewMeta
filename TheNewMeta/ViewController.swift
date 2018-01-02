//
//  ViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

var gamerTag = ""
var email = ""
var password = ""

class ViewController: UIViewController {
    
    @IBOutlet weak var gamerTagField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pwField: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        gamerTag = gamerTagField.text!
        email = emailField.text!
        password = pwField.text!
        print ("\(gamerTag) \(email) \(password)")
    }
    
    // Call all functions here upon the load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        addUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addUser() {
        let user = User()
        
        user.gamerTag = ""
        user.email = emailField.text!
        user.password = pwField.text!
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(user)
            print("Added \(user.gamerTag) User Object to Realm")
        }
    }

}


// Steps to create a user
// Create a new user if the email already exists. Else, login the user and do not make a new account
