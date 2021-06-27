Class {
	#name : #DepMethodVisibilityEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'explanationLabel',
		'publicPackagesList',
		'publicClassesList',
		'publicProtocolsList',
		'publicMethodsList',
		'privatePackagesList',
		'privateClassesList',
		'privateProtocolsList',
		'privateMethodsList',
		'submitButton',
		'publicMethods',
		'privateMethods'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #specs }
DepMethodVisibilityEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 2;
		add: #explanationLabel height: self labelHeight;
		add: (SpBoxLayout newHorizontal
			spacing: 4;
			add: #publicPackagesList;
			add: #publicClassesList;
			add: #publicProtocolsList;
			add: #publicMethodsList;
			yourself);
		add: (SpBoxLayout newHorizontal
			spacing: 4;
			add: #privatePackagesList;
			add: #privateClassesList;
			add: #privateProtocolsList;
			add: #privateMethodsList;
			yourself);
		add: (SpBoxLayout newHorizontal
			add: '';
			add: #submitButton width: self buttonWidth;
			yourself) height: self buttonHeight;
		yourself.
]

{ #category : #examples }
DepMethodVisibilityEditor class >> open [
	<example>
	self new openWithSpec
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> allProtocolsName [
	^ '-- all protocols --'
]

{ #category : #initialization }
DepMethodVisibilityEditor >> connectPresenters [
	super connectPresenters.
	
	publicPackagesList whenSelectionChangedDo: [
		publicPackagesList selectedItem ifNotNil: [ 
			self showPublicClassesInPackage: publicPackagesList selectedItem ] ].
	
	privatePackagesList whenSelectionChangedDo: [
		privatePackagesList selectedItem ifNotNil: [ 
			self showPrivateClassesInPackage: privatePackagesList selectedItem ] ].
	
	publicClassesList whenSelectionChangedDo: [
		publicClassesList selectedItem ifNotNil: [ 
			self showPublicProtocolsInClass: publicClassesList selectedItem ] ].
	
	privateClassesList whenSelectionChangedDo: [
		privateClassesList selectedItem ifNotNil: [ 
			self showPrivateProtocolsInClass: privateClassesList selectedItem ] ].
	
	publicProtocolsList whenSelectionChangedDo: [
		(publicClassesList selectedItem isNotNil and: [
			publicProtocolsList selectedItem isNotNil ]) ifTrue: [ 
				self
					showPublicMethodsInClass: publicClassesList selectedItem
					andProtocol: publicProtocolsList selectedItem ] ].
			
	privateProtocolsList whenSelectionChangedDo: [
		(privateClassesList selectedItem isNotNil and: [
			privateProtocolsList selectedItem isNotNil ]) ifTrue: [ 
				self
					showPrivateMethodsInClass: privateClassesList selectedItem
					andProtocol: privateProtocolsList selectedItem ] ].
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> emptyProtocolName [
	^ 'as yet unclassified'
]

{ #category : #initialization }
DepMethodVisibilityEditor >> initializePresenters [
	super initializePresenters.
	
	explanationLabel := self newLabel.
	
	publicPackagesList := self newList
		displayIcon: [ self iconNamed: #package ];
		yourself.
	
	publicClassesList := self newList
		displayIcon: [ self iconNamed: #class ];
		yourself.
		
	publicProtocolsList := self newList.
	
	publicMethodsList := self newList
		display: [ :method | method selector ];
		yourself.
	
	privatePackagesList := self newList
		displayIcon: [ self iconNamed: #package ];
		yourself.
		
	privateClassesList := self newList
		displayIcon: [ self iconNamed: #class ];
		yourself.
	
	privateProtocolsList := self newList.
	
	privateMethodsList := self newList
		display: [ :method | method selector ];
		yourself.
	
	submitButton := self newButton
		label: 'Submit';
		yourself.
		
	self showPublicPackages.
	self showPrivatePackages.
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> privateMethods [
	^ privateMethods
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> publicMethods [
	^ publicMethods
]

{ #category : #initialization }
DepMethodVisibilityEditor >> setModelBeforeInitialization: aDictionaryOfMethods [
	publicMethods := aDictionaryOfMethods at: 'public'.
	privateMethods := aDictionaryOfMethods at: 'private'.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPrivateClassesInPackage: aPackageName [
		
	privateClassesList items: (privateMethods
		select: [ :method | method packageName = aPackageName ]
		thenCollect: [ :method | method className ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPrivateMethodsInClass: aClassName andProtocol: aProtocol [
	
	| methods |
	methods := privateMethods select: [ :method | method className = aClassName ].
	
	aProtocol = self allProtocolsName ifFalse: [
		methods := aProtocol = self emptyProtocolName
			ifTrue: [
				methods select: [ :method |
					method protocol isNil or: [
						method protocol = aProtocol ] ] ]
			ifFalse: [ 
				methods select: [ :method | method protocol = aProtocol ] ] ].
		
	privateMethodsList items: (methods asArray sorted: [ :a :b | a selector < b selector ]).
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPrivatePackages [
		
	privatePackagesList items: (privateMethods collect: [ :method | method packageName ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPrivateProtocolsInClass: aClassName [
		
	privateProtocolsList items: (privateMethods
		select: [ :method | method className = aClassName ]
		thenCollect: [ :method | method protocol ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPublicClasses [
		
	publicClassesList items: (publicMethods collect: [ :method | method className ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPublicClassesInPackage: aPackageName [
		
	publicClassesList items: (publicMethods
		select: [ :method | method packageName = aPackageName ]
		thenCollect: [ :method | method className ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPublicMethodsInClass: aClassName andProtocol: aProtocol [
	
	| methods |
	methods := publicMethods select: [ :method | method className = aClassName ].
	
	aProtocol = self allProtocolsName ifFalse: [
		methods := aProtocol = self emptyProtocolName
			ifTrue: [
				methods select: [ :method |
					method protocol isNil or: [
						method protocol = aProtocol ] ] ]
			ifFalse: [ 
				methods select: [ :method | method protocol = aProtocol ] ] ].
		
	publicMethodsList items: (methods asArray sorted: [ :a :b | a selector < b selector ]).
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPublicPackages [
		
	publicPackagesList items: (publicMethods collect: [ :method | method packageName ])
		asSet asArray sorted.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> showPublicProtocolsInClass: aClassName [
		
	publicProtocolsList items: (publicMethods
		select: [ :method | method className = aClassName ]
		thenCollect: [ :method | method protocol ])
		asSet asArray sorted.
]
