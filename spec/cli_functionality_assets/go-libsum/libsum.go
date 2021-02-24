package main

import "C"

//export add
func add(a int, b int) int {
  return a + b
}

//export subtract
func subtract(a, b int) int {
  return a - b
}

func main() {}
