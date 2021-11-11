/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RealmSwift
import SwiftUI
class PracticeViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var instructionsLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var morseChartBottomConstraint: NSLayoutConstraint!
    
    var morseKeyboardView: MorseKeyboardView!
    
    var realm: Realm!
    var lastpasteboardString: String?
    var toDoItems: Results<Item>?
    var selectedCategory: Category?
    //  let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an observer so that we can adjust the UI when the keyboard is showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        //                                               name: NSNotification.Name.UIPasteboardChanged , object: nil)
        // Add an observer to know when app comes to foreground to update UI
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: .UIApplicationWillEnterForeground, object: nil)
        
        // Set keyboard view to input view of text field
        let nib = UINib(nibName: "MorseKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        morseKeyboardView = (objects.first as! MorseKeyboardView)
        morseKeyboardView.delegate = self
        
        // Add the keyboard to a container view so that it's sized correctly
        let keyboardContainerView = UIView(frame: morseKeyboardView.frame)
        keyboardContainerView.addSubview(morseKeyboardView)
        textField.inputView = keyboardContainerView
        
        // Add KVO for textfield to determine when cursor moves
        textField.addObserver(self, forKeyPath: "selectedTextRange", options: .new, context: nil)
        
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.screencastomatic.com")!
            .appendingPathComponent("default.realm")
        print("path realm====== \(String(describing: fileURL))")
        let config = Realm.Configuration(fileURL: fileURL)
        do {
            realm = try Realm(configuration: config)
        } catch {
            Log.error("Error initialising new realm, \(error)")
        }
        
        morseKeyboardView.setNextKeyboardVisible(false)
        
        let controller = CategoryViewController()
        selectedCategory = controller.loadCategories()?.first
        if selectedCategory == nil {
            controller.createDefaultCategory()
            selectedCategory = controller.loadCategories()?.first
        }
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
    }
    
    func loadItems() {
        //toDoItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: true)
        guard let toDoItems = toDoItems else {
            return
        }
        
        
        print(  "==============\nNEXT")
        for (index, element) in toDoItems.enumerated() {
            print(  "\(index+1)=====\(element.content)")
        }
        //        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let previousSignals = MorseData.code["a"] {
            // print("ksdj")
        }
        
        
        reloadViews()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        textField.removeObserver(self, forKeyPath: "selectedTextRange")
    }
}

// MARK: - Observers
extension PracticeViewController {
    @objc func reloadViews() {
        
        
        // Start the app with the keyboard showing
        textField.becomeFirstResponder()
        
        addClipboardItemToDB()
        loadItems()
        
        
        
    }
    
    func addClipboardItemToDB() {
        let pasteboardString: String? = UIPasteboard.general.string
        guard let   theString = pasteboardString, let selectedCategory = selectedCategory else { return  }
        lastpasteboardString = toDoItems?.first?.content
        
        if  theString == lastpasteboardString {
            print(lastpasteboardString != nil ? "duplicated value:\(theString)" : "no value to show")
        }
        else   {
            lastpasteboardString = theString
            print("String is \(theString)")
            // Put the string into your search bar and do the search
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.content = theString
                    newItem.dateCreated = Date()
                    selectedCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height,
              let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                  return
              }
        
        morseChartBottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: animationDurarion) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedTextRange" {
            // Clear out the current signal as the cursor placement changed
            morseKeyboardView.signalCache = []
        }
    }
}

// MARK: - Private Methods
private extension PracticeViewController {
    
}

// MARK: - MorseKeyboardViewDelegate
extension PracticeViewController: MorseKeyboardViewDelegate {
    func insertString(_ string: String) {
        
    }
    
    /// Insert character after the textfield cursor
    func insertCharacter(_ newCharacter: String) {
        textField.insertText(newCharacter)
    }
    
    /// Delete character before textfield cursor
    func deleteCharacterBeforeCursor() {
        textField.deleteBackward()
        print("delte press22")
    }
    
    /// Provide the delegate with the character before the cursor
    func characterBeforeCursor() -> String? {
        // get the cursor position
        if let cursorRange = textField.selectedTextRange {
            // get the position one character before the cursor start position
            if let newPosition = textField.position(from: cursorRange.start, offset: -1), let range = textField.textRange(from: newPosition, to: cursorRange.start) {
                return textField.text(in: range)
            }
        }
        return nil
    }
}
