Class {
	#name : #BaselineOfDeprecationRecommenderSpec,
	#superclass : #BaselineOf,
	#category : #BaselineOfDeprecationRecommenderSpec
}

{ #category : #baselines }
BaselineOfDeprecationRecommenderSpec >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"External dependencies"
		spec
			baseline: 'DeprecationRecommender'
			with: [ spec repository: 'github://olekscode/DeprecationRecommender/src' ].
			
		spec
			baseline: 'FileDialog'
			with: [ spec repository: 'github://Ducasse/file-dialog/repository' ].
		
		"Packages"
		spec 
			package: 'DeprecationRecommender-Spec' with: [ spec requires: #(DeprecationRecommender FileDialog) ] ].
]
