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
//        view.backgroundColor = .blue
        setupLayout()
        findSignedInUser()
    }
    
    let gameFieldView: UITextField = {
        let gameField = UITextField()
        gameField.translatesAutoresizingMaskIntoConstraints = false
        gameField.backgroundColor = .white
        gameField.layer.cornerRadius = 10
        gameField.textAlignment = .center
        gameField.placeholder = "Enter the name of your game"
        return gameField
    }()

    let playersFieldView: UITextField = {
        let playersField = UITextField()
        playersField.translatesAutoresizingMaskIntoConstraints = false
        playersField.backgroundColor = .white
        playersField.layer.cornerRadius = 10
        playersField.textAlignment = .center
        playersField.placeholder = "Please enter the number of players"
        return playersField
    }()

    let msgFieldView: UITextField = {
        let msgField = UITextField()
        msgField.translatesAutoresizingMaskIntoConstraints = false
        msgField.backgroundColor = .white
        msgField.layer.cornerRadius = 10
        msgField.textAlignment = .center
        msgField.placeholder = "Add a message to your challengers!"
        return msgField
    }()

    private func setupLayout() {
        view.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)

        view.addSubview(playersFieldView)
        view.addSubview(gameFieldView)
        view.addSubview(msgFieldView)
        
        playersFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playersFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        playersFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        gameFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameFieldView.bottomAnchor.constraint(equalTo: playersFieldView.topAnchor).isActive = true
//        gameFieldView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gameFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        gameFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        msgFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        msgFieldView.topAnchor.constraint(equalTo: playersFieldView.bottomAnchor).isActive = true
//        msgFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        msgFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        msgFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true



//        @IBOutlet weak var gameTagField: UITextField!
//        @IBOutlet weak var numberOfPlayersField: UITextField!
//        @IBOutlet weak var messageTagField: UITextField!

//        view.addSubview(gameFieldView)
//        view.addSubview(playersFieldView)
//        view.addSubview(msgFieldView)

//
//        playersFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        playersFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

//        // Add the image to the container
//        topImageContainerView.addSubview(joystickImageView)
//
//        // Joystick constraints
//        joystickImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
//        joystickImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
//        joystickImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
//
//        // Title
//
//        topImageContainerView.addSubview(appTitleView)
//        appTitleView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
//        appTitleView.centerYAnchor.constraint(equalTo: joystickImageView.bottomAnchor, constant: 20).isActive = true
//
//        // Add Bottom View
//
//        let bottomViewContainer = UIView()
//        // Uncomment if you want to see what it looks like
//        bottomViewContainer.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)
//        // Add container to the view
//        view.addSubview(bottomViewContainer)
//
//        bottomViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        // Makes it 50% of the views size
//        bottomViewContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
//        bottomViewContainer.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
//        // Instead of left and right anchor we use leading and trailing anchor.
//        // It does the same thing. Video explains why we prefer it (convention)
//        bottomViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bottomViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        bottomViewContainer.addSubview(gamerTagView)
//        bottomViewContainer.addSubview(emailTagView)
//        bottomViewContainer.addSubview(pwTagView)
//        bottomViewContainer.addSubview(loginButtonView)
//
//        // GamerTagView
//
//        gamerTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
//        gamerTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
//        gamerTagView.topAnchor.constraint(equalTo: bottomViewContainer.topAnchor, constant: 20).isActive = true
//
//        // Email View
//
//        emailTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
//        emailTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
//        emailTagView.topAnchor.constraint(equalTo: gamerTagView.bottomAnchor, constant: 20).isActive = true
//
//        // PW View
//
//        pwTagView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
//        pwTagView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
//        pwTagView.topAnchor.constraint(equalTo: emailTagView.bottomAnchor, constant: 20).isActive = true
//
//        // Login Button
//
//        loginButtonView.centerXAnchor.constraint(equalTo: bottomViewContainer.centerXAnchor).isActive = true
//        loginButtonView.widthAnchor.constraint(equalTo: bottomViewContainer.widthAnchor, multiplier: 0.7).isActive = true
//        loginButtonView.topAnchor.constraint(equalTo: pwTagView.bottomAnchor, constant: 40).isActive = true
//        loginButtonView.setTitle("Login", for: .normal)
//        loginButtonView.setTitleColor(UIColor.darkGray, for: .normal)
//        loginButtonView.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
}
