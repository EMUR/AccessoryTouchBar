//  eVolumeBar.swift
//
//  Created by Eyad Murshid on 12/20/17
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017-2018 Eyad Murshid
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS" , WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
import UIKit
import MediaPlayer
import AVFoundation


fileprivate let imageDimension = 20
fileprivate let defaultTag = 111

fileprivate class VolumeIconView: UIView {
    private var bezier3Path: UIBezierPath!
    private var bezier2Path: UIBezierPath!
    private var rectanglePath: UIBezierPath!
    private var customImage: Bool!
    private var imageName: String!
    private var customImg: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (!customImage) {
            drawVolume()
        } else {
            drawImage()
        }
        
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        customImage = !(imageName.isEmpty)
        self.imageName = imageName
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func drawImage() {
        customImg = UIImageView.init(frame: .init(x: 0, y: 0, width: imageDimension, height: imageDimension))
        customImg.image = UIImage.init(named: imageName)
        customImg.contentMode = UIViewContentMode.scaleAspectFit
        customImg.backgroundColor = UIColor.clear
        self.addSubview(customImg)
    }
    
    func updateImageWithPicture(imgName: String!) {
        customImg.image = UIImage.init(named: imgName)
    }
    
    func drawVolume() {
        rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0.01, y: 4.29, width: 6, height: 6), cornerRadius: 1.5)
        (superview as! volumeSlider).iconColor.setFill()
        rectanglePath.fill()
        
        bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 3.01, y: 5.29))
        bezier2Path.addCurve(to: CGPoint(x: 3.01, y: 5.29), controlPoint1: CGPoint(x: 5.03, y: 4.51), controlPoint2: CGPoint(x: 1.85, y: 5.46))
        bezier2Path.addCurve(to: CGPoint(x: 10.01, y: 6.29), controlPoint1: CGPoint(x: 4.46, y: 5.09), controlPoint2: CGPoint(x: 10.01, y: 4.05))
        bezier2Path.addCurve(to: CGPoint(x: 10.01, y: 14.29), controlPoint1: CGPoint(x: 10.01, y: 15.29), controlPoint2: CGPoint(x: 10.01, y: 11.29))
        bezier2Path.addCurve(to: CGPoint(x: 6.01, y: 12.29), controlPoint1: CGPoint(x: 10.01, y: 15.05), controlPoint2: CGPoint(x: 7.01, y: 14.29))
        bezier2Path.addCurve(to: CGPoint(x: 5.01, y: 10.29), controlPoint1: CGPoint(x: 6.01, y: 12.29), controlPoint2: CGPoint(x: 6.01, y: 12.29))
        bezier2Path.addCurve(to: CGPoint(x: 3.38, y: 5.64), controlPoint1: CGPoint(x: 1.01, y: 2.29), controlPoint2: CGPoint(x: 3.38, y: 5.64))
        bezier2Path.addLine(to: CGPoint(x: 2.96, y: 6.08))
        bezier2Path.addCurve(to: CGPoint(x: 3.01, y: 5.29), controlPoint1: CGPoint(x: 2.96, y: 6.08), controlPoint2: CGPoint(x: -3.73, y: 7.91))
        bezier2Path.close()
        (superview as! volumeSlider).iconColor.setFill()
        bezier2Path.fill()
        
        bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 3.01, y: 9.29))
        bezier3Path.addCurve(to: CGPoint(x: 3.01, y: 9.29), controlPoint1: CGPoint(x: 5.03, y: 10.07), controlPoint2: CGPoint(x: 1.85, y: 9.12))
        bezier3Path.addCurve(to: CGPoint(x: 10.01, y: 8.29), controlPoint1: CGPoint(x: 4.46, y: 9.5), controlPoint2: CGPoint(x: 10.01, y: 10.54))
        bezier3Path.addCurve(to: CGPoint(x: 10.01, y: 0.29), controlPoint1: CGPoint(x: 10.01, y: -0.71), controlPoint2: CGPoint(x: 10.01, y: 3.29))
        bezier3Path.addCurve(to: CGPoint(x: 6.01, y: 2.29), controlPoint1: CGPoint(x: 10.01, y: -0.47), controlPoint2: CGPoint(x: 7.01, y: 0.29))
        bezier3Path.addCurve(to: CGPoint(x: 5.01, y: 4.29), controlPoint1: CGPoint(x: 6.01, y: 2.29), controlPoint2: CGPoint(x: 6.01, y: 2.29))
        bezier3Path.addCurve(to: CGPoint(x: 3.38, y: 8.94), controlPoint1: CGPoint(x: 1.01, y: 12.29), controlPoint2: CGPoint(x: 3.38, y: 8.94))
        bezier3Path.addLine(to: CGPoint(x: 2.96, y: 8.51))
        bezier3Path.addCurve(to: CGPoint(x: 3.01, y: 9.29), controlPoint1: CGPoint(x: 2.96, y: 8.51), controlPoint2: CGPoint(x: -3.73, y: 6.68))
        bezier3Path.close()
        (superview as! volumeSlider).iconColor.setFill()
        bezier3Path.fill()
    }
}

