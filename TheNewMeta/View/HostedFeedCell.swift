//
//  HostedFeedCell.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/18/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

class HostedFeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var signedInUser = User()
    let hostedID = "hostedID"
    
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

        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.register(HostedCell.self, forCellWithReuseIdentifier: hostedID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    // Collections for user lobbies
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signedInUser.createdLobbies.count
    }
    
    // Figure out how to get the subviews within a collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hostedID", for: indexPath) as! HostedCell
        
        let lobby = signedInUser.createdLobbies[indexPath.item]
        
        cell.gameLabel.text = lobby.game.title
        cell.currentNumPlayers.text = "Total Players: \(String(lobby.numberOfPlayers))"
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
        cell.cancelButtonView.layer.setValue(lobby, forKey: "index")
        cell.cancelButtonView.addTarget(self, action: #selector(cancelLobby), for: .touchUpInside)
        
        return cell
    }
    
    // Returns the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 120)
    }
    
    @objc func cancelLobby(sender: UIButton) {
        let lobby = (sender.layer.value(forKey: "index")) as! Lobby
    
        let realm = try! Realm()
        try! realm.write {
            realm.delete(lobby)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//        collectionView.reloadData()
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
    
    @objc private func loadList(){
        self.collectionView.reloadData()
    }
}
