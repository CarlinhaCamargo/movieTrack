//
//  listViewCell.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 04/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import UIKit
import CoreData

class ListViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backgroundPoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.cornerRadius(ratio: 12.0)
        self.cardView.setShadow()
        self.blurView.createGradient()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    func configCell(_ movie: NSManagedObject) {
        
        self.movieTitle.text = movie.value(forKeyPath: "name") as? String
        self.likeButton.setImage(#imageLiteral(resourceName: "icon-heart-filled"), for: .normal)
        
        RequestManager().getImageByURL(movie.value(forKeyPath: "banner") as! String) { (image) in
             self.backgroundPoster.image = image
        }
    }
    
    func configCell(_ movie: SearchItemDTO) {
        
        self.movieTitle.text = movie.title
        self.likeButton.setImage(#imageLiteral(resourceName: "icon-heart"), for: .normal)
        self.backgroundPoster.image = #imageLiteral(resourceName: "icon-claquette")   // to solve the cache problem
        RequestManager().getImageByURL(movie.poster!) { (image) in
            self.backgroundPoster.image = image
        }
    }
    
}
