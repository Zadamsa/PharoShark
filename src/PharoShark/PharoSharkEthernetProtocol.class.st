"
Represents 2(data) layer of ISO/OSI model. Parses and exposes: source and destination MAC addresses, vlan if presented.
"
Class {
	#name : 'PharoSharkEthernetProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'srcMac',
		'dstMac',
		'vlan',
		'nextProtocol'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkEthernetProtocol class >> ip4Type [
	^ 16r0800
]

{ #category : 'parsing' }
PharoSharkEthernetProtocol class >> ip6Type [
	^ 16r86DD
]

{ #category : 'formatt' }
PharoSharkEthernetProtocol class >> macToString: aMac [

	^ ':' join: (aMac asArray collect: [ :each |
			   (each printStringBase: 16) padLeftTo: 2 with: $0 ])
]

{ #category : 'parsing' }
PharoSharkEthernetProtocol class >> minimalHeaderSize [ 
	"u8 MAC[6][2] + u16 next protocol"
	^  14
]

{ #category : 'parsing' }
PharoSharkEthernetProtocol class >> vlanType [
	^ 16r8100
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> dstIP [
	"Returns textual representation of the dst IP if the inner protocol supports it"

	nextProtocol ifNil: [ ^ 'No' ] ifNotNil: [ ^ nextProtocol dstIP ]
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> fieldsInfo [

	^ {
		  ('Source MAC address: ' , (self class macToString: srcMac)).
		  ('Destination MAC address: ' , (self class macToString: dstMac)) .
			('VLAN id: ' , (vlan ifNil: [ 'Not presented' ] ifNotNil: [ (vlan bitAnd: 16r0FFF) asString ] ))}
]

{ #category : 'initialization' }
PharoSharkEthernetProtocol >> initializeFromStream: aStream [

	| nextType |
	dstMac := aStream next: 6.
	srcMac := aStream next: 6.
	nextType := (aStream next: 2) asInteger.
	[ nextType = self class vlanType ] whileTrue: [
			(self class enoughBytesLeftIn: aStream bytes: 4) ifFalse: [
				^ false ].
			vlan := (aStream next: 2) asInteger.
			nextType := (aStream next: 2) asInteger ].
	nextType = self class ip4Type ifTrue: [
		nextProtocol := PharoSharkIP4Protocol parseStream: aStream ].
	nextType = self class ip6Type ifTrue: [
		nextProtocol := PharoSharkIP6Protocol parseStream: aStream ].

	^ true
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> nextProtocol [
	^ nextProtocol 
]

{ #category : 'default' }
PharoSharkEthernetProtocol >> shortName [ 
	^ 'Ethernet'
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> srcIP [
	"Returns textual representation of the src IP if the inner protocol supports it"

	nextProtocol ifNil: [ ^ 'No' ] ifNotNil: [ ^ nextProtocol srcIP ]
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> vlan [
	"Returns vlan and TCI information as 2 bytes from ethernet header. Nil if not presented."

	^ vlan
]
