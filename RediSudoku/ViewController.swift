//
//  ViewController.swift
//  RediSudoku
//
//  Created by mad-11 on 23.04.19.
//  Copyright © 2019 RaDI School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
        
        cell.inputTextField.delegate = self
        
        cell.inputTextField.text = "\(indexPath.row)"
        var edges: [UIRectEdge] = []
        if indexPath.row % 9 == 0 {
            
            edges.append(.left)
        }
        if indexPath.row % 3 == 2 {
            
            edges.append(.right)
        }
        if (indexPath.row / 9) % 3 == 2 {
            
            edges.append(.bottom)
        }
        if indexPath.row < 9 {

            edges.append(.top)
        }
        
        cell.applyBorders(edges: edges)
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

