package main

import "C"
//export person
type person struct {
    name string
    age  int
}

//export add
func add(a int, b int) int {
  return a + b
}

//export subtract
func subtract(a, b int) int {
  return a - b
}

func age_diff(a person, b person) int {
  return a.age - b.age
}

func main() {}
