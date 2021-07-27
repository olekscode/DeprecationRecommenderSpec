Class {
	#name : #DepOpenCommand,
	#superclass : #DepCommand,
	#category : #'DeprecationRecommender-Spec-Commands'
}

{ #category : #accessing }
DepOpenCommand class >> defaultDescription [
	^ 'Open the file containing the settings, project history, and recommendation'
]

{ #category : #initialization }
DepOpenCommand class >> defaultIconName [
	^ #glamorousOpen
]

{ #category : #accessing }
DepOpenCommand class >> defaultName [
	^ 'Open'
]

{ #category : #execution }
DepOpenCommand >> execute [
	| openFileDialog modelDictionary |
	
	openFileDialog := FDOpenFileDialog new whenSelected: [ :selectedFile |
		modelDictionary := selectedFile readStreamDo: [ :readStream |
			STON fromStream: readStream ].

		"..." ].
	
	openFileDialog openWithSpec 
]
