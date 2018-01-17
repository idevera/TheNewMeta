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

    let cellID = "cellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cellID")
        
        addSubview(collectionView)
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
//        cell.backgroundColor = .yellow
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
        mlabel.textColor = .black
        return mlabel
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .blue
        addSubview(menuViewLabel)
        menuViewLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        menuViewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuViewLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
}
