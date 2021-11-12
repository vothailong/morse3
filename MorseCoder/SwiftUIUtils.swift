import SwiftUI
import Combine

let  sourceSansPro  = "Source Sans Pro"
let  sourceSansPro_Light  = "Source Sans Pro Light"
let  sourceSansPro_SemiBold = "Source Sans Pro Semibold"
let  sourceSansPro_SemiBold_Italic = "Source Sans Pro Semibold Italic"
let  sourceSansPro_Bold = "Source Sans Pro Bold"

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -10 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct SinEffect: GeometryEffect {
    let rotationAmount: Double
    let scaleAmount: Double
    var offset: Double // 0...1(range)(1: will return to .identity)
    init (scaleAmount:Double = 1.5, rotationAmount: Double = 0.08, offset: Double) {
        self.rotationAmount = rotationAmount
        self.offset = offset
        self.scaleAmount = scaleAmount
        
    }
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        let effectValue = abs(sin(offset*Double.pi))
        let scaleFactor = 1 + scaleAmount*effectValue
        
        // let affineTransform = CGAffineTransform(rotationAngle: CGFloat(0.2*effectValue)).translatedBy(x: -size.width/2, y: -size.height/2).scaledBy(x: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        
        let affineTransform = CGAffineTransform(rotationAngle: CGFloat(rotationAmount*effectValue)).scaledBy(x: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        
        
        return ProjectionTransform(affineTransform)
    }
}

struct LikeEffect: GeometryEffect {
    
    var offset: Double // 0...1(range)(1: will return to .identity)
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        let effectValue = abs(sin(offset*Double.pi))/20
        let scaleFactor = 1 + 3*effectValue
        
        // let affineTransform = CGAffineTransform(rotationAngle: CGFloat(0.2*effectValue)).translatedBy(x: -size.width/2, y: -size.height/2).scaledBy(x: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        
        let affineTransform = CGAffineTransform(rotationAngle: CGFloat(effectValue)).scaledBy(x: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        
        //         let affineTransform = CGAffineTransform(rotationAngle: CGFloat(0)).translatedBy(x: 0, y: -100).scaledBy(x: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        return ProjectionTransform(affineTransform)
    }
}
 

struct CircleClippedModifier: ViewModifier {
    var makeCircle = false
    func body(content: Content) -> some View {
        Group{
            if makeCircle{
                content
                    .clipShape(Circle())
            } else {
                content
            }
        }
    }
}


struct ScaleButtonStyle: ButtonStyle {
    var minRatio: CGFloat = 0.85
    init(minRatio: CGFloat = 0.85) {
        self.minRatio = minRatio
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? minRatio : 1.0)
    }
}

struct CircleButton: View {
    let name: String
    let systemName: String?
    let selectedColor: Color
    let scale: CGFloat
    let isSelected: Bool
    let action: (()->Void)?
    var body: some View {
        VStack {
            Button(action: {
                self.action?()
            }) {
                VStack {
                    Circle()
                        .fill(isSelected ? selectedColor : .gray)
                        .overlay(
                            Image(systemName: systemName!)
                                .font(Font.title.weight(.semibold))
                        )
                        //.frame(maxWidth: 48, maxHeight: 48)
                        // .frame(width: 48, height: 48)
                        .frame(width: 48*scale, height: 48*scale)
                    Text(name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .lineLimit(1)
                }
                //                .scaleEffect(scale)
            }
        }
    }
    
}

struct ImageAspectFill : View {
    let name: String
    var body: some View {
        Image(self.name)
            .resizable()
            .aspectRatio(contentMode: .fill)
        
    }
}



struct GeometryGetter: View {
    @Binding var frame: CGRect
    var body: some View {
        GeometryReader { geometry -> Color in
            self.frame = geometry.frame(in: .named("HStack"))
            return Color.orange//.clear
        }
    }
}




extension AnyTransition {
    static var myTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        //   let removal = AnyTransition.scale.combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var slideTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var acceptBtnTransition: AnyTransition {
        let insertion = AnyTransition.opacity
        // let removal = AnyTransition.scale.combined(with: .opacity)
        let removal = AnyTransition.opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
 
//MARK:- Checkbox Field
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        isMarked: Bool,
        size: CGFloat = 10,
        color: Color = Color.black,
        textSize: CGFloat = 13,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
        self.isMarked = isMarked
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(.custom("Source Sans Pro", size: textSize))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}


struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}


struct GeneralList<Content: View>: View {
    let verticalSpacing: CGFloat
    let content: () -> Content
    var body: some View {
        Group {
//            if #available(iOS 14.0, *) {
//                ScrollView {
//                    AnyView(LazyVStack(alignment: .leading, spacing: verticalSpacing) {
//                        content()
//                        //.padding(.horizontal, 15)
//                        
//                    }
//                    )
//                }
//            } else {
//                List { content() }
//            }
            List() { content() }   
        }
    }
}
 
struct HideRowSeparatorModifier: ViewModifier {

  static let defaultListRowHeight: CGFloat = 44

  var insets: EdgeInsets
  var background: Color

  init(insets: EdgeInsets, background: Color) {
    self.insets = insets

    var alpha: CGFloat = 0
      if #available(iOS 14.0, *) {
          UIColor(background).getWhite(nil, alpha: &alpha)
      } else {
          // Fallback on earlier versions
      }
    assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
    self.background = background
  }

  func body(content: Content) -> some View {
    content
      .padding(insets)
      .frame(
        minWidth: 0, maxWidth: .infinity,
        minHeight: Self.defaultListRowHeight,
        alignment: .leading
      )
      .listRowInsets(EdgeInsets())
      .background(background)
  }
}

extension EdgeInsets {

  static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}

extension View {

  func hideRowSeparator(
    insets: EdgeInsets = .defaultListRowInsets,
    background: Color = .white
  ) -> some View {
    modifier(HideRowSeparatorModifier(
      insets: insets,
      background: background
    ))
  }
}

class TextLimiter: ObservableObject {
    private let limit: Int
    let objectWillChange = ObservableObjectPublisher()
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
//                
//                Utils.delay(1) {
//                    self.hasReachedLimit = false
//                }
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    
    var hasReachedLimit = false {
        willSet {
            objectWillChange.send()
        }
    }
}
