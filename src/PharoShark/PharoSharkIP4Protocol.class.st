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
PharoSharkIP4Protocol class >> tcpType [
	^ 6
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol class >> udpType [
	^ 17
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> dstIP [

	^ (dstIP inject: '' into: [ :acc :b | acc , b asString , '.']) allButLast .

	"
	^ '.' join: (dstIP collect: [ :b | b asString ])"
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
		  ('Destination address: ' , self dstIP)
		  "options ?? ." }
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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol >> nextProtocol [
	^ nextProtocol 
]

{ #category : 'as yet unclassified' }
PharoSharkIP4Protocol >> protocolNumber [
	^ protocolNumber 
]

{ #category : 'default' }
PharoSharkIP4Protocol >> shortName [ 
	^ 'IPv4'
]

{ #category : 'accessing' }
PharoSharkIP4Protocol >> srcIP [


	^ (srcIP inject: '' into: [ :acc :b | acc , b asString , '.' ]) allButLast .
]
