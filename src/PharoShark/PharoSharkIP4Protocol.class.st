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

{ #category : 'parsing' }
PharoSharkIP4Protocol class >> icmp6Type [
	^ 58
]

{ #category : 'parsing' }
PharoSharkIP4Protocol class >> icmpType [
	^ 1
]

{ #category : 'parsing' }
PharoSharkIP4Protocol class >> minimalHeaderSize [ 
	"Minimal possible IPv4 header size from specification"
	^  20
]

{ #category : 'parsing' }
PharoSharkIP4Protocol class >> tcpType [
	^ 6
]

{ #category : 'parsing' }
PharoSharkIP4Protocol class >> udpType [
	^ 17
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> checksum [
	"Returns checksum of this IPv4 packet."

	^ checksum
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> dstIP [
	"Return destination IP adress as string formated: x.x.x.x"

	^ '.' join: (dstIP asArray collect: [ :each | each asString ])
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
	"Returns IPv4 flags value."

	^ flags
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> id [
	"Returns identification value from IPv4 header."

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
	id := (aStream next: 2) asInteger.
	flags := (aStream next: 2) asInteger.

	timeToLive := aStream next.
	protocolNumber := aStream next.

	checksum := (aStream next: 2) asInteger.

	"IP addresses are not being converted to LE"
	srcIP := aStream next: 4.
	dstIP := aStream next: 4.

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
	"Returns code of the next inner protocol from IPv4 header."

	^ protocolNumber
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> shortName [

	^ 'IPv4'
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> srcIP [
	"Return source IP adress as string formated: x.x.x.x"

	^ '.' join: (srcIP asArray collect: [ :each | each asString ])
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> timeToLive [
	"Returns timeToLive of this IPv4 packet."

	^ timeToLive
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> totalLength [
	"Returns value of total length field from IPv4 header."

	^ totalLength
]
