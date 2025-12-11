"
The presenter for subwindow that holds control buttons of the app: ""Open"" and ""Statistics"".
"
Class {
	#name : 'PharoSharkTopMenuPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parseFileCallaback',
		'openFileButton',
		'openStatisticsButton',
		'openStatisticWindowCallback'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> connectPresenters [

	openFileButton action: [
			parseFileCallaback ifNotNil: [
					openStatisticsButton enabled: true.
					parseFileCallaback value:
						((UIManager default chooseFullFileNameMatching: '*.pcap')
							 ifNotNil: [ :path | path asFileReference ]) ] ].

	openStatisticsButton action: [
			openStatisticWindowCallback ifNotNil: [
				openStatisticWindowCallback value ] ]
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal
			 add: openFileButton expand: false;
			 add: openStatisticsButton expand: false;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> instantiatePresenters [

	openFileButton := self newButton.
	openFileButton label: 'Open'.
	
	openStatisticsButton := self newButton.
	openStatisticsButton label: 'Staticstics'.
	openStatisticsButton enabled: false.
]

{ #category : 'accessing' }
PharoSharkTopMenuPresenter >> openStatisticWindowCallback: aCallback [
	openStatisticWindowCallback := aCallback 
]

{ #category : 'initialization' }
PharoSharkTopMenuPresenter >> parseFileCallaback: aCallback [

	parseFileCallaback := aCallback
]
