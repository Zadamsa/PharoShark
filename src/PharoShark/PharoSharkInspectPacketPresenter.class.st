"
Presenter of subwindow that shows detailed info about selected packet and its payload.
"
Class {
	#name : 'PharoSharkInspectPacketPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'inspectedPacket',
		'rawBytes'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'initialization' }
PharoSharkInspectPacketPresenter >> connectPresenters [
"
	inspectedPacket
		whenSelectedDo: [ :selectedPacket | ]
"		
]

{ #category : 'defaults' }
PharoSharkInspectPacketPresenter >> defaultTextStyle [
    ^ SpTextStyle new
        fontName: 'Courier';
        pointSize: 12;
        yourself.

]

{ #category : 'initialization' }
PharoSharkInspectPacketPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal 
			 add: inspectedPacket;
			 add: rawBytes;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkInspectPacketPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'accessing' }
PharoSharkInspectPacketPresenter >> inspectedPacket: aPacket [

	inspectedPacket roots: { (PharoSharkPacketNode new packet: aPacket) }.
	rawBytes text:
		(' ' join: (aPacket rawBytes asArray collect: [ :each |
				  (each printStringBase: 16) padLeftTo: 2 with: $0 ]))
]

{ #category : 'as yet unclassified' }
PharoSharkInspectPacketPresenter >> instantiatePresenters [

	inspectedPacket := self instantiate: SpTreePresenter.
	inspectedPacket
		display: [ :node | node displayString ];
		children: [ :node | node children ].
	rawBytes := self instantiate: SpTextPresenter.
	rawBytes editable: false
]
