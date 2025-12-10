Class {
	#name : 'BaselineOfPharoShark',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoShark',
	#package : 'BaselineOfPharoShark'
}

{ #category : 'baselines' }
BaselineOfPharoShark >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ "spec package: 'Spec2-Core'.""spec baseline: 'Spec2-Core'."
				spec
					package: 'PharoShark'
					with: [
					spec requires: #( 'Spec2-Core' 'Roassal3' 'Roassal3-Spec2' 'Roassal3-Graphs' ) ] ]
]

{ #category : 'accessing' }
BaselineOfPharoShark >> projectClass [
	^ MetacelloCypressBaselineProject
]
