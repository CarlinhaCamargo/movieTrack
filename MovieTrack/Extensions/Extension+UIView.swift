//
//  Extension+UIView.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 04/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerRadius(ratio: CGFloat) {
        self.layer.cornerRadius = ratio
        self.clipsToBounds = true
    }
    
    func setShadow(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5

    }
    func createGradient(){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        self.layer.insertSublayer(gradient, at: 1)
    }
    
    
    
}
