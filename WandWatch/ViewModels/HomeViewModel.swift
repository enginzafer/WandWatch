//
//  HomeViewModel.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var movies: [Media] = []
    
    init() {
        fetchMovies()
    }
    
    
    func fetchMovies() {
        
        self.movies = [
            Media.mock,
            Media.mock,
            Media.mock
        ]
    }
}

