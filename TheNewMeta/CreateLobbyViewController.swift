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
    
    // 2. Check game title. If it exists, do not create lobby and do not create game. Raise error to the user
    // 3. If the game does not exist, create lobby, create game, save lobby into the gameLobby list
    
    @IBAction func createLobby(_ sender: UIButton) {
        if !checkExistingGame(gameTitle: gameTagField.text!) {
            // Create the game
            let lobby = Lobby()
            let newGame = Game()
            
            newGame.title = gameTagField.text!
            newGame.matchingLobbies.append(lobby)
            
//            lobby.game = newGame
            let num: Int? = Int(numberOfPlayersField.text!)
            lobby.numberOfPlayers = num!
            lobby.message = messageTagField.text!
            
            // It’s worth noting here that these getters will return optional values, so the type of name is String?. When the "name" key doesn’t exist, the code returns nil. It then makes sense to use optional binding to get the value safely:
            if let id = UserDefaults.standard.string(forKey: "userID") {
                lobby.hostID = id
                print("Lobby ID successfully saved for logged in user: \(lobby.hostID)")
            } // OPTIONAL: Write an exception here if have time
            saveObject(object: lobby)
            saveObject(object: newGame)
            print("These are my game lobbies collection: \(newGame.matchingLobbies)")
        }
        
        //        newGame.title = gameTagField.text!
        //        print("newGame title is: \(newGame.title)")
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func checkExistingGame(gameTitle: String) -> Bool {
        let realm = try! Realm()
        let returnedGames = realm.objects(Game.self).filter("title = '\(gameTitle)'")
        
        print("This is the number of matching games by title: \(returnedGames)")
        
        if returnedGames.count > 1 {
            print("Cannot create lobby") // TODO: Raise an error
            return true
        } else {
            return false
        }
    }
    
    private func saveObject(object: Object) {
        // Perform the migration?
        let realm = try! Realm()
        
        // Write to the database
        try! realm.write {
            realm.add(object)
            print("Successfully saved your object: \(object)")
        }
        // OPTIONAL: Add exception if the object was saved
    }

    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
