
import SwiftUI
//import RealmSwift



struct KeyBoardListView: View {
    weak var delegate: MorseKeyboardViewDelegate?
    let items = [ """
This goes
over multiple
lines
sdf
dsf
sdf
sdf
sdf
end
"""
             ,"abc","skdfkfdj"]
    var body: some View {
        
        
//        List(items, id: \.self) { item in
//
//
//            HStack {
//                Text(item).onTapGesture {
//                    delegate?.insertString(item)
//                }
//                //  .alignmentGuide(.leading) { d in d[.trailing] }
//                //.frame(maxWidth: .infinity)
//                //            .frame(alignment: .topLeading)
//
//                Spacer()
//            }
//               .border(Color.red, width: 2)
//            .font(.footnote)
//            .lineLimit(3)
//          //  .background(Color.purple)
//            .listRowInsets(EdgeInsets())
//            // .removeSeparator()
//
//        }
//        .background(Color.orange)
        VStack
        {
            GeneralList(verticalSpacing: 1) {
                ForEach(items, id: \.self)  { item in
                   
                    HStack {
                                  Text(item).onTapGesture {
                                      delegate?.insertString(item)
                                  }
                                  //  .alignmentGuide(.leading) { d in d[.trailing] }
                                  //.frame(maxWidth: .infinity)
                                  //            .frame(alignment: .topLeading)
                  
                                  Spacer()
                              }
                                 .border(Color.red, width: 1)
                              .font(.footnote)
                              .lineLimit(3)
                            //  .background(Color.purple)
                              .listRowInsets(EdgeInsets())
                              // .removeSeparator()
                }
            }
            //.listStyle(GroupedListStyle())
            .listRowBackground(Color.green)
            //.listSeparatorStyle(style: .none)
        }
                .edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().showsVerticalScrollIndicator = false
            
            UITableViewCell.appearance().selectionStyle = .none
        }
         
    }
}


 

//struct RowSeparatorModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        if #available(iOSApplicationExtension 15.0, *) {
////        if #available(iOS 14.0, *) {
//            content
//                .listRowSeparator(.hidden)
//        } else {
//            content
//        }
//    }
//}
//extension View {
//    func removeSeparator() -> some View {
//        modifier(RowSeparatorModifier())
//    }
//}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        return KeyBoardListView()
    }
}
