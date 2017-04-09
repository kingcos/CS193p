//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by 买明 on 08/04/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        
        updateDatabase(with: newTweets)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("Starting database load")
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("Done loading database")
            self?.printDatabaseStatistics()
        }
    }

    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("isMainThread")
                } else {
                    print("is NOT MainThread")
                }
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count {
                    print("\(tweetCount) tweet(s)")
                }
                if let twitterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(twitterCount) Twitter user(s)")
                }
            }
        }
    }
}
