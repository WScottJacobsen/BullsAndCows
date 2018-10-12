.data
	words: .asciiz "HAVEWITHTHISTHEYFROMWHATMAKEKNOWTIMEYEARWHENTHEMSOMETAKEINTOJUSTYOURCOMETHANLIKETHENMOREWANTALSOMOREFINDGIVEMANYONLYVERYBACKLIFEWORKDOWNOVERLASTWHENMOSTMUCHMEANSAMEHELPTALKTURNHANDSHOWPARTOVERSUCHCASEMOSTEACHHEARWORKPLAYMOVELIKELIVEHOLDNEXTMUSTHOMEFACTWORDSIDEKINDFOURHEADLONGBOTHLONGHOURGAMELINELOSECITYMUCHNAMEFIVEONCEREALTEAMBESTIDEABODYLEADBACKONLYFACEREADSURESUCHGROWOPENWALKGIRLBOTHABLELOVEWAITSENDHOMESTAYPLANYEAHCARELATEHARDROLERATEDRUGSHOWWIFEMINDHOPEVIEWTOWNROADTRUEJOINPICKWEARFORMSITEBASESTARHALFEASYCOSTFACELANDNEWSLOVEOPENSTEPTYPEDRAWFILMHAIRTERMRULERISKFIREBANKWESTRESTDEALPASTGOALDROPPLANUPONPUSHNOTEFINENEARPAGETHANRACEEACHRISEEASTSAVETHUSSIZEFUNDSIGNLISTHARDLEFTDEALFAILNAMESORTBLUESONGDARKHANGROCKNOTEHELPCOLDFORMMAINCARDSEATNICEFIRMCAREHUGETALKHEADBASEPAINPLAYWIDEFISHTRIPUNITBESTPASTFEARSIGNHEATSINGWHOMSKINDOWNITEMSTEPYARDBEATTENDTASKSHOTWISHSAFERICHVOTEBORNWINDFASTCOSTLIKEBIRDHURTHOPEVOTETURNONCECAMPDATEVERYHOLESHIPPARKSPOTLACKBOATGAINHIDEGOLDCLUBFARMBANDRIDEWILDEARNTINYPATHSHOPFOLKLIFTJUMPWARMSOFTGIFTPASTWAVEMOVEDENYSUITBLOWKINDBURNSHOEVIEWBONEWINEMEANFIRETOURGRABFAIRPAIRTAPEHIRENEXTLADYNECKLEANHATEMALEARMYSHUTLOTSRAINFUELLEAFLEADSALTSOULBEARTHINHALFOKAYCODEJURYDESKFEARLIKELASTRINGMARKLOANCREWMALEMEALCASHLINKNOSEFILESICKDUTYSLOWZONEWAKEWARNSNOWSLIPMEATSOILLATEGOLFJUSTUSERPARTUSEDBOWLLONGHOSTRELYBACKDEBTTANKBONDFILEWINGMEANPOURSTIRTEARHERORESTBUSYCOPYCITEGRAYDISHCORERUSHRISEVASTLACKFLOWTONEAIDSGATEHANDLANDMILKCASTRIDELIVEPLUSMINDWEAKLISTWRAPMARKDRAGDIETWASHPOSTDARKCHIPSELFBIKESLOWLINKLAKEBENDGAINARABWALKSANDRULELOCKTEARPOSESALEMINETALEJOKECOATURGEDUSTGLADPACKIRONSUREKINGBEANPEAKVARYWIREHOLYRINGTWINSTOPLUCKRACEBURYPRAYPUREBELTFLAGCORNCROPLINEDATEPINKBUCKPOEMBINDMAILTUBEQUITJAILPACECAKEMINEDROPFASTPACKFLATWAGESNAPGEARWAVESPINRANKBEATWINDLOSTLIKEBEARPANTWIPEPORTDIRTRICEFLOWDECKPOLEMODEBAKESINKSWIMTIREHOLDFADESPOTMASKEASYLOADFATEOVENPOETPALELOADLAWNPLOTMATHTAILPALMSOUPPILEFUNDAIDEMYTHMENURATELOUDAUTOBITEPINERISKCHEFSUITSHITCOPEHOSTWISEACIDLUNGFIRMUGLYROPESAKEGAZECLUEDEARCOALSIGHDAREOKAYROSERAILRANKNORMSTEMRAPEHUNTECHOBARERENTSHOPEVILSLAMMELTPARKCOLDFOLDDUCKDOSETRAPLENSLENDNAILCAVEHERBWISHWARMLASTSUCKLEAPPASTPONDDUMPLIMBTUNEHARMHORNBLUEGRIPBEAMRUSHFORKDISKLOCKBLOWEXITSHIPMILDAMIDLOUDHERSBITEEVILORALFISTBATHBOLDTUNEHINTFLIPBIASLAMPCHINARABCHOPSILKRAGEWAKEDAWNTIDESEALSINKTRAPSCANCARTSTEMMATESLAPOURSHEATBARNTUCKDRUMPOSTSAILNESTNEARLANECAGERACKWOLFGRINSEALAUNTROCKRENTCALMHAULRUINBUSHCLIPEXAMSTAREDITWHIPBOILPORKSOCKNEARJUMPSEXYSEATLIONCASTCORDHARMSORTSOAPCUTESHEDICONHEALCOINSTAYDAMNCASEGAZEHIKESACKTRAYCOUPSKIPSOLEJOKEPILECURECUREFAMEATOPTHISGRINRAINCHEWDUMBBULKGOATNEATPARTPOKESOARCALMCLAYFAREDISCSOFAFISHSOAKSLOTRIOTTILEPLEACOPYBOLTDOCKTRIMSPIT"
	numWords: .word 673
	inputPrompt: .asciiz "Enter your guess: "
	inputBuffer: .word 0
