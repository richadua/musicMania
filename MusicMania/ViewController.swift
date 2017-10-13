//
//  ViewController.swift
//  MusicMania
//
//  Created by Richa Dua on 18/05/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var mediaPicker: MPMediaPickerController?
    @IBOutlet var currentSongArtist: UILabel!
    @IBOutlet var currentSongName: UILabel!
    @IBOutlet var pausePlayButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nowPlayingView: UIView!
    static var songData: SongData = SongData()
    var mediaItemCollection: MPMediaItemCollection!
    public static let player = MPMusicPlayerController.applicationMusicPlayer()
    
    @IBAction func pausePlayButtonAction(_ sender: Any) {
        if(ViewController.player.playbackState == MPMusicPlaybackState.playing) {
            ViewController.player.pause()
            pausePlayButton.setImage(UIImage.init(imageLiteralResourceName: "play_button.png"), for: UIControlState.normal)
        } else if(ViewController.player.playbackState == MPMusicPlaybackState.paused){
            ViewController.player.play()
            pausePlayButton.setImage(UIImage.init(imageLiteralResourceName: "pause_button.png"), for: UIControlState.normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        tableView.tableFooterView = UIView()
        mediaPicker.allowsPickingMultipleItems = false
        let query = MPMediaQuery.songs()
        self.mediaItemCollection = MPMediaItemCollection(items: query.items!)
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        nowPlayingView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        nowPlayingView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(ViewController.player.playbackState == MPMusicPlaybackState.playing) {
            nowPlayingView.isHidden = false
            currentSongName.text = ViewController.songData.songTitle as String?
            currentSongArtist.text = ViewController.songData.songArtist as String?
            pausePlayButton.setImage(UIImage.init(imageLiteralResourceName: "pause_button.png"), for: UIControlState.normal)
        } else if(ViewController.player.playbackState == MPMusicPlaybackState.paused) {
            nowPlayingView.isHidden = false
            currentSongName.text = ViewController.songData.songTitle as String?
            currentSongArtist.text = ViewController.songData.songArtist as String?
            pausePlayButton.setImage(UIImage.init(imageLiteralResourceName: "play_button.png"), for: UIControlState.normal)
        } else {
            nowPlayingView.isHidden = true;
        }
    }
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NowPlayingViewController") as! NowPlayingViewController
        self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MPMediaQuery.songs().items?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = self.mediaItemCollection.items[indexPath.row].title
        cell.artistLabel.text = self.mediaItemCollection.items[indexPath.row].artist
        cell.artworkImageView.image = self.mediaItemCollection.items[indexPath.row].artwork?.image(at: CGSize(width: 64, height: 64))
        if(cell.artworkImageView.image == nil){
            cell.artworkImageView.image = UIImage.init(imageLiteralResourceName: "Music-icon 152*152.png")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nowPlayingView.isHidden = false
        currentSongName.text = mediaItemCollection.items[indexPath.row].title
        currentSongArtist.text = mediaItemCollection.items[indexPath.row].artist
        pausePlayButton.setImage(UIImage.init(imageLiteralResourceName: "pause_button.png"), for: UIControlState.normal)
        
        ViewController.songData.songTitle = mediaItemCollection.items[indexPath.row].title as NSString!
        ViewController.songData.songArtist = mediaItemCollection.items[indexPath.row].artist as NSString!
        if(mediaItemCollection.items[indexPath.row].artwork?.image(at: CGSize(width: 64, height: 64)) == nil) {
            ViewController.songData.image = UIImage (imageLiteralResourceName: "Music-icon 152*152.png")
        } else {
            ViewController.songData.image = mediaItemCollection.items[indexPath.row].artwork?.image(at: CGSize(width: 64, height: 64))
        }
        
        ViewController.player.beginGeneratingPlaybackNotifications()
        ViewController.player.setQueue(with: mediaItemCollection)
        ViewController.player.nowPlayingItem = mediaItemCollection.items[indexPath.row]
        ViewController.player.play()
        ViewController.player.shuffleMode = MPMusicShuffleMode.default;
    }
    
}

