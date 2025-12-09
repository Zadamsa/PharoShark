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

{ #category : 'as yet unclassified' }
PharoSharkTCPProtocol >> nextProtocol [
	^ nil
]

{ #category : 'default' }
PharoSharkTCPProtocol >> shortName [ 
	^ 'TCP'
]

{ #category : 'accessing' }
PharoSharkTCPProtocol >> srcPort [
	^ srcPort 
]
