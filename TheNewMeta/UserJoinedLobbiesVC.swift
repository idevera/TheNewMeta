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

class UserJoinedLobbiesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var signedInUser = User()
    
    // Collections
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 150)
    }
    
//    let labels = ["My Lobbies", "Host Lobbies"]
//    let lobbyIdentifier = "joinedLobbyCell"
//
////    @IBOutlet weak var joinedLobbyTableView: UITableView!
////    @IBOutlet weak var tabBarView: UICollectionView!
////    @IBOutlet weak var menuCollectionView: UICollectionView!
////    let joinedLobbyTableView = UITableView()
////    let tabBarView = UICollectionView()
////    let menuCollectionView = UICollectionView()
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return signedInUser.joinedLobbies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyIdentifier, for: indexPath) as? JoinedLobbyTableViewCell else {
//            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
//        }
//
//        let lobby = signedInUser.joinedLobbies[indexPath.row]
//
//        cell.lobbyHostLabel.text = findLobbyHost(hostID: lobby.hostID).gamerTag
//        cell.gameTitleLabel.text = lobby.game.title
//
//        return cell
//    }
//
    // Collections
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuViewCell
//
//        cell.menuLabel.text = labels[indexPath.row]
//        cell.backgroundColor = UIColor.blue
//        return cell
//    }
    
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
        collectionView?.backgroundColor = .lightGray
        collectionView?.register(lobbyCell.self, forCellWithReuseIdentifier: "cellID")

        
//        joinedLobbyTableView.delegate = self
//        joinedLobbyTableView.dataSource = self
//        self.joinedLobbyTableView.reloadData()
        
//        menuCollectionView.delegate = self
//        menuCollectionView.dataSource = self
    }
}

class lobbyCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let gameTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let leaveButtonView: UIButton = {
        let leaveButton = UIButton()
        leaveButton.backgroundColor = .red
        leaveButton.translatesAutoresizingMaskIntoConstraints = false
        leaveButton.setTitle("Leave?", for: .normal)
        return leaveButton
    }()
    
    func setupViews() {
        addSubview(gameTitleLabel)
        addSubview(leaveButtonView)
        
        // Constraints for game Label
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 5))
        
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .left, relatedBy: .equal, toItem: gameTitleLabel, attribute: .right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
        
//        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .right, relatedBy: .equal, toItem: leaveButtonView, attribute: .left, multiplier: 1, constant: 5))
////        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
//        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -5))
//
//        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

