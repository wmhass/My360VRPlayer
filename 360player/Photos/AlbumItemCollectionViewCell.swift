//
//  AlbumItemCollectionViewCell.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Photos

class AlbumItemCollectionViewCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String!
    
    static let ReuseIdentifier = "AlbumItemCollectionViewCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewOverlayView: UIView!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var durationLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var favoriteIconImageView: UIImageView!
    @IBOutlet var favoriteIconViewBottomConstraint: NSLayoutConstraint!
    
    override var isHighlighted: Bool {
        didSet {
            self.imageViewOverlayView.isHidden = !self.isHighlighted
        }
    }
    override var isSelected: Bool {
        didSet {
            self.imageViewOverlayView.isHidden = !self.isHighlighted
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.durationLabel.text = "0:17"
        self.imageViewOverlayView.isHidden = true
        
        self.favoriteIconImageView.isHidden = true
        self.durationLabel.isHidden = true
    }
    
    private func applyTheme() {
        self.imageViewOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.imageView.backgroundColor = UIColor.lightGray
        
        self.favoriteIconImageView.backgroundColor = UIColor.clear
        self.favoriteIconImageView.tintColor = UIColor.white
        self.favoriteIconImageView.image = UIImage(named: "ico-favorite")?.withRenderingMode(.alwaysTemplate)
        
        
        
        self.durationLabel.textColor = UIColor.white
        self.durationLabel.font = UIFont.systemFont(ofSize: 11)
        
        self.durationLabelBottomConstraint.constant = 3.5
        self.favoriteIconViewBottomConstraint.constant = 6.5
    }

    func setup(withAsset asset: PHAsset, imageManager: PHCachingImageManager, thumbnailSize: CGSize) {
        
        self.durationLabel.isHidden = asset.mediaType != PHAssetMediaType.video
        self.imageView.image = nil

        self.representedAssetIdentifier = asset.localIdentifier
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, _ in
            if self?.representedAssetIdentifier == asset.localIdentifier {
                self?.imageView.image = image
            }
        })
        
        self.durationLabel.text = TimeIntervalHelper.timeVideoDurationString(fromTimeInterval: asset.duration)
        
        self.favoriteIconImageView.isHidden = !asset.isFavorite
    }
    
}
