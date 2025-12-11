"
Represents 4(transport) layer of ISO/OSI model. Parses and exposes: source and destination ports, sequence and acknowledgement numbers, TCP flags, window size.
"
Class {
	#name : 'PharoSharkTCPProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'srcPort',
		'dstPort',
		'seq',
		'ack',
		'headerLength',
		'flags',
		'window',
		'checksum',
		'urgentPtr'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkTCPProtocol class >> minimalHeaderSize [ 
	"Minimal possible TCP header size from specification"
	^  20
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> acknowledgment [ 
	^ ack
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> checksum [ 
	^ checksum 
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> dstPort [
	^ dstPort
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> fieldsInfo [

	^ {
		  ('Source port: ' , srcPort asString).
		  ('Destination port: ' , dstPort asString).
		  ('Sequence: ' , seq asString).
		  ('Acknowledge: ' , ack asString).
		  ('Header length: ' , headerLength asString).
		  ('Flags: 0b' , (flags printStringBase: 2)).
		  ('Window: ' , window asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)).
		  ('Urgent: ' , urgentPtr asString) }
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> flags [ 
	^ flags 
]

{ #category : 'initialization' }
PharoSharkTCPProtocol >> initializeFromStream: aStream [

	srcPort := (aStream next: 2) asInteger.
	dstPort := (aStream next: 2) asInteger.
	seq := (aStream next: 4) asInteger.
	ack := (aStream next: 4) asInteger.
	headerLength := (aStream next) asInteger >> 4.
	flags := (aStream next)  asInteger.
	window := (aStream next: 2) asInteger.
	checksum := (aStream next: 2) asInteger.
	urgentPtr := (aStream next: 2) asInteger.

	^ true
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> nextProtocol [
	^ nil
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> sequence [ 
	^ seq
]

{ #category : 'default' }
PharoSharkTCPProtocol >> shortName [ 
	^ 'TCP'
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> srcPort [
	^ srcPort 
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> window [ 
	^ window 
]
