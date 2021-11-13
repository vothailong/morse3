
import UIKit

/// Delegate method for the morse keyboard view that will allow it to perform
/// actions on whatever text entry you want to use it with. It does not assume
/// any type e.g. UITextField vs UITextView.
protocol MorseKeyboardViewDelegate: class {
    func insertCharacter(_ newCharacter: String)
    func insertString(_ string: String)
    func deleteCharacterBeforeCursor()
    func characterBeforeCursor() -> String?
}

/// Contains all of the logic for handling button taps and translating that into
/// specific actions on the text entry associated with it
class MorseKeyboardView: UIView {
    @IBOutlet var swiftuiContainer: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
   // @IBOutlet var spaceButtonToParentConstraint: NSLayoutConstraint!
   // @IBOutlet var spaceButtonToNextKeyboardConstraint: NSLayoutConstraint!
    
    weak var delegate: MorseKeyboardViewDelegate?
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setColorScheme(.light)
        setNextKeyboardVisible(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setColorScheme(.light)
        setNextKeyboardVisible(false)
    }
    
    func setNextKeyboardVisible(_ visible: Bool) {
//        //spaceButtonToNextKeyboardConstraint.isActive = visible
//        nextKeyboardButton.isHidden = !visible
//       // spaceButtonToParentConstraint.isActive = !visible
    }
    
    func setColorScheme(_ colorScheme: MorseColorScheme) {
        let colorScheme = MorseColors(colorScheme: colorScheme)
        backgroundColor = colorScheme.backgroundColor
        
        for view in subviews {
            if let button = view as? KeyboardButton {
                button.setTitleColor(colorScheme.buttonTextColor, for: [])
                button.tintColor = colorScheme.buttonTextColor
                
                if button == nextKeyboardButton || button == deleteButton {
                    button.defaultBackgroundColor = colorScheme.buttonHighlightColor
                    button.highlightBackgroundColor = colorScheme.buttonBackgroundColor
                } else {
                    button.defaultBackgroundColor = colorScheme.buttonBackgroundColor
                    button.highlightBackgroundColor = colorScheme.buttonHighlightColor
                }
            }
        }
    }
}

// MARK: - Actions
extension MorseKeyboardView {
    @IBAction func dotPressed(button: UIButton) {
        addSignal(.dot)
    }
    
    @IBAction func dashPressed() {
        addSignal(.dash)
    }
    
    @IBAction func deletePressed() {
         
            // Building on existing letter by deleting current
            delegate?.deleteCharacterBeforeCursor()
    }
    
    @IBAction func spacePressed() {
            delegate?.insertCharacter(" ")
         
    }
}

// MARK: - Private Methods
private extension MorseKeyboardView {
    func addSignal(_ signal: MorseData.Signal) {
            // Building on existing letter
            delegate?.deleteCharacterBeforeCursor()
    }
}
