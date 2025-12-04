Class {
	#name : 'MyTodoList',
	#superclass : 'SpPresenter',
	#instVars : [
		'taskList',
		'addTaskButton',
		'addTaskText',
		'taskListPresenter'
	],
	#category : 'PharoShark-View',
	#package : 'PharoShark',
	#tag : 'View'
}

{ #category : 'initialization' }
MyTodoList >> connectPresenters [

    "Here we will define the behaviour of the different elements"

    addTaskButton action: [ 
        addTaskText text = '' ifFalse: [ 
            taskList add: addTaskText text.
            addTaskText text: '' ].
        taskListPresenter updateList ]
]

{ #category : 'initialization' }
MyTodoList >> initializeLayout [

    self layout: (SpBoxLayout newVertical
             add: taskListPresenter;
             add: addTaskText;
             add: addTaskButton;
             spacing: 10;
             yourself)
]

{ #category : 'initialization' }
MyTodoList >> initializePresenters [

    self instantiatePresenters.
    self initializeLayout
]

{ #category : 'initialization' }
MyTodoList >> initializeWindow: aWindowPresenter [

    aWindowPresenter
        title: 'My Todo List';
        initialExtent: 300 @ 270
]

{ #category : 'as yet unclassified' }
MyTodoList >> instantiatePresenters [

    "Here we will initialize all the components that we will be using"

    "Task List"
    taskList := #( 'Create a to-do list in Pharo' ) asOrderedCollection.
    taskListPresenter := self instantiate: SpListPresenter new.
    taskListPresenter
        items: taskList;
        activateOnDoubleClick;
        whenActivatedDo: [ :itemToRemove | self removeTask: itemToRemove ].

    "Button to add tasks"
    addTaskButton := self newButton.
    addTaskButton label: 'Add task'.

    "Text field for adding task by name"
    addTaskText := self newTextInput
]

{ #category : 'removing' }
MyTodoList >> removeTask: anItem [

    taskList remove: anItem selectedItem.
    taskListPresenter updateList
]
