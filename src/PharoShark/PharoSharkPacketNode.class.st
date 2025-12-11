"
Helper presenter class required to print subprotocol info as part of pop-up menu.
"
Class {
	#name : 'PharoSharkPacketNode',
	#superclass : 'Object',
	#instVars : [
		'packet'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'converting' }
PharoSharkPacketNode >> asPresenterOn: aBuilder [
    ^ SpLabelPresenter new
        label: self displayString;
        yourself.

]

{ #category : 'accessing' }
PharoSharkPacketNode >> children [

	| children |
	children := (packet fieldsInfo collect: [ :string |
			             PharoSharkLabelNode new
				             label: string;
				             yourself ]) asOrderedCollection.
	packet nextProtocol ifNotNil: [ :nextProtocol |
		children add: (self class new packet: nextProtocol) ].
	^ children
]

{ #category : 'displaying' }
PharoSharkPacketNode >> displayString [

	^ packet ifNotNil: [ packet shortName ] ifNil: [ '' ]
]

{ #category : 'accessing' }
PharoSharkPacketNode >> packet: aPacket [
    packet := aPacket.
]

{ #category : 'accessing' }
PharoSharkPacketNode >> textStyle [
    ^ SpTextStyle new
        fontName: 'Arial';
        pointSize: 132;
        yourself.

]
