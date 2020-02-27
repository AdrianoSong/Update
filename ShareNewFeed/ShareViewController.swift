//
//  ShareViewController.swift
//  ShareNewFeed
//
//  Created by Lucas Farah on 2/13/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    private var url: NSURL?
    var shareFeedViewController: UIHostingController<ShareNewFeedView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareFeedViewController = UIHostingController(rootView: ShareNewFeedView())
        shareFeedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        shareFeedViewController.view.frame = self.view.bounds
        shareFeedViewController.rootView.shouldDismiss = {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
        
        self.view.addSubview(shareFeedViewController.view)
        self.addChild(shareFeedViewController)
        getURL()
    }
    
    private func getURL() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first
        let propertyList = String(kUTTypePropertyList)
        if itemProvider?.hasItemConformingToTypeIdentifier(propertyList) ?? false {
            itemProvider?.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let feeds = results["Feeds"] as? [String],
                        let url = results["URL"] as? String {
                        if url.split(separator: "/").count >= 4 {
                            self.shareFeedViewController.rootView.type = .addReadItLater(url: url)
                        } else {
                            self.shareFeedViewController.rootView.type = .addFeed(urls: feeds)
                        }
                    }
                }
            })
        } else {
            print("error")
            
            
            guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
                return
            }

            for extensionItem in extensionItems {
                if let itemProviders = extensionItem.attachments {
                    for itemProvider in itemProviders {
                        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {

                            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { text, error in
                                guard let url = text as? URL else { return }
                                self.shareFeedViewController.rootView.type = .addReadItLater(url: url.absoluteString)
                            })
                        }
                    }
                }
            }
        }
    }

}
