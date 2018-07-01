//  AccessoryTouchBar.swift
//
//  Created by Eyad Murshid on 06/23/18
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
import AVFoundation
import MediaPlayer

fileprivate struct FONTS_SIZE { // font sizes for labels of different cell sections
    static var large: CGFloat = 28.0
    static var medium: CGFloat = 20.0
    static var small: CGFloat = 18.0
}

fileprivate struct CONSTANS {
    static var CELL_DEFAULT_HEIGHT: CGFloat = 30.0
    static var CELL_DEFAULT_WIDTH: CGFloat = 50.0
    static var SHOW_BACK_ARROW_AFTER_DISTANCE: CGFloat = 10.0
    static var BACK_SCROLL_SENSITIVITY : CGFloat = -105.0
    static var SLIDER_FADE_DURATION : Double = 0.3
    static var CELL_FADE_DURATION : Double = 0.05
}

fileprivate enum SliderViewType {   // slider view types
    case brightness
    case sound
}


enum InputType {        //  input view types
    case emailField
    case contentField
}


class AccessoryTouchBarCell: UICollectionViewCell {   // cell view class

    // *** variables *** //
    private var cellText: UILabel!
    private var cellImage: UIImageView?
    lazy private var slider: UISlider = {
        return UISlider.init(frame: CGRect.init(x: (self.superview?.bounds.width)! * 0.2, y: 0, width: (self.superview?.bounds.width)! * 0.65, height: (self.bounds.height)))
    }()

    // *** custom initializer *** //

    func initalizer() {
        cellText = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        cellText.numberOfLines = 0
        self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cellText.center = self.center
        cellText.textAlignment = NSTextAlignment.center
        self.clipsToBounds = true
        self.layer.cornerRadius = UIScreen.main.bounds.width * 0.02
        self.contentView.addSubview(cellText)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height))
        initalizer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // *** helper functions *** //

    func updateFontSize(size: CGFloat) {
        cellText.font = UIFont.init(name: "AvenirNext-DemiBold", size: size)
    }

    fileprivate func addSlider(withValue value: Float, forType: SliderViewType!) {
        if forType == SliderViewType.brightness {
            slider.removeTarget(self, action: #selector(changeSoundLevel), for: UIControlEvents.valueChanged)
            slider.addTarget(self, action: #selector(changeBrightness), for: UIControlEvents.valueChanged)
        } else {
            slider.removeTarget(self, action: #selector(changeBrightness), for: UIControlEvents.valueChanged)
            slider.addTarget(self, action: #selector(changeSoundLevel), for: UIControlEvents.valueChanged)
        }
        self.addSubview(slider)
        slider.value = value
    }

    fileprivate func setImage(withName name: String) {
        self.cellText.text = ""
        cellImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        cellImage?.contentMode = UIViewContentMode.center
        cellImage?.image = UIImage.init(named: name)
        self.addSubview(cellImage!)
    }

    @objc func changeBrightness() {
        UIScreen.main.brightness = CGFloat(slider.value)
    }

    @objc func changeSoundLevel() {
        UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelStatusBar + 1
        if ((self.window?.windowLevel)! < (UIWindowLevelStatusBar)) {
            self.window?.windowLevel = UIWindowLevelStatusBar + 2
        }
        AccessoryTouchBar.volumeContoller.value = slider.value
    }

    fileprivate func setText(txt: String) {
        cellText.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        cellText.text = txt
        cellText.textColor = UIColor.init(white: 0.9, alpha: 1.0)
    }

    fileprivate func addActionButton(button: UIButton) {
        self.cellText.text = ""
        self.addSubview(button)
    }


}

class AccessoryTouchBar: UIView { // main AccessoryTouchBar view


    enum viewState {    // available menu options
        case menu
        case emojis
        case numbers
        case emails
        case brightness
        case sound
        case punctuation
    }

    fileprivate struct MENU_FOR_INPUT_TYPE { // menu options for a given text field
        static var contentField = [viewState.punctuation, viewState.numbers, viewState.emojis, viewState.brightness, viewState.sound, viewState.emails]
        static var emailField = [viewState.emails, viewState.punctuation, viewState.numbers, viewState.brightness, viewState.sound]
    }

    // *** variables *** //
    var collection: UICollectionView!
    private let cellReuseIdentifier = "collectionCell"
    fileprivate var selectedInputType: InputType?
    var shift = 0
    var state: viewState!
    
    let emojiRanges = [
        0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF, // Misc symbols
        0x2700...0x27BF, // Dingbats
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447
    ]
    var emojisArray: [String] = []
    static var volumeContoller = {
        return (MPVolumeView.init().subviews.first as! UISlider)
    }()
    var menuArrayImages = [viewState.emojis: "emojiIcon", viewState.numbers: "numbersIcon", viewState.emails: "emailcon", viewState.brightness: "brightnessIcon", viewState.sound: "soundIcon", viewState.punctuation: "puncIcon"]
    var numberArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var punctuationArray = [",", ".", "@", "?", "!", "-", "_", ":", ";", "(", ")", "[", "]", "#", "$", "%", "&", "^", "*", "+", "=", "/"]
    var emailsArray = ["@gmail.com", "@icloud.com", "@me.com", "@hotmail.com", "@yahoo.com", "@apple.com", "@live.com", "@mail.ru"]
    private var parent_field: Any!
    private var toFront: UIButton!
    
    
    // *** custom initializer *** //

    func initializer(input: InputType) {
        self.backgroundColor = UIColor.black
        self.window?.windowLevel = UIWindowLevelStatusBar + 2
        selectedInputType = input
        state = viewState.menu
        for range in emojiRanges {
            for i in range {
                let c = String(UnicodeScalar(i)!)
                emojisArray.append(c)
            }
        }
        let collection_layout = UICollectionViewFlowLayout()
        collection_layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collection = UICollectionView.init(frame: self.frame, collectionViewLayout: collection_layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        collection.showsHorizontalScrollIndicator = false
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swappedAction))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        collection.addGestureRecognizer(swipeDown)
        toFront = UIButton.init(frame: .init(x: 0, y: 0, width: 50, height: self.frame.height))
        toFront.setTitle("«", for: .normal)
        toFront.titleLabel?.textAlignment = NSTextAlignment.center
        toFront.titleLabel?.font = toFront.titleLabel?.font.withSize(27)
        toFront.titleLabel?.textColor = UIColor.white
        toFront.backgroundColor = UIColor.init(white: 0.0, alpha: 1.0)
        toFront.alpha = 0
        toFront.addTarget(self, action: #selector(AccessoryTouchBar.pressed(sender:)), for: .touchUpInside)
        collection.register(AccessoryTouchBarCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.addSubview(collection)
        self.addSubview(toFront)
        
    }

    init(withField field: UITextField, forInputType inp: InputType = InputType.contentField) {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05))
        initializer(input: inp)
        parent_field = field;
    }

    init(withField field: UITextView, forInputType inp: InputType = InputType.contentField) {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05))
        initializer(input: inp)
        parent_field = field;
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // *** helper functions *** //

    @objc func swappedAction(gesture: UISwipeGestureRecognizer) {
        if (state != viewState.menu && state != viewState.brightness && state != viewState.sound) {
            if (gesture.direction == UISwipeGestureRecognizerDirection.down) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.collection.transform = CGAffineTransform.init(translationX: 0, y: CONSTANS.CELL_DEFAULT_HEIGHT)
                    self.backToMainMenu()
                }) { (done) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.collection.transform = CGAffineTransform.init(translationX: 0, y: 0)
                    })
                }

            }
        }
    }

    @objc func pressed(sender: UIButton!) {
        collection.setContentOffset(.zero, animated: true)
    }
}


