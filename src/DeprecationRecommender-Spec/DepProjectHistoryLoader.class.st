Class {
	#name : #DepProjectHistoryLoader,
	#superclass : #SpPresenter,
	#instVars : [
		'loadFromGitHubLabel',
		'loadFromGitHubButton',
		'loadFromFileSystemLabel',
		'loadFromFileSystemButton',
		'placeholder'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #specs }
DepProjectHistoryLoader class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #placeholder;
		add: (SpBoxLayout newHorizontal
			add: #placeholder;
			add: (SpBoxLayout newHorizontal
				spacing: 15;
				add: #loadFromGitHubButton width: 160;
				add: #loadFromFileSystemButton width: 160;
				yourself) width: 340;
			add: '';
			yourself) height: self buttonHeight * 2;
		add: '';
		yourself.
]

{ #category : #examples }
DepProjectHistoryLoader class >> open [
	<example>
	self new openWithSpec.
]

{ #category : #initialization }
DepProjectHistoryLoader >> connectPresenters [
	super connectPresenters.
	
	loadFromGitHubButton action: [ 
		(ProjectLoader new
			"callback: [ :repository :oldVersionSha |
				self onProjectLoaded: repository oldVersion: oldVersionSha ];"
			yourself)
			openModalWithSpec. ]
]

{ #category : #initialization }
DepProjectHistoryLoader >> initializePresenters [ 
	super initializePresenters.
	
	loadFromGitHubLabel := self newLabel
		label: 'Option 1. Load project history from a GitHub repository. This operation might be time consuming depending on the size of the project. Before you proceed, load your project using Iceberg.';
		yourself.
		
	loadFromGitHubButton := self newButton
		label: 'Load from GitHub';
		icon: (self iconNamed: #github);
		yourself.
		
	loadFromFileSystemLabel := self newLabel
		label: 'Option 2. Load presaved project history from file system.';
		yourself.
		
	loadFromFileSystemButton := self newButton
		label: 'Load from file system';
		icon: (self iconNamed: #open);
		yourself.
		
	placeholder := self newNullPresenter.
]
