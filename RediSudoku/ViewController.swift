//
//  ViewController.swift
//  RediSudoku
//
//  Created by mad-11 on 23.04.19.
//  Copyright © 2019 RaDI School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var cellValues: [Int: Int] = [:]
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
        cell.inputTextField.delegate = self
        
//        cell.inputTextField.text = String(indexPath.item)
        
        if let value = cellValues[indexPath.item] {
            cell.inputTextField.text = String(value)
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

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cellValues = [
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
            78: 6,
            80: 0
        ]
        
        
        
    }
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 1 {
            return false
        }
        
        let isInputAValidNumber = Int(string) != nil && Int(string) != 0
        
//        let validCharacters = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
//        let isInputValid = validCharacters.contains(string)
        let textFieldHasNoCharacters = textField.text?.count == 0
        let noCharactersAndValidNumber = textFieldHasNoCharacters && isInputAValidNumber
        if noCharactersAndValidNumber || string.isEmpty {
            
            return true
        } else {
            return false
        }
    }
}

