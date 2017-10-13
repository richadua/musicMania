//
//  NowPlayingViewController.swift
//  MusicMania
//
//  Created by Richa Dua on 18/05/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingViewController: UIViewController {

    @IBOutlet var songImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var songProgress: UIView!
    @IBOutlet var songArtistLabel: UILabel!
    @IBOutlet var songTitleLabel: UILabel!
    @IBOutlet var progressBar: UISlider!
    var myTimer: Timer!
    var timerWhenPlayerSeeked: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        songTitleLabel.text = ViewController.songData.songTitle as String?
        songArtistLabel.text = ViewController.songData.songArtist as String?
        songImageView.image = ViewController.songData.image
        progressBar.value = 0.0
        self.addGestures()
        progressBar.minimumValue = 0.0
        progressBar.maximumValue = Float((ViewController.player.nowPlayingItem?.playbackDuration)!)
    }
    
    func progressBarUIDesign () {
        let minImage = UIImage(named: "slider-track-fill")
        let maxImage = UIImage(named: "slider-track")
        let thumb = UIImage(named: "thumb")
        
        progressBar.setMinimumTrackImage(minImage, for: UIControlState())
        progressBar.setMaximumTrackImage(maxImage, for: UIControlState())
        progressBar.setThumbImage(thumb, for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(ViewController.player.playbackState == MPMusicPlaybackState.playing) {
            playPauseButton.setImage(UIImage.init(imageLiteralResourceName: "pause_button.png"), for: UIControlState.normal)
        } else if(ViewController.player.playbackState == MPMusicPlaybackState.paused){
            playPauseButton.setImage(UIImage.init(imageLiteralResourceName: "play_button.png"), for: UIControlState.normal)
        }
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        ViewController.player .skipToNextItem()
        self.updateViewUI()
    }
    
    @IBAction func pausePlayButtonAction(_ sender: Any) {
        if(ViewController.player.playbackState == MPMusicPlaybackState.playing) {
            ViewController.player.pause()
            playPauseButton.setImage(UIImage.init(imageLiteralResourceName: "play_button.png"), for: UIControlState.normal)
        } else if(ViewController.player.playbackState == MPMusicPlaybackState.paused){
            ViewController.player.play()
            playPauseButton.setImage(UIImage.init(imageLiteralResourceName: "pause_button.png"), for: UIControlState.normal)
        }
    }

    @IBAction func previousButtonAction(_ sender: Any) {
        ViewController.player.skipToPreviousItem()
        self.updateViewUI()
    }
    
    func updateViewUI() {
        ViewController.songData.songTitle = ViewController.player.nowPlayingItem?.title as NSString!
        ViewController.songData.songArtist = ViewController.player.nowPlayingItem?.artist as NSString!
        if(ViewController.player.nowPlayingItem?.artwork?.image(at: CGSize(width: 64, height: 64)) == nil) {
            ViewController.songData.image = UIImage (imageLiteralResourceName: "Music-icon 152*152.png")
        } else {
            ViewController.songData.image = (ViewController.player.nowPlayingItem?.artwork?.image(at: CGSize(width: 64, height: 64)))!
        }
        songTitleLabel.text = ViewController.songData.songTitle as String?
        songArtistLabel.text = ViewController.songData.songArtist as String?
        songImageView.image = ViewController.songData.image
        progressBar.value = 0.0
    }
    
    func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.numberOfTapsRequired = 1
        progressBar.addGestureRecognizer(tap)
    }
    
    func updateProgress(){
        if (ViewController.player.playbackState == MPMusicPlaybackState.playing) {
            progressBar.setValue(Float(ViewController.player.currentPlaybackTime), animated: true)
        }
        if(progressBar.value == Float((ViewController.player.nowPlayingItem?.playbackDuration)!)) {
            self.updateViewUI()
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let pointTapped: CGPoint = sender.location(in: self.view)
        let percentage: CGFloat = pointTapped.x / progressBar.bounds.size.width;
        let delta:CGFloat = percentage * CGFloat(progressBar.maximumValue - progressBar.minimumValue);
        let value:CGFloat = CGFloat(progressBar.minimumValue) + delta;
        progressBar.value = Float(value)
        ViewController.player.currentPlaybackTime = TimeInterval(value*100)
        myTimer.invalidate()
    }
}
