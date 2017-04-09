//
//  TwitterUser.swift
//  Smashtag
//
//  Created by 买明 on 08/04/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TwitterUser: NSManagedObject {
    class func findOrCreateTwitterUser(matching twitterInfo: Twitter.User, in context: NSManagedObjectContext) throws -> TwitterUser {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUser.\(#function) - Database inconsistency.")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let twitterUser = TwitterUser(context: context)
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        
        return twitterUser
    }
}