fileprivate class volumeSlider: UIView {
    private var volumeBar: UIProgressView!
    private var volumeIcon: VolumeIconView!
    public var customIcon = false
    private var hiddenBarCounter = 0
    private let appWindow: UIWindow = UIApplication.shared.delegate!.window!!
    
    public var volumeBarFrontColor: UIColor! {
        didSet {
            self.volumeBar.tintColor = volumeBarFrontColor
        }
    }
    public var volumeBarBackColor: UIColor! {
        didSet {
            self.volumeBar.trackTintColor = volumeBarBackColor
        }
    }
    private var barAlpha: CGFloat = CGFloat.init(0.00001) {
        didSet {
            self.alpha = barAlpha
        }
    }
    public var iconColor: UIColor! = UIColor.white {
        didSet {
            volumeIcon.setNeedsDisplay()
        }
        
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    init(frame: CGRect, customImageIcon: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        if (customImageIcon.isEmpty) {
            self.volumeIcon = VolumeIconView.init(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height), imageName: "")
            volumeBar = UIProgressView.init(frame: .init(x: frame.width * 0.22, y: frame.height * 0.38, width: frame.width * 0.9, height: frame.height))
        } else {
            self.volumeIcon = VolumeIconView.init(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height), imageName: customImageIcon)
            let halfimageDimension = CGFloat.init(imageDimension) * 0.5
            let frameWidth = frame.width
            let frameHeight = frame.height
            let shiftXPos = frameWidth * 0.22 + halfimageDimension
            let shiftYPos = frameHeight * 0.38 + halfimageDimension * 0.33
            volumeBar = UIProgressView.init(frame: CGRect.init(x: shiftXPos, y: shiftYPos, width: frameWidth * 0.9 - halfimageDimension, height: frameHeight))
            self.frame = self.frame.offsetBy(dx: 0, dy: -halfimageDimension * 0.33)
        }
        
        self.addSubview(volumeIcon)
        drawSubViews()
    }
    
    func drawSubViews() {
        self.backgroundColor = UIColor.clear
        volumeBarFrontColor = UIColor.white
        volumeBarBackColor = UIColor.white.withAlphaComponent(0.5)
        volumeBar.transform = CGAffineTransform.init(scaleX: 1.0, y: 3.0)
        volumeBar.clipsToBounds = true
        volumeBar.layer.cornerRadius = self.bounds.width * 0.03
        self.addSubview(volumeBar)
        barAlpha = 0.00001
    }
    
    func updateImageWithPicture(imgName: String!) {
        volumeIcon.updateImageWithPicture(imgName: imgName)
    }
    
    
    func updateVolumeBar(_ value: Float) {
        if (hiddenBarCounter == 0) {
            appWindow.windowLevel = UIWindowLevelStatusBar + 1
        }
        hiddenBarCounter += 1
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.volumeIcon.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.volumeIcon.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            })
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveLinear], animations: {
            self.volumeIcon.alpha = 1.0
            self.barAlpha = 1.0
            self.superview?.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.volumeBar.progress = value
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.barAlpha = 0.00001
                self.superview?.transform = CGAffineTransform.init(translationX: 0, y: 0)
                self.volumeIcon.alpha = 0.00001
            }, completion: { _ in
                self.hiddenBarCounter -= 1
                if (self.hiddenBarCounter == 0) {
                    self.appWindow.windowLevel = UIWindowLevelNormal
                }
            })
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


open class eVolumeBar: UIView {
    
    fileprivate let volume = MPVolumeView(frame: CGRect.zero)
    private let AVAudioSessionOutputVolumeKey = "outputVolume"
    fileprivate var volumeBar: volumeSlider!
    private var currentVolume = Float(0)
    private var currentImageName: String!
    private var imagesNames: Array<String>!
    private let eMinVolume = 0.00001
    private let eMaxVolume = 0.99999
    private var volumeLevels: Array<Float>!
    private var iconColor = UIColor.white {
        didSet {
            volumeBar.iconColor = iconColor
        }
    }
    private var multipleImages: Bool = false
    public var volumeBarViewTag: Int = 111 {
        didSet {
            self.tag = volumeBarViewTag
        }
    }
    public var volumeBarFrontColor: UIColor! {
        didSet {
            self.volumeBar.volumeBarFrontColor = volumeBarFrontColor
        }
    }
    public var volumeBarBackColor: UIColor! {
        didSet {
            self.volumeBar.volumeBarBackColor = volumeBarBackColor
        }
    }
    
