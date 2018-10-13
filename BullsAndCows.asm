.data
	words: .asciiz "HAVEWITHTHISTHEYFROMWHATMAKEKNOWTIMEYEARWHENTHEMSOMETAKEINTOJUSTYOURCOMETHANLIKETHENMOREWANTALSOMOREFINDGIVEMANYONLYVERYBACKLIFEWORKDOWNOVERLASTWHENMOSTMUCHMEANSAMEHELPTALKTURNHANDSHOWPARTOVERSUCHCASEMOSTEACHHEARWORKPLAYMOVELIKELIVEHOLDNEXTMUSTHOMEFACTWORDSIDEKINDFOURHEADLONGBOTHLONGHOURGAMELINELOSECITYMUCHNAMEFIVEONCEREALTEAMBESTIDEABODYLEADBACKONLYFACEREADSURESUCHGROWOPENWALKGIRLBOTHABLELOVEWAITSENDHOMESTAYPLANYEAHCARELATEHARDROLERATEDRUGSHOWWIFEMINDHOPEVIEWTOWNROADTRUEJOINPICKWEARFORMSITEBASESTARHALFEASYCOSTFACELANDNEWSLOVEOPENSTEPTYPEDRAWFILMHAIRTERMRULERISKFIREBANKWESTRESTDEALPASTGOALDROPPLANUPONPUSHNOTEFINENEARPAGETHANRACEEACHRISEEASTSAVETHUSSIZEFUNDSIGNLISTHARDLEFTDEALFAILNAMESORTBLUESONGDARKHANGROCKNOTEHELPCOLDFORMMAINCARDSEATNICEFIRMCAREHUGETALKHEADBASEPAINPLAYWIDEFISHTRIPUNITBESTPASTFEARSIGNHEATSINGWHOMSKINDOWNITEMSTEPYARDBEATTENDTASKSHOTWISHSAFERICHVOTEBORNWINDFASTCOSTLIKEBIRDHURTHOPEVOTETURNONCECAMPDATEVERYHOLESHIPPARKSPOTLACKBOATGAINHIDEGOLDCLUBFARMBANDRIDEWILDEARNTINYPATHSHOPFOLKLIFTJUMPWARMSOFTGIFTPASTWAVEMOVEDENYSUITBLOWKINDBURNSHOEVIEWBONEWINEMEANFIRETOURGRABFAIRPAIRTAPEHIRENEXTLADYNECKLEANHATEMALEARMYSHUTLOTSRAINFUELLEAFLEADSALTSOULBEARTHINHALFOKAYCODEJURYDESKFEARLIKELASTRINGMARKLOANCREWMALEMEALCASHLINKNOSEFILESICKDUTYSLOWZONEWAKEWARNSNOWSLIPMEATSOILLATEGOLFJUSTUSERPARTUSEDBOWLLONGHOSTRELYBACKDEBTTANKBONDFILEWINGMEANPOURSTIRTEARHERORESTBUSYCOPYCITEGRAYDISHCORERUSHRISEVASTLACKFLOWTONEAIDSGATEHANDLANDMILKCASTRIDELIVEPLUSMINDWEAKLISTWRAPMARKDRAGDIETWASHPOSTDARKCHIPSELFBIKESLOWLINKLAKEBENDGAINARABWALKSANDRULELOCKTEARPOSESALEMINETALEJOKECOATURGEDUSTGLADPACKIRONSUREKINGBEANPEAKVARYWIREHOLYRINGTWINSTOPLUCKRACEBURYPRAYPUREBELTFLAGCORNCROPLINEDATEPINKBUCKPOEMBINDMAILTUBEQUITJAILPACECAKEMINEDROPFASTPACKFLATWAGESNAPGEARWAVESPINRANKBEATWINDLOSTLIKEBEARPANTWIPEPORTDIRTRICEFLOWDECKPOLEMODEBAKESINKSWIMTIREHOLDFADESPOTMASKEASYLOADFATEOVENPOETPALELOADLAWNPLOTMATHTAILPALMSOUPPILEFUNDAIDEMYTHMENURATELOUDAUTOBITEPINERISKCHEFSUITSHITCOPEHOSTWISEACIDLUNGFIRMUGLYROPESAKEGAZECLUEDEARCOALSIGHDAREOKAYROSERAILRANKNORMSTEMRAPEHUNTECHOBARERENTSHOPEVILSLAMMELTPARKCOLDFOLDDUCKDOSETRAPLENSLENDNAILCAVEHERBWISHWARMLASTSUCKLEAPPASTPONDDUMPLIMBTUNEHARMHORNBLUEGRIPBEAMRUSHFORKDISKLOCKBLOWEXITSHIPMILDAMIDLOUDHERSBITEEVILORALFISTBATHBOLDTUNEHINTFLIPBIASLAMPCHINARABCHOPSILKRAGEWAKEDAWNTIDESEALSINKTRAPSCANCARTSTEMMATESLAPOURSHEATBARNTUCKDRUMPOSTSAILNESTNEARLANECAGERACKWOLFGRINSEALAUNTROCKRENTCALMHAULRUINBUSHCLIPEXAMSTAREDITWHIPBOILPORKSOCKNEARJUMPSEXYSEATLIONCASTCORDHARMSORTSOAPCUTESHEDICONHEALCOINSTAYDAMNCASEGAZEHIKESACKTRAYCOUPSKIPSOLEJOKEPILECURECUREFAMEATOPTHISGRINRAINCHEWDUMBBULKGOATNEATPARTPOKESOARCALMCLAYFAREDISCSOFAFISHSOAKSLOTRIOTTILEPLEACOPYBOLTDOCKTRIMSPIT"
	numWords: .word 673
	inputPrompt: .asciiz "Enter your guess (STOP to give up): "
	inputBuffer: .space 5
	giveUpOutput: .asciiz "\nYou gave up! The word was: "
	tooShortMsg: .asciiz "Your input was too short, please enter a 4 letter word\n"
	repeatMsg: .asciiz "\nYour input contained repeat letters, please only input words without repeat letters\n"
	invalidCharMsg: .asciiz "\nYour input contained characters other than A-Z, please only input capital letters\n"
