//
//  CelulaTableViewCell.swift
//  DesafioSantander
//
//  Created by Caio Araujo Mariano on 26/10/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

class CelulaTableViewCell: UITableViewCell {

    //MARK: -Outlets
    
    @IBOutlet weak var labelTitulo: UILabel!
    
    @IBOutlet weak var labelDescricao: UILabel!
    
    @IBOutlet weak var labelData: UILabel!
    
    @IBOutlet weak var labelPagamento: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
