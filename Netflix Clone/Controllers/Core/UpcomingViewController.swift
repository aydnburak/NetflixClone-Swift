//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Burak on 23.12.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
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


}
