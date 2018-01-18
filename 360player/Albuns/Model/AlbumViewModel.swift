//
//  AlbumViewModel.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Photos

class AlbumViewModel {
    
    var name: String
    var assets: PHFetchResult<PHAsset>?
    
    init(name: String) {
        self.name = name
    }
}
