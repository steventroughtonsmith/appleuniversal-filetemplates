//___FILEHEADER___

import UIKit

class ___FILEBASENAME___: UICollectionViewController {
	enum Section {
		case main
	}
	
	struct Item: Hashable {
		var identifier = UUID().uuidString

		func hash(into hasher: inout Hasher) {
			hasher.combine(identifier)
		}
		
		static func == (lhs: Item, rhs: Item) -> Bool {
			return lhs.identifier == rhs.identifier
		}
	}
	
	typealias ItemType = Item

	let reuseIdentifier = "Cell"
	var dataSource: UICollectionViewDiffableDataSource<Section, ItemType>! = nil
	var currentItems:[ItemType] = []

	let padding = CGFloat(20)

	init() {
		let layout = UICollectionViewFlowLayout()
		
		super.init(collectionViewLayout: layout)
		guard let collectionView = collectionView else { return }

		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		if #available(iOS 15.0, *) {
			collectionView.allowsFocus = true
		}
		
		collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

		configureDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	override func viewDidLayoutSubviews() {
		var columns = 2
		let maxWidth = CGFloat(200)
		
		guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		
		while view.bounds.size.width/CGFloat(columns) > maxWidth
		{
			columns += 1
		}
		
		let usableWidth = collectionView.bounds.width-collectionView.contentInset.left-collectionView.contentInset.right
		let itemSize = (usableWidth - padding*((CGFloat(columns-1)))) / CGFloat(columns)
		
		layout.itemSize = CGSize(width: itemSize, height: itemSize)
		layout.minimumLineSpacing = padding
	}

	// MARK: - Data Source
	
	func configureDataSource() {
		
		dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: ItemType) -> UICollectionViewCell? in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
			
			var config = UIListContentConfiguration.cell()
			
			config.text = "Cell"
			config.textProperties.alignment = .center

			cell.contentConfiguration = config
			
			var bg = UIBackgroundConfiguration.listPlainCell()
			bg.cornerRadius = CGFloat(8)
			bg.backgroundColor = .systemFill
			cell.backgroundConfiguration = bg
			
			return cell
		}
		
		collectionView.dataSource = dataSource
		
		refresh()
	}
		
	func snapshot() -> NSDiffableDataSourceSectionSnapshot<ItemType> {
		var snapshot = NSDiffableDataSourceSectionSnapshot<ItemType>()
		
		for _ in 0 ..< 9 {
			currentItems.append(ItemType())
		}

		snapshot.append(currentItems)
		
		return snapshot
	}
	
	func refresh() {
		guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<Section, ItemType> else { return }
		
		dataSource.apply(snapshot(), to: .main, animatingDifferences: false)
	}
}
