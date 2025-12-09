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

	srcPort := (aStream next: 2) reversed asInteger.
	dstPort := (aStream next: 2) reversed asInteger.
	length := (aStream next: 2) reversed asInteger.
	checksum := (aStream next: 2) reversed asInteger.

	^ true
]

{ #category : 'as yet unclassified' }
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
