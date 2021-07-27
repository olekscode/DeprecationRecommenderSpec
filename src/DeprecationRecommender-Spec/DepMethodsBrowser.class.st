Class {
	#name : #DepMethodsBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'explanationLabel',
		'packagesList',
		'classesList',
		'protocolsTree',
		'methodsList',
		'methods',
		'selectedPackage',
		'selectedClass',
		'selectedProtocol',
		'selectedMethods',
		'onDroppedMethodsAcceptedCallback'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #specs }
DepMethodsBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 2;
		add: #explanationLabel height: self labelHeight;
		add: (SpBoxLayout newHorizontal
			spacing: 4;
			add: #packagesList;
			add: #classesList;
			add: #protocolsTree;
			add: #methodsList;
			yourself);
		yourself.
]

{ #category : #adding }
DepMethodsBrowser >> addMethods: aCollectionOfMethods [

	aCollectionOfMethods ifEmpty: [ ^ self ].

	methods addAll: aCollectionOfMethods.
	
	selectedPackage := aCollectionOfMethods anyOne packageName.
	selectedClass := aCollectionOfMethods anyOne className.
	selectedProtocol := aCollectionOfMethods anyOne protocol.
	selectedMethods := aCollectionOfMethods.
	 
	self showPackages.
	onDroppedMethodsAcceptedCallback value: aCollectionOfMethods.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> allProtocolsName [
	^ '-- all protocols --'
]

{ #category : #initialization }
DepMethodsBrowser >> connectPresenters [
	super connectPresenters.
	
	packagesList whenSelectionChangedDo: [
		packagesList selectedItem ifNotNil: [ 
			self showClassesInPackage: packagesList selectedItem ] ].
	
	classesList whenSelectionChangedDo: [
		classesList selectedItem ifNotNil: [ 
			self showProtocolsInClass: classesList selectedItem ] ].
	
	protocolsTree whenSelectionChangedDo: [
		(classesList selectedItem isNotNil and: [
			protocolsTree selectedItem isNotNil ]) ifTrue: [ 
				self
					showMethodsInClass: classesList selectedItem
					andProtocol: protocolsTree selectedItem key ] ].
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> emptyProtocolName [
	^ 'as yet unclassified'
]

{ #category : #accessing }
DepMethodsBrowser >> explanation: aString [

	explanationLabel label: aString.
]

{ #category : #initialization }
DepMethodsBrowser >> initializePresenters [
	super initializePresenters.
	
	explanationLabel := self newLabel.
	
	packagesList := self newList
		displayIcon: [ self iconNamed: #package ];
		yourself.
	
	classesList := self newList
		displayIcon: [ self iconNamed: #class ];
		yourself.
		
	protocolsTree := self newTree.
	
	methodsList := self newList
		display: [ :method | method selector ];
		beMultipleSelection;
		dragEnabled: true;
		wantsDrop: [ :transfer | transfer passenger allSatisfy: [ :each | each class = ClioMethod ] ];
		acceptDrop: [ :transfer | self addMethods: transfer passenger ];
		yourself.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> memorizeSelectedItems [
	selectedPackage := packagesList selectedItem.
	selectedClass := classesList selectedItem.
	selectedProtocol := protocolsTree selectedItem.
	selectedMethods := methodsList selectedItems.
]

{ #category : #accessing }
DepMethodsBrowser >> methods [

	^ methods
]

{ #category : #accessing }
DepMethodsBrowser >> methods: aCollectionOfMethods [

	methods := OrderedCollection withAll: aCollectionOfMethods.
	self showPackages.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> removeMethods: aCollectionOfMethods [
	self methods removeAllFoundIn: aCollectionOfMethods.
	self memorizeSelectedItems.
	self showPackages.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> restoreClassSelection [
	classesList items ifEmpty: [ ^ self ].
	selectedClass := selectedClass ifNil: [ classesList items first ].
	classesList selectItem: selectedClass.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> restoreMethodsSelection [
	methodsList items ifEmpty: [ ^ self ].
	
	(selectedMethods isNil or: [ selectedMethods isEmpty ])
		ifTrue: [ selectedMethods := { methodsList items first } ].
		
	methodsList selectItems: selectedMethods.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> restorePackageSelection [
	packagesList items ifEmpty: [ ^ self ].
	selectedPackage := selectedPackage ifNil: [ packagesList items first ].
	packagesList selectItem: selectedPackage.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> restoreProtocolSelection [
	protocolsTree roots ifEmpty: [ ^ self ].
	selectedProtocol := selectedProtocol ifNil: [ protocolsTree roots first ].
	protocolsTree selectItem: selectedProtocol.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> selectMethodsWithProtocol: aProtocol within: aCollectionOfMethods [
	
	aProtocol = self allProtocolsName
		ifTrue: [ ^ aCollectionOfMethods ].
	
	aProtocol = 'instance side'
		ifTrue: [ ^ aCollectionOfMethods reject: [ :method | method isClassSide ] ].
	
	aProtocol = 'class side'
		ifTrue: [ ^ aCollectionOfMethods select: [ :method | method isClassSide ] ].
		
	aProtocol = self emptyProtocolName
		ifTrue: [ ^ aCollectionOfMethods select: [ :method |
				method protocol isNil or: [ method protocol = self emptyProtocolName ] ] ].
		
	^ aCollectionOfMethods select: [ :method |
		method protocol = aProtocol ].
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> showClassesInPackage: aPackageName [
		
	classesList items: (methods
		select: [ :method | method packageName = aPackageName ]
		thenCollect: [ :method | method className ])
		asSet asArray sorted.
		
	self restoreClassSelection.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> showMethodsInClass: aClassName andProtocol: aProtocol [
	
	| methodsToDisplay |
	methodsToDisplay := methods select: [ :method | method className = aClassName ].
	methodsToDisplay := self selectMethodsWithProtocol: aProtocol within: methodsToDisplay.
		
	methodsList items: (methodsToDisplay asArray sorted: [ :a :b | a selector < b selector ]).
	self restoreMethodsSelection.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> showPackages [
	
	packagesList items: (methods collect: [ :method | method packageName ])
		asSet asArray sorted.
	
	self restorePackageSelection.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> showProtocolsInClass: aClassName [
	
	| instanceSideMethods classSideMethods instanceSideProtocols classSideProtocols |
	
	instanceSideMethods := methods reject: [ :method | method isClassSide ].
	classSideMethods := methods select: [ :method | method isClassSide ].
	
	instanceSideProtocols := (instanceSideMethods
		select: [ :method | method className = aClassName ]
		thenCollect: [ :method | method protocol ifNil: [ self emptyProtocolName ] ])
		asSet asOrderedCollection sorted.
		
	classSideProtocols := (classSideMethods
		select: [ :method | method className = aClassName ]
		thenCollect: [ :method | method protocol ifNil: [ self emptyProtocolName ] ])
		asSet asOrderedCollection sorted.
	
	protocolsTree
		roots: { self allProtocolsName -> {
			'instance side' -> (instanceSideProtocols collect: [ :each | each -> #() ]) .
			'class side' -> (classSideProtocols collect: [ :each | each -> #() ]) } };
		display: [ :each | each key ];
		children: [ :each | each value ].
		
	self restoreProtocolSelection.
]

{ #category : #'as yet unclassified' }
DepMethodsBrowser >> whenDroppedMethodsAccepted: aBlock [
	onDroppedMethodsAcceptedCallback := aBlock
]
