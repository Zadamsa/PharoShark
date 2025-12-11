"
Main window presenter. Holds all other subwindows.
"
Class {
	#name : 'PharoSharkPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'openFileButton',
		'packetsListWindow',
		'inspectPacketSubwindow',
		'model',
		'parsedPackets',
		'openedFile',
		'topMenu'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'initialization' }
PharoSharkPresenter >> connectPresenters [

	topMenu parseFileCallaback: [ :aFile |
			| parsingResult |
			parsingResult := model parseFile: aFile.
			parsingResult first = #success ifTrue: [
				packetsListWindow packets: parsingResult second ].
			parsingResult first = #error ifTrue: [
					UIManager default inform:
						'Parsing error occured ' , parsingResult second ] ].

	topMenu openStatisticWindowCallback: [
			| statisticsWindow |
			statisticsWindow := self instantiate: PharoSharkStatisticsWindow.
			model packetStatistics ifNotNil: [
					statisticsWindow packetStatistics: model packetStatistics.
					statisticsWindow open ] ]
]

{ #category : 'initialization' }
PharoSharkPresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
             add: topMenu expand: false ;
             add: packetsListWindow ;
             spacing: 10;
             yourself)
]

{ #category : 'initialization' }
PharoSharkPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'initialization' }
PharoSharkPresenter >> initializeWindow: aWindowPresenter [

    aWindowPresenter
        title: 'PharoShark';
        initialExtent: 1280 @ 640
]

{ #category : 'as yet unclassified' }
PharoSharkPresenter >> instantiatePresenters [
	"Task List button to (re)open PCAP"

	"openFileButton := self newButton.
	openFileButton label: 'Open'."

	topMenu := self instantiate: PharoSharkTopMenuPresenter.
	packetsListWindow := self instantiate: PharoSharkPacketListPresenter .
	model := PharoSharkModel new.

]
