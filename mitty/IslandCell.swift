import UIKit
import PureLayout

class IslandCell: UICollectionViewCell {
    static let id = "island-cell"
    
    // MARK: - View Elements
    var island : Island?
    
    let name: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        name = UILabel.newAutoLayout()
        
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
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        
        name.autoPinEdgesToSuperviewMargins()
        
    }
    
    func configureView(island: Island) {
        
        self.island = island
        
        name.numberOfLines = 2
        name.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        name.text = "#" + (island.name ?? "")
        
    }
}
