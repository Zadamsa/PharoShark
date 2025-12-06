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
	"TODO open file window"

	"openFileButton action: [
			openedFile := UIManager default chooseFullFileNameMatching: '*.pcap' ].
"

	"UIManager default  alert: 'test' title: 'test' ."

	topMenu parseFileCallaback: [ :aFile | model parseFile: aFile ].

	packetsListWindow
		items: model packets;
		whenSelectedDo: [ :doubleClickedPacket |  ];
		whenActivatedDo: [ :singleClickedPacket |  ]
]

{ #category : 'initialization' }
PharoSharkPresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
             add: topMenu expand: false ;
             add: packetsListWindow ;
             add: inspectPacketSubwindow;
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
	packetsListWindow := self instantiate: SpListPresenter.
	model := PharoSharkModel new.

	inspectPacketSubwindow := self instantiate: SpNullPresenter
]
