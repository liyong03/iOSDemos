// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var dd:Dictionary<Int,Int> = Dictionary<Int,Int>()
dd[1] = 2


func memoize<U:Hashable,T>(compute:((U)->T, U)->T) -> (U)->T {
  var dict:Dictionary<U,T> = Dictionary<U,T>()
  var result:((U)->T)!
  result = {
    i in
    if let v = dict[i] {
      return v
    } else {
      let newV = compute(result, i)
      dict[i] = newV
      return newV
    }
  }
  
  return result
}

let fibonacci = memoize {
  fibonacci, i in
  i < 2 ? Double(i) : (fibonacci(i-1) + fibonacci(i-2))
}

let phi = fibonacci(45)/fibonacci(44)
println("\(phi)")


