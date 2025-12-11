"
Helper presenter class required to print string with info about protocol as part of pop-up menu.
"
Class {
	#name : 'PharoSharkLabelNode',
	#superclass : 'Object',
	#instVars : [
		'label'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'accessing' }
PharoSharkLabelNode >> children [

	^ {  }
]

{ #category : 'displaying' }
PharoSharkLabelNode >> displayString [

	^ label
]

{ #category : 'accessing' }
PharoSharkLabelNode >> label: aLabel [

	label := aLabel
]
