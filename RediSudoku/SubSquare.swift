//
//  SubSquare.swift
//  RediSudoku
//
//  Created on 06.05.19.
//  Copyright © 2019 ReDI School. All rights reserved.
//

import Foundation

struct SubSquare {
    let indexes: [Int]
    
    /// First square should have index 0
    init(squareIndex: Int) {
        let columnNumber = squareIndex % 3 // times to move right
        let lineNumber = squareIndex / 3 // times to move down
        indexes = baseValues.movedRight(times: columnNumber).movedDown(times: lineNumber)
    }
}

/// Values for first square
private let baseValues = [0,1,2,9,10,11,18,19,20]

// fileprivate means "just within this Swift file".
// Add the following functions to all arrays of Integers
fileprivate extension Array where Iterator.Element == Int {
    
    func movedRight(times: Int) -> [Int] {
        return self.map { $0 + 3 * times }
    }
    
    func movedDown(times: Int) -> [Int] {
        return self.map { $0 + 27 * times }
    }
}
