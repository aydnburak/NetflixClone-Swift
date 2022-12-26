//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Burak on 25.12.2022.
//

import Foundation

struct Constants {
    static let API_KEY = "685a651565a761e57d0023460c2c6cf3"
    static let baseUrl = "https://api.themoviedb.org/"
}

enum APIError: Error {
    case failedToGetData
}

final class APICaller {
    static let shared = APICaller()
    private init(){}
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/upcoming?api_key=\(Constants.API_KEY)") else { return }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/popular?api_key=\(Constants.API_KEY)") else { return }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/top_rated?api_key=\(Constants.API_KEY)") else { return }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
