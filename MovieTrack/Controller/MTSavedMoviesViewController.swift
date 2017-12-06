 //
//  MTSavedMoviesViewController.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 04/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class MTSavedMoviesViewController: MTBaseViewController {
 
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController?
   
    var savedMovies: [NSManagedObject] = []
    var searchedMovies: SearchDTO = SearchDTO()!
    var datasource: [String] = []
    
    var dismissSearch = false
    
    /**
     The refreshControl will update only the local base
     */
    lazy var refreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMovies()
        self.setupLayout()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        setupSearch()
    }
    
    func setupLayout() {
        
        //register the generic nib to be used in this tableView
        tableView.register(R.nib.listCell(), forCellReuseIdentifier: R.reuseIdentifier.listCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        //refreshControl in ios10 is a property of tableView and CollectionView
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    
    }
    func loadMovies(){
        //gets the managedContext to get the model
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //get all the info in the entityMovie
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: R.string.localizable.entityMovieName())
        
        do {
            //try to fetch the info from the entity and if that works we have an array of tuples containing the movies saved info.
            savedMovies = try managedContext.fetch(fetchRequest)
            //we have to update the tableView with the savedMovies
            tableView.reloadData()
        } catch let error as NSError {
            print(R.string.localizable.errorFetching() + "\(error), \(error.userInfo)")
            
        }
    
    }
    
    func  likeMovie(tag: Int){//to be used in the search
        //now we will save a new movie to the entityModel.
        
        //saving info with CoreData
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //gets app's managedContext
        let entity = NSEntityDescription.entity(forEntityName: R.string.localizable.entityMovieName(), in: managedContext)!
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let item = searchedMovies.searchResult?[tag]
        //saving the info from the search items
        movie.setValue(item?.imdbID, forKeyPath: R.string.localizable.entityAttributeID())
        movie.setValue(item?.poster, forKeyPath: R.string.localizable.entityAttributeBanner())
        movie.setValue(item?.title, forKeyPath: R.string.localizable.entityAttributeName())
        
        do {
            try managedContext.save()
            //saving to the coreData managed Context
            savedMovies.append(movie)
        } catch let error as NSError {
            print(R.string.localizable.errorSaving() + " \(error), \(error.userInfo)")
        }
        
    }
    func dislikeMovie(tag: Int) {
        //we need to get the managedContext to delete the correct item.
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.delete(savedMovies[tag])
        //update the datasource correct
        if !isFiltering() {
            savedMovies.remove(at: tag)
        }else{
            searchedMovies.searchResult?.remove(at: tag)
        }
        //updating the tableview
        tableView.reloadData()
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        //when heart button is clicked we need to take action
        if sender.image(for: .normal) == #imageLiteral(resourceName: "icon-heart") {  //not liked yet
            sender.setImage(#imageLiteral(resourceName: "icon-heart-filled"), for: .normal)
            likeMovie(tag: sender.tag)
            
        } else {
            sender.setImage(#imageLiteral(resourceName: "icon-heart"), for: .normal)
            dislikeMovie(tag: sender.tag)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as? IndexPath
        let item: AnyObject?
        let dest = segue.destination as? MTDetailsViewController
        if isFiltering() {
            item = searchedMovies.searchResult?[indexPath?.row ?? 0 ]
            dest?.movieID = (item as? SearchItemDTO)?.imdbID
        } else {
            item = savedMovies[indexPath?.row ?? 0]
            dest?.movieID = (item as? NSManagedObject)?.value(forKeyPath: "id") as? String
        }
        
       
    }
}

extension MTSavedMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            if (searchedMovies.searchResult?.count ?? 0) > 0 {
                return searchedMovies.searchResult?.count ?? 1
            } else {
                return 1
            }
        } else {
            if savedMovies.count>0 {
                return savedMovies.count
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listCell.identifier) as? ListViewCell
        
        if isFiltering() {
            guard
                let count = searchedMovies.searchResult?.count
            else {
                //if the searchMovies is nil, then no results where found
                 return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.emptySearchCell.identifier)!
            }
            
            if count <= 0 {
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.emptySearchCell.identifier)!
            }
            
            if let movie = searchedMovies.searchResult?[indexPath.row] {
                cell?.configCell(movie)
            }
            
        } else {
            if savedMovies.count <= 0 {
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.emptyListCell.identifier)!
            }
 
            let movie = savedMovies[indexPath.row]
            cell?.configCell(movie)
        }
              
        cell?.likeButton.tag = indexPath.row
        cell?.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.mtSavedMoviesViewController.segueDetail.identifier, sender: indexPath)
    }
    @objc func handleRefresh() {
        loadMovies()
        refreshControl.endRefreshing()
        
    }
}

extension MTSavedMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func isFiltering() -> Bool {
        return ((searchController?.isActive ?? false) && !searchBarIsEmpty())
    }
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text?.count ?? 0) >= 3 {
            filterContentForSearchText(searchController.searchBar.text!)
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {

        RequestManager().requestMovieByTerm(searchText, completionSucess: { (result) in
            
            if (result.searchResult?.count ?? 0) > 0 {
                self.searchedMovies = result
                self.tableView.reloadData()
            } else {
                self.searchedMovies.searchResult?.removeAll()
                self.tableView.reloadData()
            }
 
            
        }, completionError: {(error) in
            print(error)
        })

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.searchController = nil
        dismissSearch = true
        self.tableView.reloadData()
    }
    
    
    func setupSearch(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = R.string.localizable.placeholderSearch()
        searchController?.searchBar.delegate = self

        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController?.isActive = true
        
    }
}
