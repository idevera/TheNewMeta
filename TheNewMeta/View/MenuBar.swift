//
//  MenuBar.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/17/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.backgroundColor = .yellow
        return cv
    }()
    
    let menuLabelNames = ["Joined Lobbies", "Lobbies I Host"]

    let cellID = "cellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cellID")
        
        addSubview(collectionView)
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // This is to highlight the initial menu My Lobbies
        let selectedIndex = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
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
        mlabel.text = "My Lobbies"
        mlabel.textColor = .darkGray
        mlabel.highlightedTextColor = .darkGray
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
        backgroundColor = .blue
        addSubview(menuViewLabel)
        menuViewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuViewLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
