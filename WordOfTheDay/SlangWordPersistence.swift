//
//  WordPersistence.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 16/03/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import Foundation
import TwitterKit

private let SingletonSharedInstance = SlangWordPersistence()

public class SlangWordPersistence {
    
    private let userDefaultsKey = "wotd.slangwords.\(Twitter.sharedInstance().session()!.userID)"
    
    
    class var sharedInstance : SlangWordPersistence {
        return SingletonSharedInstance
    }
    
    // MARK: Word Persistence Utilities
    
    func persistWord(slangWord: SlangWord) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var slangWords: [SlangWord]
        if let wordsArchieved: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            slangWords = NSKeyedUnarchiver.unarchiveObjectWithData(wordsArchieved as! NSData) as! [SlangWord]
        } else {
            slangWords = []
        }
        slangWords.insert(slangWord, atIndex: 0)
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(slangWords), forKey: userDefaultsKey)
    }
    
    func removeWord(slangWord: SlangWord) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var slangWords: [SlangWord]
        if let wordsArchieved: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            slangWords = NSKeyedUnarchiver.unarchiveObjectWithData(wordsArchieved as! NSData) as! [SlangWord]
        } else {
            slangWords = []
        }
        
        for (index, word) in slangWords.enumerate() {
            if slangWord.word == word.word || slangWord === word {
                slangWords.removeAtIndex(index)
                break
            }
        }
        
        overWriteWords(slangWords)
    }
    
    func overWriteWords(words: [SlangWord]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(words), forKey: userDefaultsKey)
    }
    
    func retrieveWords() -> [SlangWord] {
        var words: [SlangWord]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let wordsArchieved: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            words = NSKeyedUnarchiver.unarchiveObjectWithData(wordsArchieved as! NSData) as! [SlangWord]
        } else {
            words = []
        }
        return words
    }
    
}