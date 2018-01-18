//
//  AlbunsPresenter.swift
//  360player
//
//  Created by William Hass on 11/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Photos

class AlbunsPresenter: NSObject {
    
    weak var view: AlbunsUserInterfaceProtocol?
    var interactor: AlbunsInteractorProtocol?
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

// MARK: - AlbunsUserInterfaceEventHandler
extension AlbunsPresenter: AlbunsUserInterfaceEventHandler {

    func viewDidLoad(view: AlbunsUserInterfaceProtocol) {
        PHPhotoLibrary.shared().register(self)
        
        self.view = view
        self.view?.setup(withTitle: "Albums")
        
        self.reloadView()
    }
    
    func reloadView() {
        self.view?.showNotAuthorizedView(show: PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized)
        self.view?.display(albunsDataSet: AlbunsInteractor.albumDataSet())
    }
    
    func authorizeButtonTouched() {
        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsURL)
            }
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbunsPresenter: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            self.reloadView()
        }
    }
}