.text
	lw	$a1, numWords		# Upperbound for random number generation
	li	$v0, 42			# Syscall for generating random number
	syscall				# Generate random number, stored in $a0
	sll	$a0, $a0, 2		# Multiply by 4 because each word is 4 bytes long
	la	$t0, words		# $t0 contains start address of words data segment
	add	$a0, $t0, $a0		# Add word offset to make $a0 store position of start of word
	lw	$a0, ($a0)		# Load the reverse word into $a0
	jal 	flipString		# Flip contents of $a0
	move	$s0, $v0		# Store flipped string into $s0
	
					# At this point, the only register that needs to stay the same is $s0, which stores the word that was retrieved from the list of words
	li	$v0, 30			# Get system time
	syscall				# Start timer
	move	$s2, $a0		# Store start time in $s2
	li 	$v0, 4			# Syscall for printing string
	la 	$a0, inputPrompt	# Load the string to be printed into $a0
	syscall				# Print string
	li 	$v0, 8			# Syscall for reading string
	la 	$a0, inputBuffer	# $a0 will store the address that the input is stored at
	li 	$a1, 5			# Read 4 characters (1 for null terminator)
	syscall				# Read the string, $a0 stores address of input		
	lw	$a0, ($a0)		# Store input into $a0
	jal 	flipString		# Flip contents of $a0
	move	$s1, $v0		# Store flipped string into $s1
	li	$v0, 10
	syscall				# Exit (only here temporarily)
	
flipString:				# $a0 should contain string to be flipped. $v0 will contain flipped string
	li	$t0, 0xFF		# Mask for extracting characters
	li	$v0, 0			# Start out with empty register
moveChar:
	sll	$v0, $v0, 8		# Move on to next digit
	and	$t1, $a0, $t0		# Get first (which is really last) character out of $a0 and store into $t1
	or	$v0, $v0, $t1		# Write digit into $v0
	srl	$a0, $a0, 8		# Move on to next digit
	bne	$a0, $zero, moveChar 	# Repeat process for every digit
	jr	$ra