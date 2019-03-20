//
//  ColorCollectionViewCell.swift
//  CustomPageControl
//
//  Created by MAC on 20/03/19.
//  Copyright © 2019 frzy. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    
    let identifier = "ColorCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setColor(color: UIColor) {
        colorView.backgroundColor = color
    }
}