extension AccessoryTouchBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if state == viewState.menu {
            if selectedInputType == InputType.contentField {
                return MENU_FOR_INPUT_TYPE.contentField.count
            } else {
                return MENU_FOR_INPUT_TYPE.emailField.count
            }
        } else if state == viewState.emojis {
            return emojisArray.count
        } else if state == viewState.numbers {
            return numberArray.count;
        } else if state == viewState.emails {
            return emailsArray.count;
        } else if state == viewState.brightness || state == viewState.sound {
            return 1
        } else if state == viewState.punctuation {
            return punctuationArray.count
        } else {
            return 0
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if state == viewState.menu {
            return
        }

        if state == viewState.emojis || state == viewState.emails || state == viewState.punctuation {
            if scrollView.contentOffset.x > CONSTANS.SHOW_BACK_ARROW_AFTER_DISTANCE {
                UIView.animate(withDuration: 0.1) {
                    self.toFront.alpha = 1
                }
            } else if toFront.alpha >= 1 {
                UIView.animate(withDuration: 0.1) {
                    self.toFront.alpha = 0
                }
            }
        }

        if scrollView.contentOffset.x < 0 {
            collection.backgroundColor = UIColor.init(red: scrollView.contentOffset.x * -0.01, green: 0, blue: 0, alpha: 1.0)

            if scrollView.contentOffset.x < CONSTANS.BACK_SCROLL_SENSITIVITY {
                backToMainMenu()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var duration: Double!

        if state == viewState.brightness || state == viewState.sound {
            duration = CONSTANS.SLIDER_FADE_DURATION
        } else {
            duration = CONSTANS.CELL_FADE_DURATION
        }
        UIView.animate(withDuration: duration) {
            cell.alpha = 1.0
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if state == viewState.menu {
            return CGSize.init(width: self.frame.width / CGFloat(menuArrayImages.count), height: CONSTANS.CELL_DEFAULT_HEIGHT)
        } else if state == viewState.numbers {
            return CGSize.init(width: self.frame.width / 13, height: CONSTANS.CELL_DEFAULT_HEIGHT)
        } else if state == viewState.emails {
            return CGSize.init(width: 140, height: CONSTANS.CELL_DEFAULT_HEIGHT)
        } else if state == viewState.brightness || state == viewState.sound {
            return CGSize.init(width: self.bounds.width - 20, height: CONSTANS.CELL_DEFAULT_HEIGHT)
        } else {
            return CGSize.init(width: CONSTANS.CELL_DEFAULT_WIDTH, height: CONSTANS.CELL_DEFAULT_HEIGHT)
        }
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AccessoryTouchBarCell
        cell.alpha = 0.0
        while cell.subviews.count > 1 {
            cell.subviews[cell.subviews.count - 1].removeFromSuperview()
        }

        if state == viewState.menu {
            if selectedInputType == InputType.contentField {
                cell.setImage(withName: menuArrayImages[MENU_FOR_INPUT_TYPE.contentField[indexPath.row]]!)
            } else {
                cell.setImage(withName: menuArrayImages[MENU_FOR_INPUT_TYPE.emailField[indexPath.row]]!)
            }
        } else if state == viewState.emojis {
            cell.setText(txt: emojisArray[indexPath.row])
            cell.updateFontSize(size: FONTS_SIZE.large - 5.0)
        } else if state == viewState.numbers {
            cell.setText(txt: numberArray[indexPath.row])
            cell.updateFontSize(size: FONTS_SIZE.medium)
        } else if state == viewState.emails {
            cell.setText(txt: emailsArray[indexPath.row])
            cell.updateFontSize(size: FONTS_SIZE.small)
        } else if state == viewState.brightness || state == viewState.sound {
            let button = UIButton.init(frame: .init(x: 20, y: 0, width: CONSTANS.CELL_DEFAULT_WIDTH, height: CONSTANS.CELL_DEFAULT_HEIGHT))
            button.addTarget(self, action: #selector(backToMainMenu(cell:)), for: UIControlEvents.touchUpInside)
            button.setImage(UIImage.init(named: "close"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
            cell.addActionButton(button: button)
            if state == viewState.brightness {
                let currentBrightness = UIScreen.main.brightness
                cell.addSlider(withValue: Float(currentBrightness), forType: SliderViewType.brightness)
            } else {
                let currentSoundLevel = AccessoryTouchBar.volumeContoller.value
                cell.addSlider(withValue: Float(currentSoundLevel), forType: SliderViewType.sound)

            }
        } else if state == viewState.punctuation {
            cell.setText(txt: punctuationArray[indexPath.row])
            cell.updateFontSize(size: FONTS_SIZE.medium)
        } else {

        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if state == viewState.numbers {
            return UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 2)
        } else if state == viewState.brightness || state == viewState.sound {
            return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        }
    }

    @objc func backToMainMenu(cell: AccessoryTouchBarCell? = nil) {
        if self.toFront.alpha > 0 {
            self.toFront.alpha = 0
        }
        state = viewState.menu
        UIView.animate(withDuration: 0.3) {
            self.collection.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        }
        collection.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if state == viewState.menu {
            collectionView.setContentOffset(.zero, animated: false)
            if selectedInputType == InputType.contentField {
                state = MENU_FOR_INPUT_TYPE.contentField[indexPath.row]
            } else {
                state = MENU_FOR_INPUT_TYPE.emailField[indexPath.row]
            }
            collectionView.reloadData()
        } else if state == viewState.emojis {
            if (parent_field as? UITextView) != nil {
                (parent_field as! UITextView).text?.append(emojisArray[indexPath.row])
            } else {
                (parent_field as! UITextField).text?.append(emojisArray[indexPath.row])
            }
        } else if state == viewState.numbers {
            if (parent_field as? UITextView) != nil {
                (parent_field as! UITextView).text?.append(numberArray[indexPath.row])
            } else {
                (parent_field as! UITextField).text?.append(numberArray[indexPath.row])
            }

        } else if state == viewState.emails {
            if (parent_field as? UITextView) != nil {
                (parent_field as! UITextView).text?.append(emailsArray[indexPath.row])
            } else {
                (parent_field as! UITextField).text?.append(emailsArray[indexPath.row])
            }

        } else if state == viewState.punctuation {
            if (parent_field as? UITextView) != nil {
                (parent_field as! UITextView).text?.append(punctuationArray[indexPath.row])
            } else {
                (parent_field as! UITextField).text?.append(punctuationArray[indexPath.row])
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if state != viewState.menu {
            backToMainMenu()
            
        }
    }

}
