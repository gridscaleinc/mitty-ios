import UIKit
import PureLayout

class IslandCell: UICollectionViewCell {
    static let id = "island-cell"
    
    // MARK: - View Elements
    var island : IslandInfo?
    
    let name: UILabel
    
    let icon: UIImageView
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        name = UILabel.newAutoLayout()
        icon = UIImageView.newAutoLayout()
        
        super.init(frame: frame)
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(icon)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        
        name.autoPinEdge(toSuperviewEdge: .top)
        name.autoPinEdge(toSuperviewEdge: .left)
        name.autoPinEdge(toSuperviewEdge: .bottom)
        name.autoPinEdge(toSuperviewEdge: .right, withInset: 70)
        
        icon.autoPinEdge(toSuperviewEdge: .top)
        icon.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        icon.autoPinEdge(toSuperviewEdge: .bottom)
        icon.autoSetDimension(.width, toSize: 50)
        
        
    }

    func configureView(island: IslandInfo) {
        
        self.island = island
        
        name.numberOfLines = 2
        name.text = "#" + (island.name )
        name.textColor = MittyColor.labelColor
        
        icon.image = UIImage(named: "timesquare")
        icon.contentMode = .scaleAspectFit
        
    }
}
