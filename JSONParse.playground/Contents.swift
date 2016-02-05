//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let file = "~/Users/oktaygardener/Documents/dev/WordOfTheDay/WordOfTheDay/JSON/ud_response.JSON" //this is the file. we will write to and read from it

let text = "some text" //just a text

if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
    let path = dir.stringByAppendingPathComponent(file);

    //reading
    do {
        let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        print(text2)
    }
    catch { print("not found") }
}