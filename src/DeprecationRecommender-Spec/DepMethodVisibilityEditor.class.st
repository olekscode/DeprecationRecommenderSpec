Class {
	#name : #DepMethodVisibilityEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'publicMethodsBrowser',
		'privateMethodsBrowser',
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
			add: '';
			add: #submitButton width: self buttonWidth;
			yourself) height: self buttonHeight;
		yourself.
]

{ #category : #initialization }
DepMethodVisibilityEditor >> connectPresenters [
	super connectPresenters.
	
	publicMethodsBrowser whenDroppedMethodsAccepted: [ :acceptedMethods |
		privateMethodsBrowser removeMethods: acceptedMethods ].
	
	privateMethodsBrowser whenDroppedMethodsAccepted: [ :acceptedMethods |
		publicMethodsBrowser removeMethods: acceptedMethods ].
	
	
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
	
	privateMethodsBrowser methods: aCollectionOfMethods
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
	
	publicMethodsBrowser methods: aCollectionOfMethods
]

{ #category : #'as yet unclassified' }
DepMethodVisibilityEditor >> publicMethodsExplanation [
	
	^ 'Methods that can be reused (public methods) -- drag and drop to edit'
]
