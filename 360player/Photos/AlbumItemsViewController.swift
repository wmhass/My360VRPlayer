//
//  AlbumItemsViewController.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Photos

class AlbumItemsViewController: UIViewController {
    
    fileprivate var thumbnailSize: CGSize!
    @IBOutlet weak var albumItemsCollectionView: UICollectionView!
    fileprivate let imageManager = PHCachingImageManager()
    var presenter: AlbumItemsUserInterfaceEventHandler?
    var viewModel: AlbumViewModel? {
        didSet {
            self.updateView()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.albumItemsCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: { (_) in
            self.albumItemsCollectionView.collectionViewLayout.invalidateLayout()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad(view: self)
        self.setupAlbumItemsCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
        let cellSize = (self.albumItemsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        self.thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    private func setupAlbumItemsCollectionView() {
        if let layout = self.albumItemsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemsPerRow: CGFloat = 4
            let margin: CGFloat = 1
            let screenFrame = UIScreen.main.bounds
            let screenMinSize = min(screenFrame.size.width, screenFrame.size.height)
            let size = (screenMinSize - (margin*3))/itemsPerRow
            
            layout.itemSize = CGSize(width: size, height: size)
        }
    }
    
    func setup(withAlbumViewModel albumViewModel: AlbumViewModel) {
        self.presenter = AlbumItemsPresenter(albumViewModel: albumViewModel)
    }
    
    private func updateView() {
        self.title = self.viewModel?.name
        
        self.albumItemsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.FromDetailToVideo360VR,
            let destinationView = segue.destination as? Video360VRViewController,
            let asset = sender as? PHAsset {
            destinationView.asset = asset
            
        } else if segue.identifier == SegueIdentifiers.FromDetailToPhoto360VR,
            let destinationView = segue.destination as? Photo360VRViewController,
            let asset = sender as? PHAsset {
            destinationView.asset = asset
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumItemsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let assets = self.viewModel?.assets, assets.count > 0  {
            let asset = assets.object(at: indexPath.item)
            if asset.mediaType == PHAssetMediaType.image {
                self.performSegue(withIdentifier: SegueIdentifiers.FromDetailToPhoto360VR, sender: asset)
                
            } else if asset.mediaType == PHAssetMediaType.video {
                self.performSegue(withIdentifier: SegueIdentifiers.FromDetailToVideo360VR, sender: asset)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumItemsViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let assets = self.viewModel?.assets else {
            return 0
        }
        return assets.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumItemCollectionViewCell.ReuseIdentifier, for: indexPath) as! AlbumItemCollectionViewCell
        
        if let assets = self.viewModel?.assets, assets.count > 0  {
            let asset = assets.object(at: indexPath.item)
            cell.setup(withAsset: asset, imageManager: self.imageManager, thumbnailSize: self.thumbnailSize)
        }
        
        return cell
        
    }
}

// MARK: - AlbumItemsUserInterfaceProtocol
extension AlbumItemsViewController: AlbumItemsUserInterfaceProtocol {
    
    func setup(withViewModel viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
}
