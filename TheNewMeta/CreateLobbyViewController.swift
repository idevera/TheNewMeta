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
        
        // It’s worth noting here that these getters will return optional values, so the type of name is String?. When the "name" key doesn’t exist, the code returns nil. It then makes sense to use optional binding to get the value safely:
        if let id = UserDefaults.standard.string(forKey: "userID") {
            lobby.hostID = id
        } // OPTIONAL: Write an exception here if have time
        
        lobby.game = gameTagField.text!
        
        let num: Int? = Int(numberOfPlayersField.text!)
        
        lobby.numberOfPlayers = num!
        
        lobby.message = messageTagField.text!
        
        saveObject(object: lobby)
        
        navigationController?.popToRootViewController(animated: true)
        print("Added Game: \(lobby.game) Message: \(lobby.message) HostID: \(lobby.hostID) Number of Players: \(lobby.numberOfPlayers) Lobby Object to Realm DB")
//        }
    }
    
    private func saveObject(object: Object) {
        // Perform the migration?
        let realm = try! Realm()
        
        // Write to the database
        try! realm.write {
            realm.add(object)
        }
    }

    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
