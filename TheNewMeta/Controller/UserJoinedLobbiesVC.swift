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
    
    // Collection View for the collection view that is holding the collection of Feed Cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Somehow the view.frame.width is off
        return CGSize(width: view.frame.width, height: view.frame.height - 100)
    }
    
    // Menu Bar Setup
    
    // Allows self to me access within this block!
    lazy var menuBarView: MenuBar = {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.backgroundColor = .blue
        // setting userJoinedLobbiesVC = self
        menuBar.userJoinedLobbiesVC = self
        return menuBar
    }()
        
    private func setupMenuBar() {
        view.addSubview(menuBarView)
        menuBarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        menuBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    // This will let us know which scroll view we are on telling us the translation value
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
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
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        // We are using a new class called Feed Cell which represents each cell in the UICollectionView instead of using a generic UICollectiViewCell
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
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

    
//    userJoinedLobbiesVC?.scrollToMenuIndex(menuIndex: indexPath.item) // indexPath.item is the index of the collection

    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

