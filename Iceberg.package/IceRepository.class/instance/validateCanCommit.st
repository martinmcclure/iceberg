validating
validateCanCommit
	"Verify sync between image version and working copy"
	
	"If there are incomming commits is out of sync"
	self incomingCommits ifNotEmpty: [ 
		IceWorkingCopyDesyncronized signal ]