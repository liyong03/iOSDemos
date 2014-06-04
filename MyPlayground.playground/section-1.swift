// Playground - noun: a place where people can play

import Cocoa

var dic = [
    "name" : "yong li",
    "age" : 18
]

for (key : AnyObject, val : AnyObject) in dic {
    println("key = \(key), val = \(val)")
}

enum Thing {
    case house(String)
    case car(String)
    case bike
}

var t:Thing = .house("汗血宝马")

switch t {
case let .house(h):
    println("house \(h)")
case let .car(c):
    println("car \(c)")
default:
    println("nothing")
}

var arry = [1,2,3]
arry += 4