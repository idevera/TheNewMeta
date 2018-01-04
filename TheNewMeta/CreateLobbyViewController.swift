//
//  CreateLoginViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// Set global variables?

class CreateLobbyViewController: UIViewController, UITextFieldDelegate {
    // Outlets
    
    @IBOutlet weak var gameTagField: UITextField!
    @IBOutlet weak var numberOfPlayersField: UITextField!
    @IBOutlet weak var messageTagField: UITextField!

    // Actions

    @IBAction func createLobby(_ sender: UIButton) {
        // Create a lobby instance
        let lobby = Lobby()
        
        lobby.game = gameTagField.text!
        let num: Int? = Int(numberOfPlayersField.text!)
        lobby.numberOfPlayers = num!
        lobby.message = messageTagField.text!
        
        // Perform the migration?
        let realm = try! Realm()
        
        // Write to the database
        try! realm.write {
            realm.add(lobby)
            navigationController?.popToRootViewController(animated: true)
            print("Added \(lobby.game) \(lobby.message) \(lobby.hostID) \(lobby.numberOfPlayers) User Object to Realm")
        }
    }
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
