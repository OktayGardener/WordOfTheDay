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
    
    init(id: Int, udpermalink: String, word: String, definition: String, example: String) {
        self.id = id
        self.udpermalink = udpermalink
        self.word = word
        self.definition = definition
        self.example = example
        self.date = NSDate()
    }

}