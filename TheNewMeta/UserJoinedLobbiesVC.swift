//
//  UserJoinedLobbiesVC.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/9/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class UserJoinedLobbiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let labels = ["My Lobbies", "Host Lobbies"]
    
    let lobbyIdentifier = "joinedLobbyCell"
    private var signedInUser = User()
    
    @IBOutlet weak var joinedLobbyTableView: UITableView!
    @IBOutlet weak var tabBarView: UICollectionView!
    @IBOutlet weak var menuCollectionView: UICollectionView!

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signedInUser.joinedLobbies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyIdentifier, for: indexPath) as? JoinedLobbyTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }

        let lobby = signedInUser.joinedLobbies[indexPath.row]
        
        cell.lobbyHostLabel.text = findLobbyHost(hostID: lobby.hostID).gamerTag
        cell.gameTitleLabel.text = lobby.game.title
        
        return cell
    }
    
    // Collections
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuViewCell
        
        cell.menuLabel.text = labels[indexPath.row]
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    // TODO: Should probably save the entire user object in the UserDefaults instead of just the ID
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        
        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
    // TODO: Should probably just save this as an attribute of the controller??? IDK
    private func findLobbyHost(hostID: String) -> User {
        let realm = try! Realm()
        let hostUser = realm.object(ofType: User.self, forPrimaryKey: hostID)!
        return hostUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSignedInUser()
        
        joinedLobbyTableView.delegate = self
        joinedLobbyTableView.dataSource = self
        self.joinedLobbyTableView.reloadData()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
}
