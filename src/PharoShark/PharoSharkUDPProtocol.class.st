"
Represents 4(transport) layer of ISO/OSI model. Parses and exposes: source and destination ports, checksum.
"
Class {
	#name : 'PharoSharkUDPProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'srcPort',
		'dstPort',
		'length',
		'checksum'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkUDPProtocol class >> minimalHeaderSize [ 
	"Minimal possible UDP header size from specification"
	^  8
]

{ #category : 'accessing' }
PharoSharkUDPProtocol >> checksum [ 
	^ checksum 
]

{ #category : 'accessing' }
PharoSharkUDPProtocol >> dstPort [ 
	^ dstPort 
]

{ #category : 'accessing' }
PharoSharkUDPProtocol >> fieldsInfo [

	^ {
		  ('Source port: ' , srcPort asString).
		  ('Destination port: ' , dstPort asString).
		  ('Length: ' , length asString).
		  ('Checksum: ' , (checksum printStringBase: 16)) }
]

{ #category : 'initialization' }
PharoSharkUDPProtocol >> initializeFromStream: aStream [

	srcPort := (aStream next: 2) asInteger.
	dstPort := (aStream next: 2) asInteger.
	length := (aStream next: 2) asInteger.
	checksum := (aStream next: 2) asInteger.

	^ true
]

{ #category : 'accessing' }
PharoSharkUDPProtocol >> nextProtocol [
	^ nil
]

{ #category : 'default' }
PharoSharkUDPProtocol >> shortName [ 
	^ 'UDP'
]

{ #category : 'accessing' }
PharoSharkUDPProtocol >> srcPort [ 
	^ srcPort 
]
