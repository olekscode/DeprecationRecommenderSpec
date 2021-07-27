Class {
	#name : #DepClassModel,
	#superclass : #Object,
	#instVars : [
		'aClass',
		'methods'
	],
	#category : #'DeprecationRecommender-Spec-Models'
}

{ #category : #accessing }
DepClassModel >> children [
	^ self methods
]

{ #category : #'instance creation' }
DepClassModel >> class: anObject [
	aClass := anObject
]

{ #category : #accessing }
DepClassModel >> icon [

	^ self iconNamed: #class
]

{ #category : #initialization }
DepClassModel >> initialize [
	super initialize.
	methods := OrderedCollection new.
]

{ #category : #accessing }
DepClassModel >> methods [
	^ methods
]

{ #category : #accessing }
DepClassModel >> name [
	^ '{1} ({2})' format: { aClass name . methods size }
]
