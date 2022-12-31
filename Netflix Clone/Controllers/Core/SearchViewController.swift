//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Burak on 23.12.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies: [Movie] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        let movieViewmodel = MovieViewModel(movieName: (movie.originalTitle ?? movie.title) ?? "", posterURL: movie.posterPath ?? "")
        
        cell.configure(with: movieViewmodel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

extension SearchViewController: UISearchResultsUpdating,SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else
        { return }
        
        resultsController.delegate = self
                
                APICaller.shared.search(with: query) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let movies):
                            resultsController.movies = movies
                            resultsController.searchResultsCollectionView.reloadData()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let movie = movies[indexPath.row]
            
            guard let titleName = movie.title ?? movie.originalTitle else { return }
            
            
            APICaller.shared.getMovie(with: titleName) { [weak self] result in
                switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let vc = MoviePreviewViewController()
                        vc.configure(with: MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }

                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    func searchResultsViewControllerDidTapItem(_ viewmodel: MoviePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewmodel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
