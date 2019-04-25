//
//  SudokuCell.swift
//  RediSudoku
//
//  Created by MAD-06 on 23.04.19.
//  Copyright © 2019 RaDI School. All rights reserved.
//

import UIKit

class SudokuCell: UICollectionViewCell {
    
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        contentView.layer.borderWidth = 1
    }
    
}
