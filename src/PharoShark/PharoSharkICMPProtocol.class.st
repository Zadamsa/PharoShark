"
Represents 3(network) layer of ISO/OSI model. Parses and exposes: type, code, checksum.
"
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

{ #category : 'parsing' }
PharoSharkICMPProtocol class >> minimalHeaderSize [ 
	"type u8 + code u8 + checksum u16 + body u32"
	^  8
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> checksum [
	"Returns ICMP checksum of this packet"

	^ checksum
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> code [
	"Returns code of this ICMP packet."

	^ code
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> fieldsInfo [

	^ {
		  ('Type: ' , type asString).
		  ('Code: ' , code asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)) }
]

{ #category : 'initialization' }
PharoSharkICMPProtocol >> initializeFromStream: aStream [

	type := aStream next asInteger.
	code := aStream next asInteger.
	checksum := (aStream next: 2) asInteger.
	rest := (aStream next: 4) asInteger.

	^ true
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> nextProtocol [
	"ICMP cant hold inner protocols."

	^ nil
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> shortName [

	^ 'ICMP'
]

{ #category : 'accessing' }
PharoSharkICMPProtocol >> type [
	"Returns type of this ICMP message."

	^ type
]
