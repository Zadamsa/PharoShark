Class {
	#name : 'PharoSharkApp',
	#superclass : 'SpApplication',
	#category : 'PharoShark-View',
	#package : 'PharoShark',
	#tag : 'View'
}

{ #category : 'running' }
PharoSharkApp >> start [
	"This method is overriden to start the app, 
    we create a new instance of the presenter for it"

	(self new: MyTodoList) open
]
