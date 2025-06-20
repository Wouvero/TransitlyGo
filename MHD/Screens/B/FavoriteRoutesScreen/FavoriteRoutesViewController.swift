//
//
//
// Created by: Patrik Drab on 21/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import SwiftUI


class FavoriteRoutesViewController: UIViewController, MHD_NavigationDelegate {
    
    
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Obľúbené", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteView = FavoriteView()
        let hostingController = UIHostingController(rootView: favoriteView)
        
        attachSwiftUIHostingController(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .neutral10
        
        fetchFavorites()
    }
    
    func fetchFavorites() {
        let context = MHD_CoreDataManager.shared.viewContext
        let favorites = MHD_Favorite.getAll(in: context)
        print("ALL favorite: \(favorites)")
    }
    
}

extension UIViewController {
    func attachSwiftUIHostingController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

struct Favorite: Hashable {
    let from: String
    let to: String
}

struct FavoriteView: View {
    
    
    let data: [Favorite] = [
        Favorite(from: "Laca Novomestkeho", to: "Sidlisko III"),
        Favorite(from: "Sidlisko III", to: "Zeleznicna stanica")
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(data, id:\.self) { item in
                    FavoriteItem(item: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(.neutral10)
    }
}

struct FavoriteItem: View {
    let item: Favorite
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    private let buttonWidth: CGFloat = 50
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                edditButton
                deleteButton
            }
            
            foregroundContent
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged{ gesture in
                            let newOffset = lastOffsetX + gesture.translation.width
                                                        
                            // Clamp the value between -buttonWidth and 0
                            offsetX = min(0, max(-buttonWidth*2, newOffset))
                        }
                        .onEnded{ gesture in
                            lastOffsetX = offsetX
                            
                            // Snap to nearest position
                            if offsetX < -100 * 0.75 {
                                offsetX = -100 // Fully open
                            } else if offsetX < -100 * 0.25 {
                                offsetX = -buttonWidth // Half open
                            } else {
                                offsetX = 0 // Closed
                            }
                            
                            lastOffsetX = offsetX // Store final position
                        }
                )
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .animation(.spring(), value: offsetX)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.neutral.opacity(0.5)) // Background color
                .stroke(.neutral600.opacity(0.7), lineWidth: 1) // Border
        )
    }
    
    
    private var deleteButton: some View {
        Button {
        
        } label: {
            Image(systemName: "trash")
                .frame(width: buttonWidth)
                .frame(maxHeight: .infinity)
                .background(.danger200)
                .foregroundStyle(.danger700)
                .fontWeight(.semibold)
        }
    }
    
    private var edditButton: some View {
        Button {
        
        } label: {
            Image(systemName: "pencil")
                .frame(width: buttonWidth)
                .frame(maxHeight: .infinity)
                .background(.warning200)
                .foregroundStyle(.warning700)
                .fontWeight(.semibold)
        }
    }
    
    private var foregroundContent: some View {
        HStack {
            Image(systemName: SFSymbols.search)
                .fontWeight(.semibold)
                .font(.system(size: 36))
            VStack {
                HStack {
                    Image(systemName: SFSymbols.arrowDownLeft)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.neutral700)
                    Text("\(item.from)")
                    Spacer()
                }
                HStack {
                    Image(systemName: SFSymbols.arrowUpForward)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.neutral700)
                    Text("\(item.to)")
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(.neutral) // Background color
        )
        .foregroundStyle(.neutral600)
    }
}

struct HHPreviewProvider: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

class Shape: UIView {
    
    private let shapeLayer = CAShapeLayer()
    
    var reverse: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = UIColor.primary500.cgColor
        shapeLayer.strokeColor = UIColor.neutral800.cgColor
        shapeLayer.lineWidth = 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = createPath().cgPath
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        
        
        if reverse {
            path.move(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 60, y: height))
            path.addLine(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.close()
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width - 60, y: 0))
            path.addLine(to: CGPoint(x: width, y: height / 2))
            path.addLine(to: CGPoint(x: width - 60, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.close()
        }
        
        return path
    }
}
