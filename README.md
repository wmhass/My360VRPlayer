# My 360VR Player for iOS

[![My360VRPlayer](360player/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@2x.png)](https://itunes.apple.com/br/app/my-360vr-player/id1181451739)

[![My360VRPlayer App store](https://developer.apple.com//app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg)](https://itunes.apple.com/br/app/my-360vr-player/id1181451739)

## Setting Up

This project uses `cocoapods` to manage libraries dependencies. Although either checking in libraries files or not is fine, this project does not include the libraries folder due to the fact that one of the files is bigger than the size limit GitHub allows.

[Library file size discussion](https://github.com/googlevr/gvr-ios-sdk/issues/202)

To use this project, you will need the following instaled on your machine:

* Xcode 8 or later
* iOS 9 or later
* [CocoaPods](https://cocoapods.org/)


### CocoaPods

1. If you have not installed CocoaPods, install CocoaPods by running the command:

        $ gem install cocoapods
        $ pod setup

    Depending on your system settings, you may have to use `sudo` for installing `cocoapods` as follows:

        $ sudo gem install cocoapods
        $ pod setup
        
1. Then run the following command:
    
        $ pod install

1. Open up `*.xcworkspace` with Xcode and start using the project.

    **Note**: Do **NOT** use `*.xcodeproj`. If you open up a project file instead of a workspace, you receive an error


## Documentation

#### Albuns view (Initial view)

* Model
	- `AlbumViewModel` - Stores an Album information, such as album name and a list of its assets.
	- `AlbunsDataSet` - Conforms to `AlbunsDataSetProtocol`. Manages and store a list of Albuns. Provides methods to access Albuns' informations.

* `AlbunsInteractor` -  Conforms to `AlbunsInteractorProtocol`. Fetch a collection of Albuns from `PHAssetCollection` and `PHCollectionList` and return a `AlbunsDataSetProtocol`.

* `AlbunsPresenter` - Conforms to `AlbunsUserInterfaceEventHandler`. Respond to view events and is resposible for fetching data from an `AlbunsInteractorProtocol`, convert it to displayable data objects, and send this for the view (`AlbunsUserInterfaceProtocol`) to display the data. The view is driven by this presenter, and this knows "when" things should happen while the view can get focused on aknowledge "how" things happen.

* UI
	- `AlbumCollectionViewCell` - Subclass of `UICollectionViewCell` built to display an Album information inside a collection view. Contains an image that shows the latest photo from the given Album, an icon indicating if it is a Favorite Album, the name of the Album and how many assets it contains.
	- `AlbumCollectionViewHeader` - Subclass of `UICollectionReusableView` built to display the name of a collection of albuns. Is used as a header by the Albuns collection view.
	- `AlbunsViewController` - Subclass of `UIViewController` and conforms to `AlbunsUserInterfaceProtocol` and implement methods to display a `AlbunsDataSetProtocol` data in a collection view. The collection view it shows has a header with the name of the collection and a list of albuns inside the collection.


#### Album items (Photos and videos) view

* `AlbumItemsPresenter` - `Conforms to AlbumItemsUserInterfaceEventHandler`. Respond to events and drives a `AlbumItemsUserInterfaceProtocol`. Holds a `AlbumViewModel` view model and asks a view to display the album information and items.

* UI
	- `AlbumItemCollectionViewCell` - Subclass of `UICollectionViewCell` built to display an album item, such as a video or photo. It contains a thumbnail of the item, an icon indicating if it is a Favorite item or not, and if it is a video it shows its duration.

	- `AlbumItemsViewController` - Subclass of `UIViewController` and conforms to `AlbumItemsUserInterfaceProtocol`. Shows the title of the album and a list with the album items in a collection view.

#### Photo Virtual Reality Viewer

* UI
	- `Photo360VRViewController.m` - Shows a photo in 360 degrees either Panorama and Spherical. Also provides a Virtual Reality mode that can be used to view the photo in Virtual Reality glasses such as Google Cardboard. Written in `Objective C` because of compatibilities with `GVR` SDK.

#### Video Virtual Reality Viewer

* UI
	- `Video360VRViewController.m` - Shows a video in 360 degrees either Panorama and Spherical. Also provides a Virtual Reality mode that can be used to view the video in Virtual Reality glasses such as Google Cardboard. Written in `Objective C` because of compatibilities with `GVR` SDK.

#### `Bridging-Header.h`

Import `Objective C` files to Swift. 

* Importing `Video360VRViewController` and `Photo360VRViewController`, so `AlbumItemsViewController`, that is written in Swift, can launch them.


## Talk to Me

Visit my [LinkedIn](https://www.linkedin.com/in/lilohass) to leave feedback and connect.

## Author

William Marques Hass

## License

See the **LICENSE** file for more info.