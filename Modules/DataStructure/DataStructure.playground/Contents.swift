//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

class test: NSObject {
    
    var prop:String = {
        return "a"
    }()
    
}

var t = test()

t.prop


let dict = ["a","b"]

let a = dict.map({
    return $0
})