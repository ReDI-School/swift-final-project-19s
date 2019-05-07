//
//  ViewController.swift
//  RediSudoku
//
//  Created by mad-11 on 23.04.19.
//  Copyright © 2019 ReDI School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var finishedGameContainer: UIView! {
        didSet {
            finishedGameContainer.alpha = 0
        }
    }
    
    @IBOutlet weak var finishedGameLabel: UILabel! {
        didSet {
            finishedGameLabel.textColor = .rediBlue
        }
    }
    
    @IBOutlet weak var playAgainButton: UIButton! {
        didSet {
            playAgainButton.tintColor = .rediOrange
        }
    }
    let initialCellValues: [Int: Int] = [
        2: 4,
        3: 2,
        7: 9,
        10: 2,
        13: 4,
        15: 3,
        18: 9,
        21: 1,
        25: 8,
        36: 6,
        37: 8,
        38: 1,
        39: 3,
        31: 7,
        35: 6,
        43: 4,
        44: 7,
        45: 5,
        46: 7,
        49: 2,
        50: 4,
        52: 1,
        53: 3,
        59: 3,
        60: 5,
        63: 4,
        64: 3,
        65: 8,
        66: 5,
        68: 2,
        70: 7,
        73: 5,
        74: 7,
        75: 4,
        77: 9,
        78: 6
    ]
    
    // For each value in the interval 0 to 8, create a SubsQuare using it's initializer. Have a look at the SubSquare struct for more info.
    let subSquares = (0...8).map { SubSquare(squareIndex: $0) }
    
    lazy var currentCellValues: [Int: Int] = initialCellValues
    
    func highlightCells(atIndexes indexes: [Int], withColor color: UIColor, ifValueIs matchingValue: Int) {
        
        for index in indexes {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? SudokuCell
            guard currentCellValues[index] == matchingValue else { continue }
            
            UIView.animate(withDuration: 0.15, animations: {
                // Animate changing the color to rediBlue
                cell?.contentView.backgroundColor = color
            }) { completed in
                // When finished, animate it back to white
                UIView.animate(withDuration: 0.6, animations: {
                    cell?.contentView.backgroundColor = .white
                })
            }
        }
    }
    
    func isNumber(_ number: Int, validInGroup numbersGroup: [Int]) -> Bool {
        return !numbersGroup.contains(number)
    }
    
    
    func getRow(for index: Int) -> [Int: Int] {
        let rowNumber = index / 9

        let keyValuePairsInCurrentRow = currentCellValues.filter{ keyValuePair
            in keyValuePair.key / 9 == rowNumber
        }
        
        return keyValuePairsInCurrentRow
    }
    
    func getColumn(for index: Int) -> [Int: Int] {
        let columnNumber = index % 9
        
        let keyValuePairsInCurrentColumn = currentCellValues.filter{ keyValuePair
            in keyValuePair.key % 9 == columnNumber
        }
        
        return keyValuePairsInCurrentColumn
    }
    
    func getSubSquare(for index: Int) -> [Int: Int] {
        for square in subSquares where square.indexes.contains(index) {
            let subSquareIndexes = square.indexes
            return currentCellValues.filter { subSquareIndexes.contains($0.key) }
        }
        return [:]
    }
    
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        // Reset values to original ones and reload collection view
        self.currentCellValues = self.initialCellValues
        self.collectionView.reloadData()
        
        UIView.animate(withDuration: 1) {
            self.finishedGameContainer.alpha = 0
            self.collectionView.alpha = 1
        }
    }
    
    func finishGame() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.collectionView.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                // Show finished game container
                self.finishedGameContainer.alpha = 1
            })
            
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
        cell.inputTextField.tintColor = .rediBlue
        cell.inputTextField.delegate = self
        cell.inputTextField.tag = indexPath.row
        
        if let value = currentCellValues[indexPath.item] {
            cell.inputTextField.text = String(value)
            cell.inputTextField.isEnabled = false
            cell.inputTextField.font = UIFont.boldSystemFont(ofSize: 22)
        }
        
        if ((indexPath.item + 1) % 3 == 0) {
            cell.applyBorders(edges: [UIRectEdge.right])
        }
        
        if (indexPath.item % 9 == 0) {
            cell.applyBorders(edges: [UIRectEdge.left])
        }
        
        if (indexPath.item / 9 % 3 == 2) {
            cell.applyBorders(edges: [UIRectEdge.bottom])
        }
        
        if (indexPath.item < 9) {
            cell.applyBorders(edges: [UIRectEdge.top])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 9
        return CGSize(width: width, height: width)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .rediBlue
        textField.text = ""
        currentCellValues.removeValue(forKey: textField.tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        let tag = textField.tag
        
        if let textFieldValue = Int(text) {
            let row = getRow(for: tag)
            let column = getColumn(for: tag)
            let subSquare = getSubSquare(for: tag)
            
            let isNumberValidInRow = isNumber(textFieldValue, validInGroup: Array(row.values) )
            let isNumberValidInColumn = isNumber(textFieldValue, validInGroup: Array(column.values) )
            let isNumberValidInSubSquare = isNumber(textFieldValue, validInGroup: Array(subSquare.values) )
            
            if isNumberValidInRow && isNumberValidInColumn && isNumberValidInSubSquare {
                currentCellValues[textField.tag] = textFieldValue
                print("Added a new value! \(textFieldValue)")
                // Finish game once all numbers are written
                if currentCellValues.count == collectionView.numberOfItems(inSection: 0) {
                    finishGame()
                }
            } else {
                textField.textColor = .rediOrange
            }
            
            if !isNumberValidInRow {
                // Find all cells in row with same value and highlight them
                highlightCells(atIndexes: Array(row.keys), withColor: .rediOrange, ifValueIs: textFieldValue)
            }
            
            if !isNumberValidInColumn {
                // Find all cells in row with same value and highlight them
                highlightCells(atIndexes: Array(column.keys), withColor: .rediOrange, ifValueIs: textFieldValue)
            }
            
            if !isNumberValidInSubSquare {
                // Find all cells in subSquare with same value and highlight them
                highlightCells(atIndexes: Array(subSquare.keys), withColor: .rediOrange, ifValueIs: textFieldValue)
            }
            
        } else {
            textField.textColor = .rediOrange
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 1 {
            return false
        }
        
        let isInputAValidNumber = Int(string) != nil && Int(string) != 0
        
        let textFieldHasNoCharacters = textField.text?.count == 0
        let noCharactersAndValidNumber = textFieldHasNoCharacters && isInputAValidNumber
        if noCharactersAndValidNumber || string.isEmpty {
            
            return true
        } else {
            return false
        }
    }
}

