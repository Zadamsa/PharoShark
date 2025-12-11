"
Main model class of MVP architecture.
"
Class {
	#name : 'PharoSharkModel',
	#superclass : 'Object',
	#instVars : [
		'packetStatistics',
		'statistics'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkModel class >> validateHeader: aHeader [

	aHeader ifNil: [ ^ #( #error 'Failed to read header from file!' ) ].
	aHeader magicNumber = 16rA1B2C3D4 ifFalse: [
		^ #( #error 'Invalid magic number found!' ) ].
	aHeader major = 2 ifFalse: [
		^ #( #error 'Unsupported major version '
		     #, header major #, '!' ) ].
	aHeader minor = 4 ifFalse: [
		^ #( #error 'Unsupported minor version!' ) ].
	aHeader etherType = 1 ifFalse: [
		^ #( #error 'Unsupported error type!' ) ].
	^ nil
]

{ #category : 'calc' }
PharoSharkModel >> calculateStatistics: aPackets [
	^ PharoSharkStatistics calculateFor: aPackets 
]

{ #category : 'accessing' }
PharoSharkModel >> packetStatistics [ 
	^ packetStatistics
]

{ #category : 'parsing' }
PharoSharkModel >> parseFile: aFile [

	| parsedPackets packet header stream baseTs |
	aFile ifNil: [ ^ #( #cancel ) ].
	baseTs := nil.
	parsedPackets := OrderedCollection new.
	stream := aFile binaryReadStream.
	header := PharoSharkPcapHeader parseStream: stream.
	(self class validateHeader: header) ifNotNil: [ :error | ^ error ].


	[
		stream atEnd ifTrue: [
				packetStatistics := PharoSharkStatistics calculateFor: parsedPackets.
				^ {
					  #success.
					  parsedPackets } ].
		packet := PharoSharkPacket parseStream: stream ] whileNotNil: [
			baseTs ifNil: [ baseTs := packet tsUsec ].
			packet relativeIndex: parsedPackets size.
			packet relativeTs: packet tsUsec - baseTs.
			parsedPackets add: packet ].

	packetStatistics := PharoSharkStatistics calculateFor: parsedPackets.
	^ {
		  #success.
		  parsedPackets }
]
