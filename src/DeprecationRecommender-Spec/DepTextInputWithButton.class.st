Class {
	#name : #DepTextInputWithButton,
	#superclass : #SpPresenter,
	#instVars : [
		'selectButton',
		'textInput'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #specs }
DepTextInputWithButton class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			add: #textInput;
			add: #selectButton width: self inputTextHeight;
			yourself) height: (self inputTextHeight - 7);
		yourself.
]

{ #category : #accessing }
DepTextInputWithButton >> action: aBlock [
	selectButton action: aBlock
]

{ #category : #initialization }
DepTextInputWithButton >> initializePresenters [
	super initializePresenters.
	
	textInput := self newTextInput.
	
	selectButton := self newButton
		icon: (self iconNamed: #smallFind);
		yourself.
]

{ #category : #accessing }
DepTextInputWithButton >> text [
	^ textInput text
]

{ #category : #accessing }
DepTextInputWithButton >> text: aString [
	textInput text: aString
]
