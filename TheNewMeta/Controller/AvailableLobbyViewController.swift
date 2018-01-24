//
//  AvailableLobbyViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/7/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class AvailableLobbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    
    var chosenGame: Game?
    private var signedInUser = User()
    let lobbyCellIdentifier = "LobbyTableCell"
    lazy var gradient: CAGradientLayer = [
        UIColor(hex: "#FD4340"),
        UIColor(hex: "#CE2BAE")
        ].gradient { gradient in
            gradient.speed = 1
            gradient.timeOffset = 1
            return gradient
    }
    
    // Outlets
    
    @IBOutlet weak var lobbyTableView: UITableView!
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.insertSublayer(gradient, at: 0)
        lobbyTableView.delegate = self
        lobbyTableView.dataSource = self
        
        // Find the user and save it as a variable in this view
        findSignedInUser()
        
        self.title = "\(chosenGame?.title ?? "No Available Lobbies") Lobbies"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = self.view.bounds
    }
    
    // Lobby Tables
    
    // How many sections in your table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // How many rows in your table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenGame!.matchingLobbies.count
    }
    
    // What are the contents of each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The as? MealTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your MealTableViewCell class. This returns an optional.
        // The guard let expression safely unwraps the optional.
        // If your storyboard is set up correctly, and the cellIdentifier matches the identifier from your storyboard, then the downcast should never fail. If the downcast does fail, the fatalError() function prints an error message to the console and terminates the app
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyCellIdentifier, for: indexPath) as? LobbyViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        // The table view will iterate over each thing in the matchingLobbies
        let lobby = chosenGame?.matchingLobbies[indexPath.row]

        // Find the matching User of the lobby and return back their name
        let lobbyHost = findLobbyCreatorName(hostID: (lobby?.hostID)!)
        
        cell.gamerTagLabel.text = lobbyHost.gamerTag
        cell.numPlayersLabel.text = "Total Players: \(lobby?.numberOfPlayers ?? 0)"
        let message = "\(lobby?.message ?? "Hello")"
        cell.messageLabel.text = "\"\(message)\""
        
        // Save the index of the matchingLobbies array that currently are in
        cell.joinButton.tag = indexPath.row
        
        // Attach a click action
        cell.joinButton.addTarget(self, action: #selector(AvailableLobbyViewController.checkIfJoined), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    // Private Functions
    
    @objc private func checkIfJoined(sender: UIButton)  {
        let currentLobby = chosenGame?.matchingLobbies[sender.tag]
        let matchingUser = currentLobby?.lobbyUsers.filter("userID == '\(signedInUser.userID)'").first
        if matchingUser == nil {
            joinLobby(currentLobby: currentLobby!)
        } else {
            preventJoin()
        }
    }
    
    // The joinButton when clicked will send a message for this function to run
    private func joinLobby(currentLobby: Lobby) {
        let realm = try! Realm()
        
        try! realm.write {
            currentLobby.lobbyUsers.append(signedInUser)
        }
        
        let alert = UIAlertController(title: "Joined Lobby!", message: "You were added to this lobby", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
        
        // Navigate back to the root controller
        navigationController?.popToRootViewController(animated: true)
        
        // Update the users lobbies by sending a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        print("This is the signed in user gamer tag:", signedInUser.gamerTag)
    }
    
    private func findLobbyCreatorName(hostID: String) -> User {
        let realm = try! Realm()
        let userCreator = realm.objects(User.self).filter("userID = '\(hostID)'").first
        return userCreator!
    }
    
    private func preventJoin() {
        let alert = UIAlertController(title: "You are already in this lobby :)", message: "Please try another lobby to join", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
}
