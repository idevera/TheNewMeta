//
//  Helpers.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/12/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

extension UITextField {
    func underlined(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 2.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}


