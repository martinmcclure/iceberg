private
commitCherryPick: pickedCollection withMessage: message andParents: parentCommitishList
	"Commits a snapshot of definitions (can be a cherry-pick). 
	 I need to group definitions in packages and create new versions for those packages, 
	 which is annoying but is the price of using MC definitions :)"
	| changesByPackage versions |
	
	self validateCanCommit.
	
	versions := OrderedCollection new.
	changesByPackage := SmallDictionary new.

	"Collect changes by package"
	pickedCollection do: [ :each | 
		(changesByPackage at: each packageName ifAbsentPut: [ Set new ]) add: each ].	
	"Create patched versions for each package"
	changesByPackage keysAndValuesDo: [ :packageName :changes | 
		versions add: (self 
			patchVersionOf: packageName 
			changes: changes 
			message: message) ].	
	"save versions"
	versions do: [ :each | self backend internalStoreVersion: each ].
	"now perform commit"
	self doCommitMcVersions: versions withMessage: message andParents: parentCommitishList