    init() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        super.init(frame: CGRect.init(x: screenHeight * 0.02, y: (screenHeight * 0.02) / 2, width: screenWidth * 0.25, height: 0))
        setupViews(withImageName: "")
        self.backgroundColor = UIColor.clear
    }
    
    init(withImageName img: String) {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        super.init(frame: CGRect.init(x: screenHeight * 0.02, y: (screenHeight * 0.02) / 2, width: screenWidth * 0.25, height: 0))
        setupViews(withImageName: img)
        self.backgroundColor = UIColor.clear
        
    }
    
    init(withImages imgs: Array<String>, forVolumes vols: Array<Float>) {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        super.init(frame: CGRect.init(x: screenHeight * 0.02, y: (screenHeight * 0.02) / 2, width: screenWidth * 0.25, height: 0))
        
        if (imgs.count != vols.count) {
            return
        }
        
        multipleImages = true
        imagesNames = imgs
        volumeLevels = vols
        currentImageName = getImageForCurrentVolume()
        setupViews(withImageName: currentImageName)
        self.backgroundColor = UIColor.clear
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews(withImageName: "")
    }
    
    
    fileprivate func updateVolume(_ value: Float, animated: Bool) {
        if (multipleImages) {
            let img = getImageForCurrentVolume()
            if (img != currentImageName) {
                volumeBar.updateImageWithPicture(imgName: img)
                currentImageName = img
            }
        }
        volumeBar.updateVolumeBar(value)
    }
    
    fileprivate func getImageForCurrentVolume() -> String {
        if let index = volumeLevels.index(of: currentVolume) {
            return imagesNames[index]
        } else {
            for i in 0...imagesNames.count - 1 {
                if (currentVolume <= volumeLevels[i]) {
                    return imagesNames[i]
                }
            }
        }
        
        return ""
    }
    
    private func addObservers() {
        updateVolume(AVAudioSession.sharedInstance().outputVolume, animated: false)
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, options: [.old, .new], context: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(eVolumeBar.applicationWillResignActive(notification:)), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eVolumeBar.applicationDidBecomeActive(notification:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    private func setupViews(withImageName img: String) {
        self.tag = defaultTag
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Unable to initialize AVAudioSession")
        }
        
        self.backgroundColor = UIColor.clear
        let screenWidth = UIScreen.main.bounds.width
        volumeBar = volumeSlider.init(frame: CGRect.init(x: 0, y: 10, width: screenWidth * 0.15, height: 15), customImageIcon: img)
        self.addSubview(volumeBar)
        
        addObservers()
        
        volume.setVolumeThumbImage(UIImage(), for: UIControlState())
        volume.isUserInteractionEnabled = false
        volume.alpha = 0.0001
        volume.showsRouteButton = false
        volume.backgroundColor = UIColor.clear
        self.addSubview(volume)
        
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, let value = change[.newKey] as? Float, keyPath == AVAudioSessionOutputVolumeKey else {
            return
        }
        
        guard let slider = volume.subviews.flatMap({ $0 as? UISlider }).first else {
            return
        }
        
        if (slider.value == Float(eMinVolume) || slider.value == 0.0) {
            slider.value = Float(eMinVolume)
            currentVolume = 0.0
            updateVolume(0, animated: true)
        } else if (slider.value == Float(eMaxVolume) || slider.value == 1.0) {
            slider.value = Float(eMaxVolume)
            currentVolume = 1.0
            updateVolume(1, animated: true)
        } else {
            currentVolume = value
            updateVolume(value, animated: true)
        }
        
    }
    
    open func withVolumeIconColor(_ color: UIColor) -> eVolumeBar {
        self.iconColor = color
        return self
    }
    
    open func withTint(_ color: UIColor) -> eVolumeBar {
        self.iconColor = color
        self.volumeBarFrontColor = color
        self.volumeBarBackColor = color.withAlphaComponent(0.4)
        return self
    }
    
    @objc public func applicationWillResignActive(notification: Notification) {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, context: nil)
    }
    
    @objc public func applicationDidBecomeActive(notification: Notification) {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("error occurred while initializing AVAudioSession")
        }
        updateVolume(AVAudioSession.sharedInstance().outputVolume, animated: false)
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, options: [.old, .new], context: nil)
    }
    
    deinit {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, context: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
    }
    
}
