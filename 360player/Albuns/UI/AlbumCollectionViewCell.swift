//
//  AlbumCollectionViewCell.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionViewCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String!
    static let ReuseIdentifier = "AlbumCollectionViewCell"
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var textContainer: UIView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var imageOverlayView: UIView!
    @IBOutlet var favoriteIconImageView: UIImageView!
    @IBOutlet var favoriteIconViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var favoriteIconViewLeftConstraint: NSLayoutConstraint!
    override var isHighlighted: Bool {
        didSet {
            self.imageOverlayView.isHidden = !self.isHighlighted
        }
    }
    override var isSelected: Bool {
        didSet {
            self.imageOverlayView.isHidden = !self.isHighlighted
        }
    }
    
    weak var viewModel: AlbumViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.imageOverlayView.isHidden = true
        self.favoriteIconImageView.isHidden = true
    }

    private func applyTheme() {
        self.textContainer.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.imageView.layer.cornerRadius = 3
        
        self.titleLabel.text = "Camera Roll"
        self.subtitleLabel.text = "5"
        
        self.titleLabel.textColor = UIColor.darkText
        self.subtitleLabel.textColor = UIColor.lightGray
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.imageView.backgroundColor = UIColor.lightGray
        
        self.imageOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.imageOverlayView.layer.cornerRadius = 3
        
        self.favoriteIconViewBottomConstraint.constant = 6.5
        self.favoriteIconViewLeftConstraint.constant = 6.5
        
        self.favoriteIconImageView.backgroundColor = UIColor.clear
        self.favoriteIconImageView.tintColor = UIColor.white
        self.favoriteIconImageView.image = UIImage(named: "ico-favorite")?.withRenderingMode(.alwaysTemplate)
    }

    func setup(withAlbumViewModel viewModel: AlbumViewModel, imageManager: PHCachingImageManager, thumbnailSize: CGSize) {
        self.viewModel = viewModel
        
        self.titleLabel.text = self.viewModel?.name
        if let numberOfItems = self.viewModel?.assets?.count {
            self.subtitleLabel.text = String(numberOfItems)
        } else {
            self.subtitleLabel.text = String(0)
        }
        
        self.imageView.image = nil
        if let assets = self.viewModel?.assets, assets.count > 0  {
            let asset = assets.object(at: 0)
            
            self.representedAssetIdentifier = asset.localIdentifier
            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, _ in
                if self?.representedAssetIdentifier == asset.localIdentifier {
                    self?.imageView.image = image
                }
            })
        }
    }
}
