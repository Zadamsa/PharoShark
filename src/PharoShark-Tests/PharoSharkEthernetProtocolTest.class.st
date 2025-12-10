Class {
	#name : 'PharoSharkEthernetProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkEthernetProtocolTest >> testParsing [

	| ethernet bytes |
	bytes := ByteArray readHexFrom:
		         '784476369819dc53602b6a4c666666' readStream.
	ethernet := PharoSharkEthernetProtocol parseStream: bytes readStream .
	self assert: ethernet notNil.
	self assert: ethernet vlan isNil.
	self assert: ethernet shortName equals: 'Ethernet'.
	self assert: ethernet nextProtocol isNil
]
