Class {
	#name : 'PharoSharkPacket',
	#superclass : 'Object',
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkPacket class >> parseStream: aStream [

	| parsedPacket |
	parsedPacket := self new.
	^ nil
]
