# My360VRPlayer for iOS



## Setting Up

This project uses `cocoapods` to manage libraries dependencies. Although either checking in libraries files or not is fine, this project does not include the libraries folder due to the fact that one of the files is bigger than the size limit GitHub allows.

[Library file size discussion](https://github.com/googlevr/gvr-ios-sdk/issues/202)

To get started with this project

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
	- `AlbumViewModel`
	- `AlbunsDataSet`
* UI
	- `AlbumCollectionViewCell`
	- `AlbumCollectionViewHeader`
	- `AlbunsViewController`
* Protocols
	- `AlbunsUserInterfaceProtocol`
	- `AlbunsUserInterfaceEventHandler`
	- `AlbunsInteractorProtocol`
	- `AlbunsDataSetProtocol`


## Talk to Me

Visit my [LinkedIn](https://www.linkedin.com/in/lilohass) to leave feedback and connect.

## Author

William Marques Hass

## License

See the **LICENSE** file for more info.