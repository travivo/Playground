/*
This Swift function, named solution, takes an integer num as input and returns an integer as output.

Here's a breakdown of what the function does:

1. It first checks if the input number num is greater than 0. If it's not greater than 0, it immediately returns 0.

2. If num is greater than 0, it proceeds with the following steps:
- It creates an array called numList containing integers from 1 to num - 1.
- It filters numList to find all multiples of 3 and stores them in multiplesOfThree.
- It removes multiples of 3 from numList by creating a set from numList and subtracting multiplesOfThree. The resulting array is then reassigned to numList.
- It filters numList again to find all multiples of 5 and stores them in multiplesOfFive.
- It calculates the sum of all elements in multiplesOfThree and multiplesOfFive using the reduce method.
- Finally, it returns the sum.

 So, in summary, this function calculates the sum of all multiples of 3 and 5 that are less than the input number num, excluding any numbers that are multiples of both 3 and 5 (i.e., multiples of 15). If num is not greater than 0, it returns 0.
*/
func solution(_ num: Int) -> Int {
  
  if num > 0 {

    var numList = Array(1...num-1)
    
    let multiplesOfThree = numList.filter{$0 % 3 == 0}

    numList = Array(Set(numList).subtracting(multiplesOfThree))

    let multiplesOfFive = numList.filter{$0 % 5 == 0}

    let sum = multiplesOfThree.reduce(0, +) + multiplesOfFive.reduce(0, +)

    return sum
  }
  
  return 0
  
}