.text
	lw	$a1, numWords		# Upperbound for random number generation
	li	$v0, 42			# Syscall for generating random number
	syscall				# Generate random number, stored in $a0
	sll	$a0, $a0, 2		# Multiply by 4 because each word is 4 bytes long
	la	$t0, words		# $t0 contains start address of words data segment
	add	$a0, $t0, $a0		# Add word offset to make $a0 store position of start of word
	jal	loadAndCheckBytes	# Load the word starting at $a0 (this is necessary instead of lw because the word may not start at a word boundary)
	move	$s0, $v0		# Store string into $s0
					# At this point, the only register that needs to stay the same is $s0, which stores the word that was retrieved from the list of words
	li	$v0, 30			# Get system time
	syscall				# Start timer
takeInput:
	move	$s2, $a0		# Store start time in $s2
	li 	$v0, 4			# Syscall for printing string
	la 	$a0, inputPrompt	# Load the string to be printed into $a0
	syscall				# Print string
	li 	$v0, 8			# Syscall for reading string
	la 	$a0, inputBuffer	# $a0 will store the address that the input is stored at
	li 	$a1, 5			# Read 4 characters (1 for null terminator)
	syscall				# Read the string, $a0 stores address of input		
	
	jal	loadAndCheckBytes	# Load the word starting at $a0 (this is necessary instead of lw because the word may not start at a word boundary)
	move	$s1, $v0		# Store string into $s1
	li	$t0, -1
	beq	$s1, $t0, tooShort	# If $s1 is -1, that means the input was too short
	li	$t0, -2
	beq	$s1, $t0, wrongChar	# If $s1 is -1, that means they input something other than A-Z
	
	li	$s3, 0
	li	$s4, 0x00FFFFFF		# Mask to get first 3 chars
	li	$s5, 24			# $s5 will store shift amount to get char in right position
	li	$s6, 0xFF000000		# Mask to get first char
