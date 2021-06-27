Class {
	#name : #DepMethodVisibilityEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'publicMethodsBrowser',
		'privateMethodsBrowser',
		'summaryLabel',
		'submitButton'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #specs }
DepMethodVisibilityEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 2;
		add: #publicMethodsBrowser;
		add: #privateMethodsBrowser;
		add: (SpBoxLayout newHorizontal
			add: #summaryLabel;
			add: #submitButton width: self buttonWidth;
			yourself) height: self buttonHeight;
		yourself.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> connectPresenters [
	super connectPresenters.
	
	publicMethodsBrowser whenDroppedMethodsAccepted: [ :acceptedMethods |
		privateMethodsBrowser removeMethods: acceptedMethods.
		self updateSummary ].
	
	privateMethodsBrowser whenDroppedMethodsAccepted: [ :acceptedMethods |
		publicMethodsBrowser removeMethods: acceptedMethods.
		self updateSummary ].
	
	
]

{ #category : #initialization }
DepMethodVisibilityEditor >> initializePresenters [
	super initializePresenters.
	
	publicMethodsBrowser := DepMethodsBrowser new
		explanation: self publicMethodsExplanation;
		yourself.
		
	privateMethodsBrowser := DepMethodsBrowser new
		explanation: self privateMethodsExplanation;
		yourself.
		
	summaryLabel := self newLabel.
	
	submitButton := self newButton
		label: 'Submit';
		yourself.
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> privateMethods [
	^ privateMethodsBrowser methods
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> privateMethods: aCollectionOfMethods [
	
	privateMethodsBrowser methods: aCollectionOfMethods.
	self updateSummary.
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> privateMethodsExplanation [
	
	^ 'Methods that should not be reused (private methods) -- drag and drop to edit'
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> publicMethods [
	^ publicMethodsBrowser methods
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> publicMethods: aCollectionOfMethods [
	
	publicMethodsBrowser methods: aCollectionOfMethods.
	self updateSummary.
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> publicMethodsExplanation [
	
	^ 'Methods that can be reused (public methods) -- drag and drop to edit'
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> updateSummary [
	
	(publicMethodsBrowser methods isNil or: [ privateMethodsBrowser methods isNil ])
		ifTrue: [ ^ self ].
	
	summaryLabel
		label: ('{1} public and {2} private methods' format: {
			publicMethodsBrowser methods size .
			privateMethodsBrowser methods size
		}).
]
