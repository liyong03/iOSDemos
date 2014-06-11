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

let t:Thing = .house("汗血宝马")

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

var a = 1;
a += Int(2.0)

let c = "a"
var names = ["yongli", "jingyan", "2"]
names += "3"
var dic2:Dictionary<String, Int> = ["sfsdf" : 2, "sdfsdf" : 3]
let v = dic2["sfsdf"]!
let v2 = 2
var num: Int? = nil
num = 3

if let _v = dic2["sfsdf"] {
  println("have \(_v)")
} else {
  println("not have")
}

func saySth() -> String? {
  return "顺利发送旅客短斤少两"
}

let sss = saySth()

var range = Range(start: 0,end: 10)
for i in range {
    println("\(i)")
}
