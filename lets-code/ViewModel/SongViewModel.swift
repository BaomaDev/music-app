//
//  SongViewModel.swift
//  lets-code
//
//  Created by Jesse Robinson Junior Simanjuntak on 03/10/26.
//
import Foundation

@MainActor
final class SongViewModel {
    private let service: SongService
    private(set) var songs = [Song]()
//    private(set) var episodes = [PodcastEpisode]()
    private(set) var isLoading = false
    
    var onChange: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(service: SongService = SongService()) {
        self.service = service
    }
    
    func search(query: String) {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        
        print("test", query)
        
        isLoading = true
        onChange?()
        
        Task {
            do {
                print("hai aku masuk")
                songs = try await service.search(query: query)
                isLoading = false
                onChange?()
            } catch {
                print("hai aku ero")
                isLoading = false
                onError?(error)
            }
        }
    }
}
