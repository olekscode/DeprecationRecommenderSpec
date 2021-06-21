Class {
	#name : #DepSaveCommand,
	#superclass : #DepCommand,
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #accessing }
DepSaveCommand class >> defaultDescription [
	^ 'Save settings, project history, and recommendation into a file'
]

{ #category : #initialization }
DepSaveCommand class >> defaultIconName [ 
	^ #glamorousSave
]

{ #category : #accessing }
DepSaveCommand class >> defaultName [ 
	^ 'Save'
]

{ #category : #execution }
DepSaveCommand >> execute [
	| modelDictionary saveFileDialog |
	
	modelDictionary := { 
		"'settings' -> context settings .
		'projectHistory' -> context projectHistory .
		'recommendations' -> context recommendations"
	} asDictionary.
	
	saveFileDialog := FDSaveFileDialog new whenSelected: [ :selectedFile |
		selectedFile writeStreamDo: [ :writeStream |
			STON put: modelDictionary onStream: writeStream  ] ].
		
	saveFileDialog openWithSpec.
	
]
