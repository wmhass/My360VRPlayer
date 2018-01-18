//
//  AlbumCollectionViewHeader.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class AlbumCollectionViewHeader: UICollectionReusableView {
    static let ReuseIdentifier: String = "AlbumCollectionViewHeader"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
    private func applyTheme() {
        self.titleLabel.textColor = UIColor.darkGray
        self.titleLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    func setup(withTitleText titleText: String) {
        self.titleLabel.text = titleText
    }
    
}
