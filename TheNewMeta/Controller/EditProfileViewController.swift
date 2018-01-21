//
//  EditProfileViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/16/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

class EditProfileViewController: UIViewController {
    
    private var signedInUser = User()

    // Private Functions
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        print("This is the id of the signed in user \(String(describing: id))")
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
//    @objc dynamic var userID: String = UUID().uuidString
//    @objc dynamic var gamerTag: String = ""
//    @objc dynamic var email: String = ""
//    @objc dynamic var password: String = ""
//    // List of all lobbies that the user has created
//    var createdLobbies = List<Lobby>()
//
//    // List of all lobbies that this user has joined
//    let joinedLobbies = LinkingObjects(fromType: Lobby.self, property: "lobbyUsers")
//
    // Views and Constraints

    let gamerTagField: UITextField = {
        let gamerName = UITextField()
        gamerName.translatesAutoresizingMaskIntoConstraints = false
        gamerName.backgroundColor = .white
        gamerName.layer.cornerRadius = 10
        gamerName.textAlignment = .center
//        gamerName.text = "\(signedInUser.gamerTag)"
        return gamerName
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
    
    let submitButtonView: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .yellow
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("Create Lobby", for: .normal)
        submitButton.setTitleColor(UIColor.darkGray, for: .normal)
//        submitButton.addTarget(self, action: #selector(createLobby(_:)), for: .touchUpInside)
        return submitButton
    }()
    
    private func setupLayout() {
//        view.backgroundColor = UIColor(red:0.53, green:0.77, blue:0.80, alpha:1.0)
        
        view.addSubview(playersFieldView)
        view.addSubview(gamerTagField)
        view.addSubview(msgFieldView)
        
        playersFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playersFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        playersFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        gamerTagField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gamerTagField.bottomAnchor.constraint(equalTo: playersFieldView.topAnchor, constant: -20).isActive = true
        gamerTagField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        gamerTagField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        msgFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        msgFieldView.topAnchor.constraint(equalTo: playersFieldView.bottomAnchor, constant: 20).isActive = true
        msgFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        msgFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        view.addSubview(submitButtonView)
        submitButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButtonView.topAnchor.constraint(equalTo: msgFieldView.bottomAnchor, constant: 20).isActive = true
        submitButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSignedInUser()
        setupLayout()
    }

}
