//
//  RequestManager.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 03/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AlamofireImage

class RequestManager: NSObject {
    
    //MARK: urls
    
    /**
     Access the file with all the urls from the server.
     
     -parameters:
        -term: the string key in the URLs.plist file
        
     */
    func propertyListAccess(term: String) -> String {
        let path = Bundle.main.path(forResource: R.file.urLsPlist.name, ofType: R.file.urLsPlist.pathExtension)
        let infoDict =  NSDictionary(contentsOfFile: path ?? "")
        return infoDict?[term] as! String
    }
    
    func baseURL() -> String {
        return propertyListAccess(term: R.string.localizable.baseURLValue())
    }

    func apiKey() -> String {
        return R.string.localizable.apikeyName() + propertyListAccess(term: R.string.localizable.apikeyValue())
        
    }
    
    /**
        Returns the correct URL with all the necessary items to execute the call in the server
     
     -parameters:
        -id: the imdbID to be searched
     
     It'll insert special characters in the string to create the URL
     (GET MOVIE)
     */
    func getURLMovieBy(id: String) -> URL {
        var url = baseURL() + "?" + apiKey() + "&" + propertyListAccess(term: R.string.localizable.getMovieByID())
        url = url.replacingOccurrences(of: R.string.localizable.idMarker(), with: id)
        return URL.init(string: url)!
    }
    /**
     Returns the correct URL with all the necessary items to execute the call in the server
     
     -parameters:
     -term: the string to be searched
     
     It'll insert special characters in the string to create the URL
     (SEARCH)
     */
    func getURLSearchByTerm(_ term: String) -> URL {
        
        var url = baseURL() + "?" + apiKey() + "&" + propertyListAccess(term: R.string.localizable.movieSearch())
        url = url.replacingOccurrences(of: R.string.localizable.termMarker(), with: term)
        url = url.replacingOccurrences(of: " ", with: "+")
        return URL.init(string: url)!
    }
    
    //MARK: - Request calls
    
    // to get things done quickly, I choose to use ALAMOFIRE to handle all network and request overhead.
    /**
        Search in the server for any movie that contains the term sent.
     
        -parameters:
            - term: string to be searched
            - completionSuccess: gives the result from the assync call
            - completionError: gives the Error from the assync call
     Uses the extension AlamofireObject
     */
    func requestMovieByTerm(_ term: String, completionSucess: @escaping (_ result: SearchDTO) -> Void, completionError: @escaping (_ error: Error) -> Void) {
        
        let url = self.getURLSearchByTerm(term)
        Alamofire.request(url).responseObject { (response: DataResponse<SearchDTO>) in
            
            if let result = response.result.value {
                completionSucess(result)
            } else {
                completionError(response.error!)
            }
            
        }
    }

    /**
     Search in the server for the movie that has the imdbID sent.
     
     -parameters:
        - id: string imdbID to be searched
        - completionSuccess: gives the result from the assync call
        - completionError: gives the Error from the assync call
     
     Uses the extension AlamofireObjectMapper
     */
    func requestMovieBy(id: String, completionSucess: @escaping (_ result: MovieDTO) -> Void, completionError: @escaping (_ error: Error) -> Void) {
        
        let url = self.getURLMovieBy(id: id)
        Alamofire.request(url).responseObject { (response: DataResponse<MovieDTO>) in
            
            if let result = response.result.value {
                completionSucess(result)
            } else {
                completionError(response.error!)
            }
        }
    }
    /**
     Gets the proper image with the given url from the server.
     
     -parameters:
        - url: string containing the url address of the image searched
        - handler: gives the image resulting from the assync call
     
     Uses the extension AlamofireImage
     */
    func getImageByURL(_ url: String, handler: @escaping (_ result: UIImage) -> Void) {
        
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                handler(image)
            }
        }
    }
}
