//
//  SlangWord.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 01/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import Foundation

public class SlangWord: NSObject, NSCoding {
    private struct SerializationKeys {
        static let id = "id"
        static let udpermalink = "udpermalink"
        static let word = "word"
        static let definition = "definition"
        static let example = "example"
        static let date = "date"
    }
    
    
    public var id: Int
    public var udpermalink: String = ""
    public var word: String = ""
    public var definition: String = ""
    public var example: String = ""
    public var date = NSDate()
    
    public private(set) var UUID = NSUUID()

    
    
    public init(id: Int, udpermalink: String, word: String, definition: String, example: String) {
        self.id = id
        self.udpermalink = udpermalink
        self.word = word
        self.definition = definition
        self.example = example
        self.date = NSDate()
        self.UUID = NSUUID()
    }

    
    required public init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey(SerializationKeys.id) as! Int
        udpermalink = aDecoder.decodeObjectForKey(SerializationKeys.udpermalink) as! String
        word = aDecoder.decodeObjectForKey(SerializationKeys.word) as! String
        definition = aDecoder.decodeObjectForKey(SerializationKeys.definition) as! String
        example = aDecoder.decodeObjectForKey(SerializationKeys.example) as! String
        date = aDecoder.decodeObjectForKey(SerializationKeys.date) as! NSDate
        
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: SerializationKeys.id)
        aCoder.encodeObject(udpermalink, forKey: SerializationKeys.udpermalink)
        aCoder.encodeObject(word, forKey: SerializationKeys.word)
        aCoder.encodeObject(definition, forKey: SerializationKeys.definition)
        aCoder.encodeObject(example, forKey: SerializationKeys.example)
        aCoder.encodeObject(date, forKey: SerializationKeys.date)
    }
}