checkUnique:
	and	$a0, $s1, $s4		# Apply mask to get string w/o first char in to $a0
	and	$a1, $s1, $s6		# Apply mask to get first char in to $a1
	srlv	$a1, $a1, $s5		# Get char in first byte slot
	jal 	charInWord		# Check if first char is repeated
	or	$s3, $s3, $v0		# Make sure there isn't a repeat for any of the chars
	bne	$s3, $zero, repeatChar	# If $s3 is ever not 0, that means there was a repeat, and therefore the input is invalid
	srl	$s4, $s4, 8		# Move on to next char to check
	subi	$s5, $s5, 8		# Move on to next char to check
	srl	$s6, $s6, 8		# Move on to next char to check
	bne	$s4, $zero, checkUnique	# Check all but last digit

	li	$t0, 0x53544F50		# $t0 will contain "STOP"
	beq	$t0, $s1, giveUp	# If "STOP" is input, give up
					# Get number of bulls and cows
	li	$a0, 666999
	li	$v0, 1
	syscall
	li	$v0, 10
	syscall
	
repeatChar:
	la	$a0, repeatMsg
	li	$v0, 4
	syscall				# Print repeat char error message
	j 	takeInput
tooShort:
	la	$a0, tooShortMsg
	li	$v0, 4
	syscall				# Print too short input error message
	j 	takeInput
wrongChar:
	la	$a0, invalidCharMsg
	li	$v0, 4
	syscall				# Print invalid char message
	j 	takeInput
	
giveUp:
	la	$a0, giveUpOutput	# Print giveUpOutput
	li	$v0, 4			# Print string syscall
	syscall				# Print string
	move	$a0, $s0		# Get $s0 ready for printing
	jal	printWord		# Print $s0
	li	$v0, 10
	syscall	
	
					# Functions and subroutines beyond this point
	
printWord:				# $a0 should contain string to be printed
	li	$t0, 0xFF000000		# Mask for getting characters
	li	$t1, 24			# Number of bits to shift to (to get first byte)
	move	$t3, $a0		# Store a copy of $a0 in $t3
printChar:
	and	$a0, $t3, $t0		# Extract char into $a0
	srlv	$a0, $a0, $t1		# Move char into first byte
	srl	$t0, $t0, 8		# Move on to next char
	subi	$t1, $t1, 8		# Move on to next char
	li	$v0, 11			# Syscall for printing char
	syscall				# Print extracted char
	bne	$t0, $zero, printChar	# Repeat for every char
	jr	$ra

					# This function takes an address, and adds 4 bytes starting at that address to $v0, in reverse order. $v0 will be -1 if it is detected that word is too short, and -2 if it detected a char other than A-Z
loadAndCheckBytes:			# $a0 should contain the base address, $v0 will contain the word that was loaded.
	li	$t0, 4			# $t0 will be the counter to make sure this only runs 4 times
	li	$v0, 0			# Reset $v0
	li	$t2, 0x0A		# $t2 holds newline character, for validity checking
	li	$t3, 0x41		# $t3 holds capital A, for validity checking
	li	$t4, 0x5A		# $t4 holds capital Z, for validity checking
loadByte:
	sll	$v0, $v0, 8		# Move on to next byte
	lbu	$t1, ($a0)		# Store byte into $t1
	beq	$t1, $zero, shortInput	# If you get a null byte, the input was too short
	beq	$t1, $t2, shortInput	# If you get a newline char, input is also too short
	blt	$t1, $t3, incorrectChar	# If less than capital A, it is an invalid char
	bgt	$t1, $t4, incorrectChar	# If greater than capital Z, it is an invalid char
	or	$v0, $v0, $t1		# Write byte into $v0
	addi	$a0, $a0, 1		# Move on to next byte
	subi	$t0, $t0, 1		# Keep track of how many bytes are left
	bne	$t0, $zero, loadByte	# Load all 4 bytes
	jr	$ra
shortInput:
	li	$v0, -1			# Return -1 to indicate input was too short
	jr	$ra
incorrectChar:
	li	$v0, -2			# Return -2 to indicate that something other than A-Z was detected
	jr	$ra
	
charInWord:				# $a0 should contain the string, $a1 should contain the char, $v0 will hold 1 if $a1 is in $a0, 0 otherwise
	li	$t0, 0xFF		# Mask to extract character
checkChar:
	and	$t1, $a0, $t0		# Get char out of $a0
	beq	$t1, $a1, inWord	# If char is the same as $a1, return 1
	srl	$a0, $a0, 8		# Move on to next char to check
	bne	$a0, $zero, checkChar	# Check all chars in string
	li	$v0, 0
	jr 	$ra
inWord:
	li	$v0, 1
	jr 	$ra
