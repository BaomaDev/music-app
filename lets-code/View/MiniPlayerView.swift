//
//  MiniPlayerView.swift
//  lets-code
//
//  Created by Jesse Robinson Junior Simanjuntak on 03/10/26.
//


import UIKit

final class MiniPlayerView: UIView {
    private let player = AudioPlayerService.shared
    private let titleLabel = UILabel()
    private let button = UIButton(type: .system)
    private let buttonNext = UIButton(type: .system)
    private let buttonPrevious = UIButton(type: .system)

    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: -2)
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(button)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        player.onStateChange = { [weak self] in
            DispatchQueue.main.async { self?.refresh() }
        }
        refresh()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func refresh() {
        guard let episode = player.currentSong else {
            isHidden = true
            return
        }
        isHidden = false
        titleLabel.text = episode.trackName
        button.setImage(UIImage(systemName: player.isPlaying ? "pause.fill" : "play.fill"), for: .normal)
        buttonNext.setImage(UIImage(systemName: "forward.end.alt.fill"), for: .normal)
        buttonPrevious.setImage(UIImage(systemName: "rewind.end.alt.fill"), for: .normal)
    }

    @objc private func toggle() { player.toggle() }
}
