Class {
	#name : 'PharoSharkApp',
	#superclass : 'SpApplication',
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'as yet unclassified' }
PharoSharkApp >> defaultPresenter [
    ^ PharoSharkPresenter

]

{ #category : 'running' }
PharoSharkApp >> start [
	"This method is overriden to start the app, 
    we create a new instance of the presenter for it"
    "| root |
    root := PharoSharkWiew new.  
    root application: self.       
    root open."
	(self new: PharoSharkPresenter) open
]
