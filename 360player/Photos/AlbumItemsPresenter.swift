//
//  AlbumItemsPresenter.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class AlbumItemsPresenter {
    weak var view: AlbumItemsUserInterfaceProtocol?
    let albumViewModel: AlbumViewModel
    
    init(albumViewModel: AlbumViewModel) {
        self.albumViewModel = albumViewModel
    }
}

// MARK: - AlbumItemsUserInterfaceEventHandler
extension AlbumItemsPresenter: AlbumItemsUserInterfaceEventHandler {
    func viewDidLoad(view: AlbumItemsUserInterfaceProtocol) {
        self.view = view
        
        self.view?.setup(withViewModel: self.albumViewModel)
        
    }
}
