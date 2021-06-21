Class {
	#name : #DepLoadProjectCommand,
	#superclass : #DepCommand,
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #accessing }
DepLoadProjectCommand class >> defaultDescription [
	^ 'Load project from Iceberg'
]

{ #category : #initialization }
DepLoadProjectCommand class >> defaultIconName [
	^ #github
]

{ #category : #accessing }
DepLoadProjectCommand class >> defaultName [
	^ 'Select'
]

{ #category : #execution }
DepLoadProjectCommand >> execute [
	(ProjectLoader new
		callback: [ :repository :oldVersionSha |
			context onProjectLoaded: repository oldVersion: oldVersionSha  ];
		yourself)
		openWithSpec.
]
