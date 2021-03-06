//
//  SudokuCell.swift
//  RediSudoku
//
//  Created by MAD-06 on 23.04.19.
//  Copyright © 2019 ReDI School. All rights reserved.
//

import UIKit

class SudokuCell: UICollectionViewCell {
    
    
    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            toolbar.tintColor = .rediOrange
            let spacingLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
            toolbar.items = [spacingLeft, doneButton]
            inputTextField.inputAccessoryView = toolbar
        }
    }
    private let borderColor = UIColor.rediBlue.cgColor
    
    private var borders = [CALayer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = borderColor.copy(alpha: 0.3)
        contentView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        borders.forEach({$0.removeFromSuperlayer()})
        borders.removeAll()
        inputTextField.text = nil
    }
    
    @objc func doneButtonTapped() {
        inputTextField.resignFirstResponder()
    }
    
    func applyBorders(edges: [UIRectEdge]) {
        
        if edges.contains(.bottom) {
            
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1)
            layer.backgroundColor = borderColor
            borders.append(layer)
        }
        if edges.contains(.top) {
            
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 1)
            layer.backgroundColor = borderColor
            borders.append(layer)
        }
        if edges.contains(.left) {
            
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: 1, height: self.bounds.height)
            layer.backgroundColor = borderColor
            borders.append(layer)
        }
        if edges.contains(.right) {
            
            let layer = CALayer()
            layer.frame = CGRect(x: self.bounds.width - 1, y: 0, width: 1, height: self.bounds.width)
            layer.backgroundColor = borderColor
            borders.append(layer)
        }
        
        borders.forEach({ self.layer.addSublayer($0) })
    }
    
}
