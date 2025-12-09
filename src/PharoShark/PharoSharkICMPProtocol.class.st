Class {
	#name : 'PharoSharkICMPProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'type',
		'code',
		'checksum',
		'rest'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'accessing' }
PharoSharkICMPProtocol >> fieldsInfo [

	^ {
		  ('Type: ' , type asString).
		  ('Code: ' , code asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)) }
]

{ #category : 'initialization' }
PharoSharkICMPProtocol >> initializeFromStream: aStream [

	type := (aStream next: 1) reversed asInteger.
	code := (aStream next: 1) reversed asInteger.
	checksum := (aStream next: 2) reversed asInteger.
	rest := (aStream next: 4) reversed asInteger.

	^ true
]

{ #category : 'as yet unclassified' }
PharoSharkICMPProtocol >> nextProtocol [
	^ nil
]

{ #category : 'default' }
PharoSharkICMPProtocol >> shortName [ 
	^ 'ICMP'
]
