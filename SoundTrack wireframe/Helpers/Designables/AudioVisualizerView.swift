//
//  AudioVisualizerView.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 14/06/23.
//

import Foundation
import UIKit
import AVFoundation

class AudioVisualizerView: UIView {
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?
    private var audioEngine: AVAudioEngine?
    private var displayLink: CADisplayLink?
    private var barViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
    }
    
    func configure(with audioURL: URL) {
        self.audioURL = audioURL
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            
            if let audioPlayer = audioPlayer {
                audioEngine = AVAudioEngine()
                
                let audioFile = try AVAudioFile(forReading: audioURL)
                let audioFormat = audioFile.processingFormat
                let audioFrameCount = UInt32(audioFile.length)
                let audioPCMBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
                
                try audioFile.read(into: audioPCMBuffer!)
                
                let audioAnalyzer = AVAudioPlayerNode()
                audioEngine?.attach(audioAnalyzer)
                audioEngine?.connect(audioAnalyzer, to: audioEngine!.mainMixerNode, format: audioPCMBuffer!.format)
                audioEngine?.prepare()
                try audioEngine?.start()
                
                audioAnalyzer.scheduleBuffer(audioPCMBuffer!, at: nil, options: .loops, completionHandler: nil)
                
                audioPlayer.play()
                audioAnalyzer.play()
                
                startDisplayLink()
            }
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
        
    }
    
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAudioVisualizer))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateAudioVisualizer() {
        audioPlayer?.updateMeters()

        let numberOfBars = 100
        let barWidth = bounds.width / CGFloat(numberOfBars)
        let barSpacing: CGFloat = 2.0
        let barHeightMultiplier: CGFloat = 0.5
        
        // Remove existing bar views
        barViews.forEach { $0.removeFromSuperview() }
        barViews.removeAll()
        
        for i in 0..<numberOfBars {
            let barView = UIView()
            barView.backgroundColor = .black
            
            let averagePower = audioPlayer?.averagePower(forChannel: 0) ?? -60.0
            
            let barHeight = bounds.height * barHeightMultiplier * CGFloat(pow(10, averagePower / 20))
            let barX = bounds.midX - (CGFloat(numberOfBars) / 2 * (barWidth + barSpacing)) + (CGFloat(i) * (barWidth + barSpacing))
            let barFrame = CGRect(x: barX, y: bounds.midY - (barHeight / 2), width: barWidth, height: barHeight)
            barView.frame = barFrame
            
            addSubview(barView)
            barViews.append(barView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the positions of the bar views when the view's frame changes
        updateAudioVisualizer()
    }
    
    deinit {
        stopDisplayLink()
    }
}
