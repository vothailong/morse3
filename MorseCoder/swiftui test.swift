
import SwiftUI
//import RealmSwift



struct KeyBoardListView: View {
    weak var delegate: MorseKeyboardViewDelegate?
    let items = [ """
This goes
over multiple
sdfdsfsdfsdfsdfenddfdafsf
lines
sdjhfkjh
"""
                  ,"abc","skdfkfdj","def"]
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        
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
                    .padding()
                    .font(.footnote)
                    .lineLimit(4)
                    .listRowInsets(EdgeInsets())
                    .removeSeparator()
                    
                }
            }
            .listStyle(GroupedListStyle())//remove padding of the entire list
            //.listRowBackground(Color.green)
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




@available(iOS 14.0, *)
struct RowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.listRowSeparator(.hidden)//iOS 15+
        } else {
            content
        }
        
    }
}
extension View {
    func removeSeparator() -> some View {
        modifier(RowSeparatorModifier())
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        return KeyBoardListView()
    }
}
