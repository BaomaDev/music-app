//
//  ViewController.swift
//  lets-code
//
//  Created by Jesse Robinson Junior Simanjuntak on 03/10/26.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel = SongViewModel()
    private let player = AudioPlayerService.shared
    private let searchController = UISearchController(searchResultsController: nil)
//    private let miniPlayer = MiniPlayerView()
    private var collectionView: UICollectionView!
    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        print("test")
        configureView()
        configureSearch()
        configureCollectionView()
//        configureMiniPlayer()
        configureMessageLabel()
        bindViewModel()
        viewModel.search(query: "indonesia")
    }

    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search song"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureView() {
        title = "Lagu lagu"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 96)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 96, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
//    private func configureMiniPlayer() {
//        view.addSubview(miniPlayer)
//        NSLayoutConstraint.activate([
//            miniPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            miniPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            miniPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            miniPlayer.heightAnchor.constraint(equalToConstant: 64)
//        ])
//    }

    private func configureMessageLabel() {
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func updateView() {
        if viewModel.isLoading {
            messageLabel.text = "Loading..."
        } else if viewModel.songs.isEmpty {
            messageLabel.text = "No result found"
        } else {
            messageLabel.text = nil
        }
        
        messageLabel.isHidden = messageLabel.text == nil
        collectionView.isHidden = viewModel.isLoading
        collectionView.reloadData()
    }
    
    private func errorMessages(_ error : Error) {
        messageLabel.text = error.localizedDescription
        messageLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.onChange = {[weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }
        viewModel.onError = {[weak self] error in
            DispatchQueue.main.async {
                self?.errorMessages(error)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.songs.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PodcastCell.reuseIdentifier,
            for: indexPath
        ) as! PodcastCell
        
        cell.configure(with: viewModel.songs[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath : IndexPath) {
        let song = viewModel.songs[indexPath.item]
        AudioPlayerService.shared.play(song)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(runSearch), object: nil)
        perform(#selector(runSearch), with: searchController.searchBar.text, afterDelay: 0.35)
    }

    @objc private func runSearch(_ query: String?) {
        viewModel.search(query: query ?? "")
    }
}
