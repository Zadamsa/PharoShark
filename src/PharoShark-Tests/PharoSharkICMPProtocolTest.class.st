Class {
	#name : 'PharoSharkICMPProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkICMPProtocolTest >> testInvalidLength1 [

	| icmpProtocol bytes |
	"ICMP from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	icmpProtocol := PharoSharkUDPProtocol parseStream: bytes readStream.
	self assert: icmpProtocol isNil
]

{ #category : 'tests' }
PharoSharkICMPProtocolTest >> testParsing [

	| icmpProtocol bytes |
	"Valid UDP header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         '0800495c030001006162636465666768696a6b6c6d6e6f7071727374757677616263646566676869'
			         readStream.
	icmpProtocol := PharoSharkICMPProtocol parseStream: bytes readStream.
	self assert: icmpProtocol notNil.
	self assert: icmpProtocol type equals: 8.
	self assert: icmpProtocol code equals: 0.
	self assert: icmpProtocol checksum equals: 16r495c.
	self assert: icmpProtocol shortName equals: 'ICMP'
]
