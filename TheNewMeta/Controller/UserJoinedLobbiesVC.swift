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
    let cellID = "cellID"
    
    // Collection for user lobbies
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return signedInUser.joinedLobbies.count
//    }
//
//    // FIgure out how to get the subviews within a collection
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! LobbyCell
//
//        let lobby = signedInUser.joinedLobbies[indexPath.row]
//
//        cell.gameTitleLabel.text = findLobbyHost(hostID: lobby.hostID).gamerTag
//        cell.playersTextView.text = String(lobby.numberOfPlayers)
//        cell.msgTextView.text = lobby.message
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width - 10, height: 120)
//    }
    
    // Test Slide
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let colors: [UIColor] = [.red, .green]
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    let menuBarView: MenuBar = {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.backgroundColor = .blue
        return menuBar
    }()
    
    // Private Functions
    
    private func setupMenuBar() {
        view.addSubview(menuBarView)
        menuBarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        menuBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .lightGray
        
//        collectionView?.register(LobbyCell.self, forCellWithReuseIdentifier: "cellID")
        // Pushes the collection view from being underneath the menu
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        
        // Changes where the scroll of the collection view to not be underneath the menu bar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 0, 0)
        //////////
        //////////
        // This is the collection for the side scroll
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            // minimizes the space between scrolls
            layout.minimumLineSpacing = 0
        }
        
        // Snaps views into place
        collectionView?.isPagingEnabled = true
    }
    
    // TODO: Should probably save the entire user object in the UserDefaults instead of just the ID
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
//        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
    // TODO: Should probably just save this as an attribute of the controller??? IDK
    private func findLobbyHost(hostID: String) -> User {
        let realm = try! Realm()
        let hostUser = realm.object(ofType: User.self, forPrimaryKey: hostID)!
        return hostUser
    }
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSignedInUser()
        setupMenuBar()
        setupCollectionView()
    }
}

// TODO: MOVE THIS INTO IT'S OWN SWIFT FILE

// This is the super class of all UICollectionViewCells
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LobbyCell: BaseCell {
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
    
    let playersTextView: UILabel = {
        let playersText = UILabel()
        playersText.backgroundColor = .green
        playersText.translatesAutoresizingMaskIntoConstraints = false
        return playersText
    }()
    
    let msgTextView: UILabel = {
        let msgText = UILabel()
        msgText.backgroundColor = .white
        msgText.translatesAutoresizingMaskIntoConstraints = false
        return msgText
    }()
    
    // View Constraints
    
    override func setupViews() {
        addSubview(gameTitleLabel)
        addSubview(leaveButtonView)
        addSubview(playersTextView)
        addSubview(msgTextView)
        
        // Game label view
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0))
        addConstraint(NSLayoutConstraint(item: gameTitleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 5))

        // Leave Button View
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .left, relatedBy: .equal, toItem: gameTitleLabel, attribute: .right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: leaveButtonView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))

        // Player Text View
        addConstraint(NSLayoutConstraint(item: playersTextView, attribute: .top, relatedBy: .equal, toItem: gameTitleLabel, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersTextView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: playersTextView, attribute: .right, relatedBy: .equal, toItem: leaveButtonView, attribute: .left, multiplier: 1, constant: -5))

        // Msg Text View
        addConstraint(NSLayoutConstraint(item: msgTextView, attribute: .top, relatedBy: .equal, toItem: playersTextView, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: msgTextView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: msgTextView, attribute: .right, relatedBy: .equal, toItem: leaveButtonView, attribute: .left, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: msgTextView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
    }
}

