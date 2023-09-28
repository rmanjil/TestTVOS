//
//  ViewController.swift
//  TestTVOS
//
//  Created by manjil rajbhandari on 28/09/2023.
//

import UIKit
import AVKit

class ViewController: UIViewController {
   var isFavorited = false
    var avPlayer: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")  {
            let playerItem = AVPlayerItem(url: url)
            playerItem.externalMetadata = createMetadataItems()
             avPlayer = AVPlayer(playerItem: playerItem)
            let controller = AVPlayerViewController()
            controller.player = avPlayer
            controller.view.backgroundColor = .yellow
            controller.transportBarCustomMenuItems = [createFavoriteAction(), createMenu()]
            present(controller, animated: true) {
                //avPlayer.play()
            }
            avPlayer.play()
            let bonusContentViewController = UIViewController()
            bonusContentViewController.view.backgroundColor = .red
            bonusContentViewController.title = "Bonus"
            let relatedContentViewController = UIViewController()
            relatedContentViewController.view.backgroundColor = .blue
            relatedContentViewController.title = "Related"
            controller.customInfoViewControllers = [
                bonusContentViewController,
                relatedContentViewController
            ]


        }
    }
   
    func createMetadataItems() -> [AVMetadataItem] {
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: "Big Buck Bunny",
            .iTunesMetadataTrackSubTitle: "Big Buck Bunny Short",
          //  .commonIdentifierArtwork: UIImage(named: metadata.image)?.pngData() as Any,
            .commonIdentifierDescription: "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
            //.iTunesMetadataContentRating: metadata.rating,
            //.quickTimeMetadataGenre: metadata.genre
        ]
        return mapping.compactMap { createMetadataItem(for:$0, value:$1) }
    }


    private func createMetadataItem(for identifier: AVMetadataIdentifier,
                                    value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        // Specify "und" to indicate an undefined language.
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }
    
    private func createFavoriteAction() -> UIAction {
        let heartImage = UIImage(systemName: "heart")
        let heartFillImage = UIImage(systemName: "heart.fill")


        // Create an action to add the item to the viewer's favorites.
        let stateImage = isFavorited ? heartFillImage : heartImage
         return UIAction(title: "Favorites",
                                      image: stateImage) { [weak self] action in
            guard let self else { return }
            // Add the movie to or remove it from the viewer's favorites list.
            self.isFavorited.toggle()
            
            // Update the button image to reflect the new state.
            action.image = isFavorited ? heartFillImage : heartImage
        }

    }
    
    private func createMenu() -> UIMenu {
        let loopImage = UIImage(systemName: "infinity")
        let gearImage = UIImage(systemName: "gearshape")


        // Create an action to enable looping playback.
        let loopAction = UIAction(title: "Loop", image: loopImage, state: .off) { action in
            action.state = (action.state == .off) ? .on : .off
        }


        let speedActions = ["Half": 0.5, "Default": 1.0, "Double": 2.0].map { title, value in
            UIAction(title: title, state: self.avPlayer.rate == value ? .on : .off) { [weak self] action in
                // Update the current playback speed.
                self?.avPlayer.rate = value
                action.state = .on
            }
        }


        // Create the submenu.
        let submenu = UIMenu(title: "Speed",
                             options: [.displayInline, .singleSelection],
                             children: speedActions)


        // Create the main menu.
        return UIMenu(title: "Preferences", image: gearImage, children: [loopAction, submenu])
    }

}

