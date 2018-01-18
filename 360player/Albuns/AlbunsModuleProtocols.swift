//
//  AlbunsModuleProtocols.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

protocol AlbunsUserInterfaceProtocol: class {
    func showNotAuthorizedView(show: Bool)
    func display(albunsDataSet: AlbunsDataSetProtocol)
    func setup(withTitle title: String)
}

protocol AlbunsUserInterfaceEventHandler {
    func viewDidLoad(view: AlbunsUserInterfaceProtocol)
    func authorizeButtonTouched()
}

protocol AlbunsInteractorProtocol {
    static func albumDataSet() -> AlbunsDataSetProtocol
}

protocol AlbunsDataSetProtocol {
    func numberOfSections() -> Int
    func title(forSectionAtIndex sectionIndex: Int) -> String
    func numberOfItems(inSection section: Int) -> Int
    func viewModel(atIndexPath indexPath: IndexPath) -> AlbumViewModel?
}
