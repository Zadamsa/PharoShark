Class {
	#name : 'PharoSharkModel',
	#superclass : 'Object',
	#instVars : [
		'packets'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'initialization' }
PharoSharkModel >> initialize [ 
	packets :=  #(10 20 30) "OrderedCollection new".
]

{ #category : 'accessing' }
PharoSharkModel >> packets [

	^ packets
]

{ #category : 'parsing' }
PharoSharkModel >> parseFile: aFile [

	| parsedPackets packet header stream|
	parsedPackets := OrderedCollection new.
	stream := aFile binaryReadStream .
	header := PharoSharkPcapHeader parseStream: stream .
	header ifNil: [ ^ #( #error 'Failed to read header from file!' ) ].
	header magicNumber = 16rA1B2C3D4 ifFalse: [ ^ #( #error 'Invalid magic number found!') ].
	header major = 2 ifFalse: [ ^ #( #error 'Unsupported major version ', header major , '!') ].
	header minor = 4 ifFalse: [ ^ #( #error 'Unsupported minor version!') ].
	header etherType = 1 ifFalse: [ ^ #( #error 'Unsupported error type!') ].

	[ packet := PharoSharkPacket parseStream: stream ]
		whileNotNil: [ parsedPackets append: packet ].
		
	^ #( #success parsedPackets )
]
