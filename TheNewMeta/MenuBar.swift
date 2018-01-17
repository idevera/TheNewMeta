//
//  MenuBar.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/17/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        return cv
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(collectionView)
//        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
