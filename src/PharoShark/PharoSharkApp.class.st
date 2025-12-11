"
Main app presenter class. Responsible for app startup.
"
Class {
	#name : 'PharoSharkApp',
	#superclass : 'SpApplication',
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'running' }
PharoSharkApp >> start [

	(self new: PharoSharkPresenter) open
]
