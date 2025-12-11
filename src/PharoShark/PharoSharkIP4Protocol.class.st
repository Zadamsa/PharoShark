"
Represents 3(network) layer of ISO/OSI model. Parses and exposes: source and destination IP addresses, next level protocol ID, checksum, IP flags, TTL and ID fields.
"
Class {
	#name : 'PharoSharkIP4Protocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'version',
		'headerLength',
		'totalLength',
		'id',
		'flags',
		'timeToLive',
		'ipProtocol',
		'checksum',
		'srcIP',
		'dstIP',
		'options',
		'protocolNumber',
		'nextProtocol'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> icmp6Type [
	^ 58
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> icmpType [
	^ 1
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> minimalHeaderSize [ 
	"Minimal possible IPv4 header size from specification"
	^  20
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> tcpType [
	^ 6
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> udpType [
	^ 17
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> checksum [
	^ checksum 
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> dstIP [
	^ '.' join: (dstIP asArray collect: [ :each | each asString ]).
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> fieldsInfo [

	^ {
		  ('IP version: ' , version asString).
		  ('IP header length: ' , headerLength asString).
		  ('Total length: ' , totalLength asString).
		  ('ID: ' , id asString).
		  ('IP flags: 0b' , (flags printStringBase: 2)).
		  ('TTL: ' , timeToLive asString).
		  ('Protocol: ' , protocolNumber asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)).
		  ('Source address: ' , self srcIP).
		  ('Destination address: ' , self dstIP) }
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> flags [ 
	^ flags 
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> id [ 
	^ id 
]

{ #category : 'initialization' }
PharoSharkIP4Protocol >> initializeFromStream: aStream [

	| firstByte optionsLength |
	firstByte := aStream next.

	version := firstByte >> 4.
	headerLength := firstByte bitAnd: 16r0F.

	"Cannot be less than 5"
	headerLength < 5 ifTrue: [ ^ false ].
	headerLength := headerLength * 4.

	"Skip QOS/DSCP/ECN"
	aStream skip: 1.
	totalLength := (aStream next: 2) asInteger.
	id := (aStream next: 2) reversed asInteger.
	flags := (aStream next: 2) reversed asInteger.

	timeToLive := aStream next.
	protocolNumber := aStream next.

	checksum := (aStream next: 2) asInteger.

	"IP addresses are not being converted to LE"
	srcIP := aStream next: 4.
	dstIP := aStream next: 4 .

	"Skip options"
	optionsLength := headerLength - 20.
	aStream skip: optionsLength.
	
	^ self intializeSuccessorFromStream: aStream nextType: protocolNumber
]

{ #category : 'initialization' }
PharoSharkIP4Protocol >> intializeSuccessorFromStream: aStream nextType: aNextType [

	aNextType = self class tcpType ifTrue: [
		nextProtocol := PharoSharkTCPProtocol parseStream: aStream ].

	aNextType = self class udpType ifTrue: [
		nextProtocol := PharoSharkUDPProtocol parseStream: aStream ].

	aNextType = self class icmpType ifTrue: [
		nextProtocol := PharoSharkICMPProtocol parseStream: aStream ].

	aNextType = self class icmp6Type ifTrue: [
		nextProtocol := PharoSharkICMP6Protocol parseStream: aStream ].
	^ true
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> nextProtocol [
	^ nextProtocol 
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> protocolNumber [
	^ protocolNumber 
]

{ #category : 'default' }
PharoSharkIP4Protocol >> shortName [ 
	^ 'IPv4'
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> srcIP [

	^ '.' join: (srcIP asArray collect: [ :each | each asString ])
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> timeToLive [ 
	^ timeToLive 
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> totalLength [ 
	^ totalLength 
]
