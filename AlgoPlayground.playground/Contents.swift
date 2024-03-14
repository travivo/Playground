import UIKit

/*
 This Swift function, getLargestBinaryGap, calculates the length of the largest binary gap in the binary representation of a given integer.
*/

func getLargestBinaryGap(number: Int) -> Int {
    
    // Convert to binary string
    let str = String(number, radix: 2)
    
    // Create custom character set
    var characterSet = CharacterSet.whitespacesAndNewlines
    characterSet.insert(charactersIn: "0")
    
    // Trim the binary string, remove 0 at start and end of the string
    let trimmedStr = str.trimmingCharacters(in: characterSet)
    
    // Create array of binary gaps and sort by the length
    let arrayOfGaps = trimmedStr.components(separatedBy: "1").filter({!$0.isEmpty})
    let arrayOfGapsSorted = arrayOfGaps.sorted { gap1, gap2 in
        return gap1.count > gap2.count
    }
    
    // Return zero if no array is created
    guard (arrayOfGapsSorted.count != 0) else {
        return 0
    }
    
    // The fisrt item on the list should be the largest binary gap
    return  arrayOfGapsSorted[0].count
}

getLargestBinaryGap(number: 89898)



/*
 This Swift function, FirstFactorial, calculates the factorial of a given integer num.
 
 This function effectively computes the factorial of the input number by multiplying all the integers from num down to 1.
 */
func firstFactorial(_ num: Int) -> Int {

  var factorial = 1
  for index in stride(from:num, through:1, by:-1) {
    factorial = factorial*index
  }
  return factorial
}

firstFactorial(10)
