//
//  WordPersistence.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 16/03/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import Foundation

private let SingletonSharedInstance = WordPersistence()

public class WordPersistence {
    
    private let userDefaultsKey = "wotd.words"
    
    class var sharedInstance : WordPersistence {
        return SingletonSharedInstance
    }
    
    // MARK: Poem Persistence Utilities
    
    // Save a new poem.
    
    func persistWord(word: SlangWord) {
        
    }
    
    func persistPoem(poem: Poem) {
        // Retrieve the currently saved poems.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var poems: [Poem]
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            poems = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as! NSData) as! [Poem]
        } else {
            poems = []
        }
        
        // Append the newly created poem.
        poems.insert(poem, atIndex: 0)
        
        // Save the poems.
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(poems), forKey: userDefaultsKey)
    }
    
    // Overwrite the poems.
    func overwritePoems(poems: [Poem]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(poems), forKey: userDefaultsKey)
    }
    
    // Retrieve the poems.
    func retrievePoems()  -> [Poem] {
        var poems: [Poem]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            poems = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as! NSData) as! [Poem]
        } else {
            poems = []
        }
        return poems
    }
    
}