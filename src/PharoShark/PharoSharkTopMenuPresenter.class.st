Class {
	#name : 'PharoSharkTopMenuPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parseFileCallaback',
		'openFileButton'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> connectPresenters [

	openFileButton action: [
			parseFileCallaback ifNotNil: [
					parseFileCallaback value:
						((UIManager default chooseFullFileNameMatching: '*.pcap') ifNotNil: [ :path | path asFileReference ]) ] ]
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal
			 add: openFileButton expand: false;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'as yet unclassified' }
PharoSharkTopMenuPresenter >> instantiatePresenters [

	openFileButton := self newButton.
	openFileButton label: 'Open'
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> parseFileCallaback: aCallback [
	parseFileCallaback := aCallback 
]
