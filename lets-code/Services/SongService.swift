//
//  SongService.swift
//  lets-code
//
//  Created by Jesse Robinson Junior Simanjuntak on 03/10/26.
//

import Foundation
import AVFoundation

enum SongServiceError: LocalizedError {
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The song returned an invalid response."
        }
    }
}

final class SongService {
    func search(query: String) async throws -> [Song] {
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: query),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "25")
        ]
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        try validate(response)
        return try JSONDecoder().decode(SongSearchResponse.self, from: data).results
    }

//    func episodes(for podcast: Podcast) async throws -> [PodcastEpisode] {
//        guard let feedURL = podcast.feedUrl else { throw PodcastServiceError.missingFeed }
//        let (data, response) = try await URLSession.shared.data(from: feedURL)
//        try validate(response)
//        let episodes = try RSSParser.parse(data: data)
//        guard !episodes.isEmpty else { throw PodcastServiceError.noEpisodes }
//        return episodes
//    }

    private func validate(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse,
              200..<300 ~= response.statusCode else {
            throw SongServiceError.invalidResponse
        }
    }
}

final class AudioPlayerService {
    static let shared = AudioPlayerService()

    private(set) var currentSong: Song?
    private(set) var isPlaying = false
    private var player: AVPlayer?
    var onStateChange: (() -> Void)?
    
    //bikin queue
    //index it
    //ambil currently

    func play(_ song: Song) {
        guard let url = song.previewUrl else { return }
        
        player = AVPlayer(url: url)
        currentSong = song
        player?.play()
        
//        if currentSong?.previewUrl != song.previewUrl {
//            player = AVPlayer(url: song.previewUrl)
//            currentSong = song
//        }
        isPlaying = true
        onStateChange?()
    }

    func toggle() {
        guard let player else { return }
        if isPlaying { player.pause() } else { player.play() }
        isPlaying.toggle()
        onStateChange?()
    }
    //tambahin buat si next, previous, and autoplay
}
