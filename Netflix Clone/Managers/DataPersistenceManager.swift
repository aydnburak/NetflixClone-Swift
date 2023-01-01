//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Burak on 1.01.2023.
//

import UIKit
import CoreData


class DataPersistenceManager {
    
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    private init(){}
    
    
    func downloadTitleWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(model.id)
        item.title = model.title
        item.originalTitle = model.originalTitle
        item.posterPath = model.posterPath
        item.overview = model.overview
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            
            let movies = try context.fetch(request)
            completion(.success(movies))
            
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: MovieItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
        
    }
}
