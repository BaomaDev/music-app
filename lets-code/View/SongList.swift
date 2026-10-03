//
//  SongList.swift
//  lets-code
//
//  Created by Jesse Robinson Junior Simanjuntak on 03/10/26.
//

//import Foundation
//import UIKit
//
//final class SongList: UICollectionViewCell{
//    static let reuseIdentifier: String = "SongList"
//    
//    let titleLabel = UILabel()
//    let authorLabel = UILabel()
//    
//    func configure(with song: Song) {
//        titleLabel.text = song.title
//        authorLabel.text = song.author
//    }
//}
//

import UIKit

final class PodcastCell: UICollectionViewCell {
    static let reuseIdentifier = "PodcastCell"
    private let artworkView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        artworkView.layer.cornerRadius = 12
        artworkView.clipsToBounds = true
        artworkView.contentMode = .scaleAspectFill
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artworkView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            artworkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artworkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: 76),
            artworkView.heightAnchor.constraint(equalToConstant: 76),
            stack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with podcast: Song) {
//        titleLabel.text = podcast.title
        subtitleLabel.text = podcast.artistName
        artworkView.image = UIImage(systemName: "mic.fill")
        artworkView.tintColor = .white
        artworkView.backgroundColor = .systemIndigo
        loadImage(from: podcast.artworkUrl100)
    }

//    func configure(with episode: PodcastEpisode) {
//        titleLabel.text = episode.title
//        subtitleLabel.text = "Tap to listen"
//        artworkView.image = UIImage(systemName: "play.fill")
//        artworkView.tintColor = .white
//        artworkView.backgroundColor = .systemIndigo
//    }

    private func loadImage(from url: URL?) {
        guard let url else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { self?.artworkView.image = image }
        }.resume()
    }
}
