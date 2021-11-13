 
import UIKit
import CoreLocation
import SwiftUI

class KeyboardViewController: UIInputViewController {
  var morseKeyboardView: MorseKeyboardView!
  var userLexicon: UILexicon?

  var currentWord: String? {
    var lastWord: String?
    if let stringBeforeCursor = textDocumentProxy.documentContextBeforeInput {
      stringBeforeCursor.enumerateSubstrings(in: stringBeforeCursor.startIndex...,
                                             options: .byWords)
      { word, _, _, _ in
        if let word = word {
          lastWord = word
        }
      }
    }
    return lastWord
  }

  var currentLocation: CLLocation?
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    let nib = UINib(nibName: "MorseKeyboardView", bundle: nil)
    let objects = nib.instantiate(withOwner: nil, options: nil)
    morseKeyboardView = objects.first as! MorseKeyboardView
    morseKeyboardView.delegate = self

    guard let inputView = inputView else { return }
    inputView.addSubview(morseKeyboardView)
    morseKeyboardView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      morseKeyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
      morseKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
      morseKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      morseKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
      ])

    morseKeyboardView.setNextKeyboardVisible(needsInputModeSwitchKey)
   // morseKeyboardView.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
      morseKeyboardView.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .allTouchEvents)
       
    requestSupplementaryLexicon { lexicon in
      self.userLexicon = lexicon
    }

    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 100
    locationManager.startUpdatingLocation()
      
      
      let sot = ClipboardSOT(controller: CategoryViewController ())
      let hostingVC = UIHostingController(rootView: KeyBoardListView(sot: sot,delegate: self))
      self.morseKeyboardView.swiftuiContainer.addSubview(hostingVC.view)
      hostingVC.view.pinEdges(to: self.morseKeyboardView.swiftuiContainer)
    //  hostingVC.view.backgroundColor = .yellow// .clear
      
      
  }

  override func textDidChange(_ textInput: UITextInput?) {
    let colorScheme: MorseColorScheme

    if textDocumentProxy.keyboardAppearance == .dark {
      colorScheme = .dark
    } else {
      colorScheme = .light
    }

    morseKeyboardView.setColorScheme(colorScheme)
  }
}

// MARK: - MorseKeyboardViewDelegate
extension KeyboardViewController: MorseKeyboardViewDelegate {
  func insertCharacter(_ newCharacter: String) {
    if newCharacter == " " {
      if currentWord?.lowercased() == "sos",
        let currentLocation = currentLocation {
        let lat = currentLocation.coordinate.latitude
        let lng = currentLocation.coordinate.longitude
        textDocumentProxy.insertText(" (\(lat), \(lng))")
      } else {
        attemptToReplaceCurrentWord()
      }
    }

    textDocumentProxy.insertText(newCharacter)
  }
    
    func insertString(_ string: String) {
       

      textDocumentProxy.insertText(string)
    }

  func deleteCharacterBeforeCursor() {
    textDocumentProxy.deleteBackward()
  }

  func characterBeforeCursor() -> String? {
    guard let character = textDocumentProxy.documentContextBeforeInput?.last else {
      return nil
    }
    return String(character)
  }
}

// MARK: - Private methods
private extension KeyboardViewController {
  func attemptToReplaceCurrentWord() {
    guard let entries = userLexicon?.entries,
      let currentWord = currentWord?.lowercased() else {
        return
    }

    let replacementEntries = entries.filter {
      $0.userInput.lowercased() == currentWord
    }

    if let replacement = replacementEntries.first {
      for _ in 0..<currentWord.count {
        textDocumentProxy.deleteBackward()
      }

      textDocumentProxy.insertText(replacement.documentText)
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension KeyboardViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.first
  }
}
