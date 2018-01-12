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
    
    private var signedInUser = User()
    
    // Outlets
    
    @IBOutlet weak var gameTagField: UITextField!
    @IBOutlet weak var numberOfPlayersField: UITextField!
    @IBOutlet weak var messageTagField: UITextField!

    // Actions

    @IBAction func createLobby(_ sender: UIButton) {
        // This game is either a new created game OR an existing game
        let game = getGame(gameTitle: gameTagField.text!)
        let newLobby = createNewLobby()
        
        // Perform the migration
        let realm = try! Realm()
        
        // Write to the database
        try! realm.write {
            realm.add(game!)
            realm.add(newLobby)
            
            // Add the newlobby to the game instance
            // This should automatically update the newLobby.game property of a lobby
            game!.matchingLobbies.append(newLobby)
            newLobby.lobbyUsers.append(signedInUser)
//            print("Sucessfully added your game: \(String(describing: game))")
//            print("Sucessfully added your new lobby: \(newLobby.game)")
        }
            // OPTIONAL: Add exception if the object was saved

//        navigationController?.popToRootViewController(animated: true)
    }
    
    // 3
    private func createNewLobby() -> Lobby {
        let lobby = Lobby()
        
        let num: Int? = Int(numberOfPlayersField.text!)
        lobby.numberOfPlayers = num!
        lobby.message = messageTagField.text!
        
        // It’s worth noting here that these getters will return optional values, so the type of name is String?. When the "name" key doesn’t exist, the code returns nil. It then makes sense to use optional binding to get the value safely:
        if let id = UserDefaults.standard.string(forKey: "userID") {
            lobby.hostID = id
        // print("Lobby ID successfully saved for logged in user: \(lobby.hostID)")
        }
        return lobby
    }
    
    private func getGame(gameTitle: String) -> Game? {
        let realm = try! Realm()
        let returnedGame = realm.objects(Game.self).filter("title = '\(gameTitle)'").first
        
        // print("This is the number of matching games by title: \(returnedGame)")
        if returnedGame != nil {
            return returnedGame
        } else {
            return createGame()
        }
    }
    
    private func createGame() -> Game {
        let newGame = Game()
        newGame.title = gameTagField.text!
        return newGame
    }
    
    private func findSignedInUser() {
        // TODO: Should probably save the entire user object in the UserDefaults instead of just the ID
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        print("This is the id of the signed in user \(String(describing: id))")
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        
        print("Found signed in user: \(String(describing: signedInUser))")
    }

    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findSignedInUser()
    }
}
