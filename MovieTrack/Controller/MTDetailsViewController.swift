//
//  MTDetailsViewController.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 04/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import UIKit


/**  MTDetailsViewController.swift
    Controls all views and services call's to show detailed info of any selected movie.
 */
class MTDetailsViewController: MTBaseViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var rateValueLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    var movieID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMovieInfo()
        self.setupLayout()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupLayout(){
        self.blurView.createGradient()
        
    }
    
    /**
        Receives the info about selected movie
     
        - important: the movieID must have been initialized when pushing the screen.
     
     */
    func getMovieInfo() {
        
        RequestManager().requestMovieBy(id: movieID ?? "", completionSucess: { (result) in
            self.loadInfo(result)
        }, completionError: { (error) in
            
        })
    }
    
    /**
        Fill the info in the screen
        - parameters:
            - movie: the object that contains all info about the movie selected
     */
    func loadInfo(_ movie: MovieDTO){
        guard
            let title = movie.title,
            let rate = movie.imdbRating,
            let year = movie.year,
            let desc = movie.plot,
            let img = movie.poster
        else{
            return
        }
        
        
        self.movieTitleLabel.text = title
        self.rateValueLabel.text = rate + "/10"    //: # was made a choice here to show always de imdbRating.
        self.movieYearLabel.text = year
        self.longDescriptionLabel.text = desc
        
        /**
         1. assync call to fill imageView
         */
        self.bannerImageView.image = #imageLiteral(resourceName: "icon-claquette")  // to solve the cache problem
        RequestManager().getImageByURL(img) { (image) in
             self.bannerImageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
