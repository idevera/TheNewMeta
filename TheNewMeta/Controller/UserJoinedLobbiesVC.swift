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
    let cellID = "cellID"
    let hostedID = "hostedID"
   
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupCollectionView()
    }
    
    // Collection View for the collection view that is holding the collection of Feed Cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Display FeedCells in the collection view if index 0 is chosen
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        // Display the HostedFeedCells is index 1 is chosen
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hostedID, for: indexPath)
            return cell
        }
        return cell
    }
    
    // Changes the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 100)
    }
    
    // Menu Bar Setup
    
    // Allows self to me access within this block!
    lazy var menuBarView: MenuBar = {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.userJoinedLobbiesVC = self
        return menuBar
    }()
        
    private func setupMenuBar() {
        view.addSubview(menuBarView)
        menuBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    // MenuBar View Underline
    
    // This will let us know which scroll view we are on telling us the translation value
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Moves the underline of menubar with the scrollview
        // To make it make, divide the scroll value by 2 the number of items in collection
        menuBarView.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    // This highlights the icon text colors with when scrolling over
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // This is the value of the one scroll over divided by the entire width of the view frame to get the index
        // This is a CGFloat
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // Horizontal Collection Views
    
    private func setupCollectionView() {
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        // Changes where the scroll of the collection view to not be underneath the menu bar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 0, 0)

        // This is the collection for the side scroll
        // collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        // We are using a new class called Feed Cell which represents each cell in the UICollectionView instead of using a generic UICollectiViewCell
        
        // Feed Cell 1
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        // Feed Cell 2
        collectionView?.register(HostedFeedCell.self, forCellWithReuseIdentifier: hostedID)

        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            // minimizes the space between scrolls
            layout.minimumLineSpacing = 0
        }
        
        // Snaps horizontal views into place
        collectionView?.isPagingEnabled = true
    }
    
    // Scroll each horizontal view in collection with each button click
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
}

// Cell Classes

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

func leaveAction() {
    
}

// Lobby Cell in Feed Cell 1 inherits from BaseCell

class LobbyCell: BaseCell {
    let gameTitleLabel: UILabel = {
        let label = UILabel()
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
        playersText.translatesAutoresizingMaskIntoConstraints = false
        return playersText
    }()
    
    let msgTextView: UILabel = {
        let msgText = UILabel()
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

// Hosted Cell for Feed 2

class HostedCell: BaseCell {
    let gameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButtonView: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .blue
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel?", for: .normal)
        return cancelButton
    }()
    
    let currentNumPlayers: UILabel = {
        let numPlayers = UILabel()
//        numPlayers.backgroundColor = .green
        numPlayers.translatesAutoresizingMaskIntoConstraints = false
        return numPlayers
    }()
    
    // View Constraints
    
    override func setupViews() {
        addSubview(gameLabel)
        addSubview(cancelButtonView)
        addSubview(currentNumPlayers)
        
        // Game label view
        addConstraint(NSLayoutConstraint(item: gameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: gameLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0))
        addConstraint(NSLayoutConstraint(item: gameLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.7, constant: 5))
        
        // Leave Button View
        addConstraint(NSLayoutConstraint(item: cancelButtonView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: cancelButtonView, attribute: .left, relatedBy: .equal, toItem: gameLabel, attribute: .right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: cancelButtonView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: cancelButtonView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))

        // Player Text View
        addConstraint(NSLayoutConstraint(item: currentNumPlayers, attribute: .top, relatedBy: .equal, toItem: gameLabel, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: currentNumPlayers, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: currentNumPlayers, attribute: .right, relatedBy: .equal, toItem: cancelButtonView, attribute: .left, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: currentNumPlayers, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
    }
}

