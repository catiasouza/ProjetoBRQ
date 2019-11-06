//
//  ExtratoTableViewCell.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ExtratoTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelLancamentos: UILabel!
    @IBOutlet weak var labelDatas: UILabel!
    @IBOutlet weak var labelValores: UILabel!
    
    
    //MARK: - Métodos
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
