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

//extension UINavigationBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.size.width, height: 80.0)
//    }
//}

class CreateLobbyViewController: UIViewController, UITextFieldDelegate {
    
    private var signedInUser = User()
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        findSignedInUser()
        self.gameFieldView.delegate = self
        self.playersFieldView.delegate = self
        self.msgFieldView.delegate = self
        self.title = "Create Lobby"
    }
    
    // Actions
    
    @objc func createLobby(_ sender: UIButton) {
        if checkInputs() {
            // This game is either a new created game OR an existing game
            let game = getGame(gameTitle: gameFieldView.text!)
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
                signedInUser.createdLobbies.append(newLobby)
                print("This is my signed in useres created lobbies: \(signedInUser.joinedLobbies)")
                successCreationAlert()
                // TODO: Segue into the main view controller
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func checkInputs() -> Bool {
        if gameFieldView.text == "" || playersFieldView.text == "" || msgFieldView.text == "" {
            failAlert()
            return false
        }
        return true
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
        newGame.title = gameFieldView.text!
        return newGame
    }
    
    private func createNewLobby() -> Lobby {
        let lobby = Lobby()
        
        let num: Int? = Int(playersFieldView.text!)
        lobby.numberOfPlayers = num!
        lobby.message = msgFieldView.text!
        
        // It’s worth noting here that these getters will return optional values, so the type of name is String?. When the "name" key doesn’t exist, the code returns nil. It then makes sense to use optional binding to get the value safely:
        if let id = UserDefaults.standard.string(forKey: "userID") {
            lobby.hostID = id
            // print("Lobby ID successfully saved for logged in user: \(lobby.hostID)")
        }
        return lobby
    }
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        print("This is the id of the signed in user \(String(describing: id))")
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
    // Alerts
    
    private func failAlert() {
        let alert = UIAlertController(title: "Try again", message: "Your fields cannot be blank", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func successCreationAlert() {
        let alert = UIAlertController(title: "Lobby Successfully Created", message: "See your profile for all your currently hosted lobbies", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Views and Constraints
    
    let gameFieldView: UITextField = {
        let gameField = UITextField()
        gameField.translatesAutoresizingMaskIntoConstraints = false
        gameField.backgroundColor = .white
        gameField.layer.cornerRadius = 5
        gameField.textAlignment = .center
        gameField.placeholder = "Enter the name of your game"
        return gameField
    }()
    
    let playersFieldView: UITextField = {
        let playersField = UITextField()
        playersField.translatesAutoresizingMaskIntoConstraints = false
        playersField.backgroundColor = .white
        playersField.layer.cornerRadius = 5
        playersField.textAlignment = .center
        playersField.placeholder = "Please enter the number of players"
        return playersField
    }()
    
    let msgFieldView: UITextField = {
        let msgField = UITextField()
        msgField.translatesAutoresizingMaskIntoConstraints = false
        msgField.backgroundColor = .white
        msgField.layer.cornerRadius = 5
        msgField.textAlignment = .center
        msgField.placeholder = "Add a message to your challengers!"
        return msgField
    }()
    
    let submitButtonView: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .yellow
        submitButton.layer.cornerRadius = 1
        submitButton.setTitle("Create Lobby", for: .normal)
        submitButton.setTitleColor(UIColor.darkGray, for: .normal)
        submitButton.addTarget(self, action: #selector(createLobby(_:)), for: .touchUpInside)
        return submitButton
    }()
    
//    let searchBarView: UISearchBar = {
//        let sb = UISearchBar()
//        return sb
//    }()
// TEST
////    let navBarView: UINavigationBar = {
////        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.width, height:  64))
////        navBar.translatesAutoresizingMaskIntoConstraints = false
////        return navBar
////    }()
////
////    let searchBarView: UISearchBar = {
////        let sb = UISearchBar()
////    }()
//
//
////    let navBarView: UINavigationBar = {
////        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: guide, height:  64))
////        navBar.translatesAutoresizingMaskIntoConstraints = false
////        return navBar
////    }()
////    // TEST
//
//    let navBarView: UINavigationBar = UINavigationBar()
////    let navItem = UINavigationItem(title: "SomeTitle");
////    //        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: "selector");
////    //        navItem.rightBarButtonItem = doneItem;
////    navBar.setItems([navItem], animated: false);

//// TEST

    
    private func setupLayout() {
        view.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)
        
        view.addSubview(playersFieldView)
        view.addSubview(gameFieldView)
        view.addSubview(msgFieldView)
//        view.addSubview(searchBarView)
        
//        searchBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        searchBarView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        searchBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        searchBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

//        view.addSubview(navBarView)

        playersFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playersFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        playersFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        gameFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameFieldView.bottomAnchor.constraint(equalTo: playersFieldView.topAnchor, constant: -20).isActive = true
        gameFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        gameFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        msgFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        msgFieldView.topAnchor.constraint(equalTo: playersFieldView.bottomAnchor, constant: 20).isActive = true
        msgFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        msgFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        view.addSubview(submitButtonView)
        submitButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButtonView.topAnchor.constraint(equalTo: msgFieldView.bottomAnchor, constant: 20).isActive = true
        submitButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        submitButtonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
}

