//
//  AlbunsInteractor.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class AlbunsInteractor {
    
}


// MARK: - AlbunsInteractorProtocol
extension AlbunsInteractor: AlbunsInteractorProtocol {
    
    static func albumDataSet() -> AlbunsDataSetProtocol {
        let dataSet = AlbunsDataSet()
        
        dataSet.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        dataSet.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options:nil)
        
        return dataSet
    }

}
