Class {
	#name : 'PharoSharkPacketTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkPacketTest >> testDataLayerParsing [

	| pcapPacket bytes |
	"Create packet with ethernet, IPv4 and TCP layer"
	bytes := ByteArray readHexFrom:
		         '10000000100000010100000003000000784476369819dc53602b6a4c080045000089e8dc400040067f14c0a8001e36afdb08ad2800502b4e3959fc740b8e801800e5c36e00000101080a0089d23ea32c77c2'
			         readStream.
	pcapPacket := PharoSharkPacket parseStream: bytes readStream.
	self assert: pcapPacket calculateHash equals: 57994966166592.
	self assert: pcapPacket highestParsedProtocol shortName equals: 'TCP'.
	self assert: pcapPacket srcIP equals: '192.168.0.30'.
	self assert: pcapPacket dstIP equals: '54.175.219.8'.
	self assert: pcapPacket shortName equals: 'Captured packet'.
	self
		assert: pcapPacket nextProtocol nextProtocol protocolNumber
		equals: 6.
	self assert: pcapPacket highestParsedProtocol srcPort equals: 44328.
	self assert: pcapPacket highestParsedProtocol dstPort equals: 80.
	self assert: pcapPacket highestParsedProtocol window equals: 229.
	self assert: pcapPacket highestParsedProtocol flags equals: 16r18.
	self
		assert: pcapPacket highestParsedProtocol checksum
		equals: 16rc36e.
	self assert: pcapPacket highestParsedProtocol nextProtocol isNil
]

{ #category : 'tests' }
PharoSharkPacketTest >> testIPLevelParsing [

	| pcapPacket bytes |
	"Create packet with ethernet and ip4 layer, but without TCP and UDP, so the port hash must be 0"
	bytes := ByteArray readHexFrom:
		         '10000000100000010100000003000000784476369819dc53602b6a4c080045000089e8dc400040067f14c0a8001e36afdb08'
			         readStream.
	pcapPacket := PharoSharkPacket parseStream: bytes readStream.
	self assert: pcapPacket calculateHash equals: 1305957624.
	self
		assert: pcapPacket highestParsedProtocol shortName
		equals: 'IPv4'.
	self assert: pcapPacket srcIP equals: '192.168.0.30'.
	self assert: pcapPacket dstIP equals: '54.175.219.8'.
	self assert: pcapPacket shortName equals: 'Captured packet'.
	self
		assert: pcapPacket highestParsedProtocol protocolNumber
		equals: 6
]

{ #category : 'tests' }
PharoSharkPacketTest >> testInvalidLength1 [

	| pcapPacket bytes |
	"Ethernet from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	pcapPacket := PharoSharkPacket parseStream:
		              bytes readStream.
	self assert: pcapPacket isNil
]

{ #category : 'tests' }
PharoSharkPacketTest >> testParsing [

	| pcapPacket bytes |
	"Valid pcap paket header with short ethernet layer to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         '10000000100000010100000003000000AB' readStream.
	pcapPacket := PharoSharkPacket parseStream: bytes readStream.
	self assert: pcapPacket notNil.
	self assert: pcapPacket tsUsec equals: 32777232.
	self assert: pcapPacket shortName equals: 'Captured packet'.
	self assert: pcapPacket presentLength equals: 1.
	self assert: pcapPacket realLength equals: 3.
	self assert: pcapPacket nextProtocol isNil
]
