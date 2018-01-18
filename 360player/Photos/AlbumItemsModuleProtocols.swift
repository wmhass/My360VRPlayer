//
//  AlbumItemsModuleProtocols.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

protocol AlbumItemsUserInterfaceProtocol: class {
    func setup(withViewModel viewModel: AlbumViewModel)
}

protocol AlbumItemsUserInterfaceEventHandler {
    func viewDidLoad(view: AlbumItemsUserInterfaceProtocol)
}
