Class {
	#name : 'PharoSharkPcapHeader',
	#superclass : 'Object',
	#instVars : [
		'magicNumber',
		'major',
		'minor',
		'timeZone',
		'tsPrecision',
		'maxSnapshotLength',
		'etherType'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'accessing' }
PharoSharkPcapHeader >> etherType [
	^ etherType 
]

{ #category : 'instance creation' }
PharoSharkPcapHeader >> initializeWithMagic: aMagicNumber versionMajor: aMajor versionMinor: aMinor timeZone: aTimeZone precision: aTsPrecision maxSnapshotLength: aMaxSnapshotLength etherType: anEtherType [

	magicNumber := aMagicNumber.
	major := aMajor.
	minor := aMinor.
	timeZone := aTimeZone.
	tsPrecision := aTsPrecision.
	maxSnapshotLength := aMaxSnapshotLength.
	etherType := anEtherType
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> magicNumber [
	^ magicNumber 
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> major [
	^ major 
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> maxSnapshotLength [
	^ maxSnapshotLength 
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> minor [
	^ minor
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> timeZone [
	^ timeZone 
]
