//
//  FeedCell.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/18/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var signedInUser = User()
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        findSignedInUser()
        
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.register(LobbyCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // Collections for user lobbies
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signedInUser.joinedLobbies.count
    }

    // FIgure out how to get the subviews within a collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! LobbyCell

        let lobby = signedInUser.joinedLobbies[indexPath.row]

        cell.gameTitleLabel.text = findLobbyHost(hostID: lobby.hostID).gamerTag
        cell.playersTextView.text = "Total players: \(String(lobby.numberOfPlayers))"
        cell.msgTextView.text = "\"\(lobby.message)\""
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
        cell.leaveButtonView.layer.setValue(lobby, forKey: "index")
        cell.leaveButtonView.addTarget(self, action: #selector(leaveLobby), for: .touchUpInside)

        return cell
    }

    // Returns the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 120)
    }
    
    // Remove the lobby from both the user.joinedlobbies and user.createdLobbies
    @objc func leaveLobby(sender: UIButton) {
        let lobby = (sender.layer.value(forKey: "index")) as! Lobby
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(lobby)
        }
        collectionView.reloadData()
    }
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        self.signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        self.collectionView.reloadData()
    }
    
    private func findLobbyHost(hostID: String) -> User {
        let realm = try! Realm()
        let hostUser = realm.object(ofType: User.self, forPrimaryKey: hostID)!
        return hostUser
    }
    
}
