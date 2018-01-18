//
//  AlbunsViewController.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class AlbunsViewController: UIViewController {

    fileprivate var thumbnailSize: CGSize!
    var presenter: AlbunsUserInterfaceEventHandler!
    var dataSet: AlbunsDataSetProtocol = AlbunsDataSet()
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    @IBOutlet var albumCollectionView: UICollectionView!
    @IBOutlet var notAuthorizedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAlbumCollectionView()
        
        let presenter = AlbunsPresenter()

        self.presenter = presenter
        self.presenter?.viewDidLoad(view: self)
    }
    
    private func setupAlbumCollectionView() {
        let layout = self.albumCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellFooterHeight: CGFloat = 45
        let marginSpace: CGFloat = 20
        
        let screenFrame = UIScreen.main.bounds
        let screenMinSize = min(screenFrame.size.width, screenFrame.size.height)
        let width = (screenMinSize/2) - marginSpace - marginSpace/2
        
        layout.itemSize = CGSize(width: width, height: width+cellFooterHeight)
        
        let scale = UIScreen.main.scale
        self.thumbnailSize = CGSize(width: 250 * scale, height: 250 * scale)
        
        layout.minimumInteritemSpacing = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.FromAlbumToItems,
            let cell = sender as? UICollectionViewCell,
            let indexPath = self.albumCollectionView.indexPath(for: cell),
            let destinationView = segue.destination as? AlbumItemsViewController,
            let viewModel = self.dataSet.viewModel(atIndexPath: indexPath) {
            
            destinationView.setup(withAlbumViewModel: viewModel)
        }
    }
    
    @IBAction func btnAuthorizeTouched(_: AnyObject) {
        self.presenter.authorizeButtonTouched()
    }
}

// MARK: - AlbunsUserInterfaceProtocol
extension AlbunsViewController: AlbunsUserInterfaceProtocol {
    
    func display(albunsDataSet: AlbunsDataSetProtocol) {
        self.dataSet = albunsDataSet
        
        self.albumCollectionView.reloadData()
    }
    
    func setup(withTitle title: String) {
        self.title = title
    }
    
    func showNotAuthorizedView(show: Bool) {
        self.notAuthorizedView.isHidden = !show
    }
}

// MARK: - UICollectionViewFlowLayoutDelegate
extension AlbunsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let title = self.dataSet.title(forSectionAtIndex: section)
        
        if title.characters.count == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 24)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlbunsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSet.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSet.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumCollectionViewHeader.ReuseIdentifier, for: indexPath) as! AlbumCollectionViewHeader
        
        let title = self.dataSet.title(forSectionAtIndex: indexPath.section)
        view.setup(withTitleText: title)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = AlbumCollectionViewCell.ReuseIdentifier
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        
        if let viewModel = self.dataSet.viewModel(atIndexPath: indexPath) {
            cell.setup(withAlbumViewModel: viewModel, imageManager: self.imageManager, thumbnailSize: self.thumbnailSize)
        }
        
        return cell
        
    }
    
}
