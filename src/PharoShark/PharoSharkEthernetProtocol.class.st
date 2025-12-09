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

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol class >> ip4Type [
	^ 16r0800
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol class >> ip6Type [
	^ 16r86DD
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol class >> macToString: aMac [

	^ ':' join: (aMac asArray collect: [ :each |
			   (each printStringBase: 16) padLeftTo: 2 with: $0 ])
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol class >> vlanType [
	^ 16r8100
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol >> dstIP [

	nextProtocol ifNil: [ ^ 'No' ] ifNotNil: [ ^ nextProtocol dstIP ]
]

{ #category : 'accessing' }
PharoSharkEthernetProtocol >> fieldsInfo [

	^ {
		  ('Source MAC address: ' , (self class macToString: srcMac)).
		  ('Destination MAC address:' , (self class macToString: dstMac)) .
			('VLAN id: ' , (vlan ifNil: [ 'Not presented' ] ifNotNil: [ (vlan bitAnd: 16r0FFF) asString ] ))}
]

{ #category : 'initialization' }
PharoSharkEthernetProtocol >> initializeFromStream: aStream [

	| nextType |
	dstMac := aStream next: 6.
	srcMac := aStream next: 6.
	nextType := (aStream next: 2) asInteger.
	nextType = self class ip4Type ifTrue: [
		nextProtocol := PharoSharkIP4Protocol parseStream: aStream ].
	nextType = self class ip6Type ifTrue: [
		nextProtocol := PharoSharkIP6Protocol parseStream: aStream ].
	nextType = self class vlanType ifTrue: [ "Skip TCI"
			aStream skip: 2.
			vlan := (aStream next: 2) reversed asInteger ].
	aStream atEnd ifTrue: [ ^ false ].
	^ true
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol >> nextProtocol [
	^ nextProtocol 
]

{ #category : 'default' }
PharoSharkEthernetProtocol >> shortName [ 
	^ 'Ethernet'
]

{ #category : 'as yet unclassified' }
PharoSharkEthernetProtocol >> srcIP [

	nextProtocol ifNil: [ ^ 'No' ] ifNotNil: [ ^ nextProtocol srcIP ]
]
