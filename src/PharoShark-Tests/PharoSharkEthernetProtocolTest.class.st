Class {
	#name : 'PharoSharkEthernetProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkEthernetProtocolTest >> testInvalidLength1 [

	| ethernet bytes |
	"Ethernet from too short payload"
	bytes := ByteArray readHexFrom: '78447636' readStream.
	ethernet := PharoSharkEthernetProtocol parseStream: bytes readStream.
	self assert: ethernet isNil
]

{ #category : 'tests' }
PharoSharkEthernetProtocolTest >> testInvalidLength2 [

	| ethernet bytes |
	"Ethernet from empty payload"
	bytes := ByteArray readHexFrom: '' readStream.
	ethernet := PharoSharkEthernetProtocol parseStream: bytes readStream.
	self assert: ethernet isNil
]

{ #category : 'tests' }
PharoSharkEthernetProtocolTest >> testParsing [

	| ethernet bytes |
	"Valid ethernet header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         '784476369819dc53602b6a4c6666' readStream.
	ethernet := PharoSharkEthernetProtocol parseStream: bytes readStream.
	self assert: ethernet notNil.
	self assert: ethernet vlan isNil.
	self assert: ethernet shortName equals: 'Ethernet'.
	self assert: ethernet nextProtocol isNil
]
