//
//  AlbunsDataSet.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Photos

class AlbunsDataSet {
    
    var smartAlbumsViewModels: [AlbumViewModel] = [AlbumViewModel]()
    var userColelctionsViewModels: [AlbumViewModel] = [AlbumViewModel]()
    
    var smartAlbums: PHFetchResult<PHAssetCollection>! {
        didSet {
            self.smartAlbumsViewModels.removeAll()
            for j in 0..<self.smartAlbums.count {
                let object = self.smartAlbums.object(at: j)
                if let title = object.localizedTitle {
                    
                    let viewModel = AlbumViewModel(name: title)
                    
                    let itemsOptions = PHFetchOptions()
                    itemsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    viewModel.assets = PHAsset.fetchAssets(in: object, options: itemsOptions)
                    
                    self.smartAlbumsViewModels.append(viewModel)
                }
            }
        }
    }

    var userCollections: PHFetchResult<PHCollection>! {
        didSet {
            self.userColelctionsViewModels.removeAll()
            for i in 0..<self.userCollections.count {
                let object = self.userCollections.object(at: i)
                if let title = object.localizedTitle {
                    
                    let viewModel = AlbumViewModel(name: title)
                    
                    let itemsOptions = PHFetchOptions()
                    itemsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    viewModel.assets = PHAsset.fetchAssets(in: object as! PHAssetCollection, options: itemsOptions)
                    
                    self.userColelctionsViewModels.append(viewModel)
                }
            }
        }
    }
    
    let sectionLocalizedTitle = ["", NSLocalizedString("My Albums", comment: "")]
}

enum Section: Int {
    case smartAlbums = 0
    case userCollections
    
    static let count = 2
}

// MARK: - AlbunsDataSetProtocol
extension AlbunsDataSet: AlbunsDataSetProtocol {
    
    func numberOfSections() -> Int {
        return Section.count
    }
    
    func title(forSectionAtIndex sectionIndex: Int) -> String {
        return self.sectionLocalizedTitle[sectionIndex]
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) -> AlbumViewModel? {
        switch Section(rawValue: indexPath.section)! {
        case .smartAlbums:
            return self.smartAlbumsViewModels[indexPath.item]
            
            
        case .userCollections:
            return self.userColelctionsViewModels[indexPath.item]
        }
    }
}
