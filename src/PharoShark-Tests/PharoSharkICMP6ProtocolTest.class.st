Class {
	#name : 'PharoSharkICMP6ProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkICMP6ProtocolTest >> testInvalidLength1 [

	| icmpProtocol bytes |
	"ICMP6 header with missing byte"
	bytes := ByteArray readHexFrom: '8f001bb4000000' readStream.
	icmpProtocol := PharoSharkICMP6Protocol parseStream: bytes readStream.
	self assert: icmpProtocol isNil
]

{ #category : 'tests' }
PharoSharkICMP6ProtocolTest >> testParsing [

	| icmpProtocol bytes |
	"ICMP6 header without body"
	bytes := ByteArray readHexFrom: '8f001bb400000001' readStream.
	icmpProtocol := PharoSharkICMP6Protocol parseStream: bytes readStream.
	self assert: icmpProtocol notNil.
	self assert: icmpProtocol type equals: 143.
	self assert: icmpProtocol code equals: 0.
	self assert: icmpProtocol checksum equals: 16r1bb4.
	self assert: icmpProtocol shortName equals: 'ICMPv6'
]
