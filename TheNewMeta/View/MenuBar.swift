//
//  MenuBar.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/17/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let menuLabelNames = ["Joined Lobbies", "Lobbies I Host"]

    let cellID = "cellID"
    
    // You can save another controller as a property of another view or controller! Now you can call the functions from this controller! Pretty cool eh?
    var userJoinedLobbiesVC: UserJoinedLobbiesVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cellID")
        
        addSubview(collectionView)
        // This is adding a width and a height for the menu collection equal to the menu bar constraints
        collectionView.backgroundColor = .clear
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // This is to highlight the initial menu My Lobbies
        let selectedIndex = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
    }
    
    // This is now a property of MenuBar Class
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 95, alpha: 1)
//        horizontalBarView.backgroundColor = UIColor(hex: "#B7C3F3")
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        // Set the contstraint to itself and then save it as a class reference NSLayoutConstraint
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor) // The left constraint is equal to the cell left constraint
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    // If a specific index in a collection is pressed, run this function
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // frame is the size of the entire collection
        // WE NO LONGER NEED THIS because the userJoinedLobbiesVC keeps track of the horizontalLeftBarConstraint in the scrollViewDidScrollMethod
//        let x = CGFloat(indexPath.item) * frame.width / 2 // The width of the collection frame is 414
//        horizontalBarLeftAnchorConstraint?.constant = x
        
        // Here we pass in the menuIndex that we clicked on from the collection view and pass it into the method in the UserJoinedLobbiesVC. You will not see any change. You now need to go back to the menuBar anonymous function and add it as a property of home controller
         // indexPath.item is the index of the collection
        userJoinedLobbiesVC?.scrollToMenuIndex(menuIndex: indexPath.item)
//        collectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        cell.menuViewLabel.text = menuLabelNames[indexPath.row]
        return cell
    }
    
    // Specifies the size of of each collectionviewcell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    // Reduces the space between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// See UserJoinedLobbies VC for the basecell
class MenuCell: BaseCell {
    let menuViewLabel: UILabel = {
        let mlabel = UILabel()
        mlabel.translatesAutoresizingMaskIntoConstraints = false
        return mlabel
    }()
    
    // If the labels are clicked, it will be selected somehow?
    override var isSelected: Bool {
        didSet {
            menuViewLabel.highlightedTextColor = isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        addSubview(menuViewLabel)
        menuViewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuViewLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
