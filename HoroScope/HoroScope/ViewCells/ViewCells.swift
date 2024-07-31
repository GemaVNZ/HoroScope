//
//  ViewCells.swift
//  HoroScope
//
//  Created by Mañanas on 29/7/24.
//

import Foundation
import UIKit

class HoroscopeViewCell: UITableViewCell {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
   
    @IBOutlet weak var nameLabel: UILabel!
    

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func render(horoscope: Horoscope) {
        nameLabel.text = horoscope.name
        dateLabel.text = horoscope.dates
        logoImageView.image = horoscope.logo
        
        let favoriteHoroscope = UserDefaults.standard.string(forKey: "FAVORITE_HOROSCOPE") ?? ""
        let isFavorite = horoscope.id == favoriteHoroscope
        
        favoriteImageView.isHidden = !isFavorite
    }
}
    

