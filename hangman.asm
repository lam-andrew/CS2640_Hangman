# Assignment: MIPS Assembly Final Project 
# Course: CS2640.01
# Group: Andrew Lam, Tyler Hipolito, Ben Le, James Contreras 
# Objective: Create a game of Hangman in MIPS assembly langauge. Utilize all that we have learned in CS2640. 

# macro to print user input string 
.macro printS(%s) 
li $v0, 4 
la $a0, %s
syscall 
.end_macro 

.data
#--------------------------------- Word Bank ---------------------------------\
word0:		.asciiz	"computer"
word1:		.asciiz	"processor"
word2:		.asciiz	"motherboard"
word3:		.asciiz	"graphics"
word4:		.asciiz "network"
word5:		.asciiz "ethernet"
word6:		.asciiz "memory"
word7:		.asciiz "microsoft"
word8:		.asciiz	"linux"
word9:		.asciiz	"transistor"
word10:		.asciiz	"programming"
word11:		.asciiz "protocol"
word12:		.asciiz "instruction"
#-----------------------------------------------------------------------------/

words:		.word	word0, word1, word2, word3, word4, word5, word6, word7, word8, word9, word10, word11, word12
wordsLength:	.word	13

gameBoard: .asciiz "\n     |-----|\n           |\n           |\n           |\n         ====="
head: .asciiz      "\n     |-----|\n     O     |\n           |\n           |\n         ====="
body: .asciiz	   "\n     |-----|\n     O     |\n     |     |\n           |\n         ====="
leftArm: .asciiz   "\n     |-----|\n     O     |\n    /|     |\n           |\n         ====="
rightArm: .asciiz  "\n     |-----|\n     O     |\n    /|\\    |\n           |\n         ====="
leftLeg: .asciiz   "\n     |-----|\n     O     |\n    /|\\    |\n    /      |\n         ====="
rightLeg: .asciiz  "\n     |-----|\n     O     |\n    /|\\    |\n    / \\    |\n         ====="

buffer:	.space	32

#guessed letters word
GUESSED:	.space	32

#String Table
welcomePrompt: 	.asciiz "--------------- WELCOME TO HANGMAN --------------- \n\nRULES OF THE GAME\n1. You may guess any letter of the alphabet\n2. You are allowed 6 guesses\n3. After 6 guesses, the man is hanged and its game over"
correctGuess:	.asciiz "\nCorrect! "
incorrectGuess:	.asciiz "\nIncorrect! "
word:		.asciiz "\nThe word is \n"
score:		.asciiz ". Score is "
guess: 		.asciiz	"Guess a letter: \n"
lost:		.asciiz "You earned 0 points that round.\n"
gameOver:	.asciiz "\nRound is over. Your final guess was:\n"
correctWord:	.asciiz "\nCorrect  word was:\n"
.:		.asciiz ".\n"
replay:	.asciiz "Do you want to play again (y/n)?\n"
finalScore:	.asciiz "Your final score is "
newLine:	.asciiz "\n"

.text
#------------------------------ START main ---------------------------------\
#	The main program
main:
	#print welcome
	printS(welcomePrompt)
	printS(gameBoard)
	lw	$s0, words			# Initialize s0 with the first word
	and	$s1, $s1, $0			# initialize s1 to 0 (s1 == player score)
	and	$s2, $s2, $1			# initialize s2 to 0 (s2 == run counter)
	
	
# Keep running the game until the user decides to quit 
gameLoop:
	#if run_counter == 0, skip rand word
	jal	getRandWord			# get a new random word
	move	$s0, $v0			# move to print
	la	$a0, buffer			# get buffer to store word
	move	$a1, $s0			# get the original word
	jal	storeWord				
	
	#play game
	jal	playRound			# plays a round
	
	#increment stuffs
	add	$s1, $s1, $v0			# add return value of playRound to player score
	addi	$s2, $s2, 1
	
	#output post-round info
	printS(correctWord) 			# print "the correct word was: " 
	move	$a0, $s0			# load unscrambled word into right arg register
	li $v0, 4 				# print the unscrambled word
	syscall 
	printS(newLine)				# print newLine 

# Prompt the player asking if they would want to play again 
playAgain:
	printS(replay)			# print "play again?" 
	jal	promptChar			# prompt for a character 
	
	beq	$v0, 121, gameLoop		# if prompted char is == 'y', return to game loop (play again)
	bne	$v0, 110, playAgain		# if we didn't get an 'n' either, branch up to prompt again.
	
	# Final Score is...
	printS(finalScore) 			# print "final score is: "
	
	#print num
	move	$a0, $s1			# move player score in place to be printed
	jal	printInt
	
	

exit:	
	li	$v0, 10
	syscall
#-------------------------------- END main ----------------------------------/



#--------------------------- START getRandWord -----------------------------------\
#	getRandWord()
#	Returns the address of a random word in the words array
#	
#	$v0 = Returns the address of a random word
getRandWord:
	## Prologue ##
	addi	$sp, $sp, -8			# allocate 12 bytes on stack
	sw	$a0, 0($sp)			# store a0
	sw	$a1, 4($sp)			# store a1
	
	## Code ##
	li 	$v0, 42				# 42 = rand int range syscall			# set a0 to 0
	lw	$a1, wordsLength		# set a1 to wordsLength
	syscall					# a0 now contains a rand int within wordsLength
	
	mul	$a0, $a0, 4			# since words are 4 bytes the rand number needs to be X4
	lw	$v0, words($a0)			# get word address stored in t0
	
	## Epilogue ##
	lw	$a1, 4($sp)			#reload old a1
	lw	$a0, 0($sp)			#reload old a0
	addi	$sp, $sp, 8			#deallocate
	jr	$ra				#return
#-------------------------- END getRandWord --------------------------------/


#------------------------------ START getRand ----------------------------------\
#	get_rand(max)
#	Returns a random int between 0<=x<=max
#	
#	$v0 = the random int within range
getRandInt:
	## Prologue ##
	addi	$sp, $sp, -8			# allocate 12 bytes on stack
	sw	$a0, 0($sp)			# store a0
	sw	$a1, 4($sp)			# store a1
	
	## Code ##
	li 	$v0, 42				# 42 = rand int range syscall
	move	$a1, $a0				# move range to correct register
	la 	$a0, 0				# set a0 to 0
						# a0 now contains a rand int within a1 range
	
	move	$v0, $a0
	
	## Epilogue ##
	lw	$a1, 4($sp)
	lw	$a0, 0($sp)
	addi	$sp, $sp, 8			#deallocate
	jr	$ra				#return
#------------------------------- END getRand --------------------------------/


#------------------------------ START storeWord ---------------------------------\
#	storeWord(dest, source)
#	stores the source string into the destination string
#	$a0 = destination
#	$a1 = source
storeWord:
	## Prologue ##
	addi	$sp, $sp, -28			#allocate 28 bytes of space
	sw	$ra, 0($sp)			#save return address
	sw	$a0, 4($sp)			#save old a0
	sw	$a1, 8($sp)			#save old a1
	sw	$s0, 12($sp)			#save old s0
	sw	$s1, 16($sp)			#save old s1
	sw	$s2, 20($sp)			#save old s2
	sw	$s7, 24($sp)			#save old s7
	
	## Code ##
	move	$s0, $a0			# s0 = DESTINATION
	move	$s1, $a1			# s1 = SOURCE
	
	jal strcpy
	jal strlen				#get it's length
	
	move	$s2, $v0			# s2 = string length
	addi	$s7, $s2, -1			# set [i]terator (s7) = len-1

	## Epilogue ##
	lw	$ra, 0($sp)			#load return address
	lw	$a0, 4($sp)			#load old a0
	lw	$a1, 8($sp)			#load old a1
	lw	$s0, 12($sp)			#load old s0
	lw	$s1, 16($sp)			#load old s1
	lw	$s2, 20($sp)			#load old s2
	lw	$s7, 24($sp)			#load old s7
	addi	$sp, $sp, -28			#deallocate
	jr	$ra				#return
#------------------------------ END storeWord --------------------------------/

	
#------------------------------- START strLen -----------------------------------\
#	strlen(string)
#	gets length of string
#	$a0 = string
#	
#	$v0 = Returns num chars copied
strlen:
	## Prologue ##
	addi	$sp, $sp, -4			#allocate 4 bytes
	sw	$a0, 0($sp)			# store current a0
	
	## Code ##
	and	$v0, $v0, $0			# set iterator to 0
lengthLoop:
	lb	$t8, 0($a0)			# get the byte from the string	
	beq	$t8, $0, lengthLoopEnd		# If nul, quit loop
	
	addi	$a0, $a0, 1			# increment dest address
	addi	$v0, $v0, 1			# increment count
	
	j	lengthLoop			# jump to top of loop

lengthLoopEnd:	
	## Epilogue ##
	lw	$a0, 0($sp)			#load old a0
	addi	$sp, $sp, 4			#deallocate
	jr	$ra				#return
#-------------------------------- END strLen ---------------------------------/


#----------------------------- START strCopy -----------------------------------\
#	strcpy(dest, source)
#	Copies source string into destination
#	$a0 = dest
#	$a1 = source
#	
#	$v0 = Returns num chars copied
strcpy:
	## Prologue ##
	addi	$sp, $sp, -8			# allocate 8 bytes
	sw	$a0, 0($sp)			# store current a0
	sw	$a1, 4($sp)			# store current a1
	
	## Code ##
	and	$v0, $v0, $0			# set iterator to 0
copyLoop:
	lb	$t8, 0($a1)			# get the byte from the source string	
	sb	$t8, 0($a0)			# store byte into dest string
	beq	$t8, $0, copyLoopEnd		# If nul, quit loop
		
	addi	$a0, $a0, 1			# increment dest address
	addi	$a1, $a1, 1			# increment source address
	addi	$v0, $v0, 1			# increment count

	j	copyLoop			# jump to top of loop
copyLoopEnd:	
	## Epilogue ##
	lw	$a0, 0($sp)			# load old a0
	lw	$a1, 4($sp)			# load old a1
	addi	$sp, $sp, 8			# deallocate
	jr	$ra				#return
#-------------------------------- END strCopy ---------------------------------/


#------------------------------ START playRound ----------------------------------\
#	playRound(string)
#	Plays game round with string
#	$a0 = string
#	
#	$v0 = Returns round score 
playRound:
	## Prologue ##
	addi	$sp, $sp, -24			# allocate 12 bytes
	sw	$ra, 0($sp)			# save return address
	sw	$a0, 4($sp)			# store current a0
	sw	$a1, 8($sp)			# store current a1
	sw	$s0, 12($sp)			# store current s0
	sw	$s1, 16($sp)			# store current s1
	sw	$s2, 20($sp)			# store current s2
	
	## Code ##
	jal	strlen				# get length
	move	$s0, $v0			# store length (score) in s0
	move	$s1, $a0			# save the string location
	
	#setup the underscores
	la	$a0, GUESSED			# get the guessed word buffer
	move	$a1, $s0			# get the word length
	jal	fillBlanks			# fill the word with underscores
	la $s3, 7				# set the score back to 7 after round end 
	
roundLoop:
	# DO WHILE score > 0 && underscores_present
	beq	$s0, $0, roundLoopEnd	# Sanity check
		
	#	_STATUS DISPLAY_
	printS(word) 		# print "The word is ___" 
	
	printS(GUESSED)				# print the guessed word so far 
	printS(score) 				# print score is 	
	move	$a0, $s3			# print actual score
	jal	printInt
	printS(.)				# print period 
	
	#output guess a letter prompt
	printS(guess) 				# prints "Guess a letter: "
	
	#prompt for char
	jal	promptChar			# prompt for character
	move	$s2, $v0			# save character entered in v0
	
	#see if string contains char
	move	$a0, $s1			# move s1 (the location of the original word) into a0
	move	$a1, $s2			# move the char entered in a1
	jal	strContains			# see if string contains character
	
	# if string does not contain the char, print NO, else print YES and update our guessed word.
	bne	$v0, $0, roundCharFound	# if return value != 0, we have success
	
	### IF Char match not found
	subi	$s3, $s3, 1			# wrong char, subtract 1 from score
	jal drawHangMan
	
	# character not found. Display NO!
	printS(incorrectGuess) 			# print NO!
	beq	$s3, $0, roundNoPoints		# if score == 0, end round NOW
	
	j	roundLoop			# Guess again!

roundCharFound:
	#char found, print YES and update GUESSED
	
	# update GUESSED
	la	$a0, GUESSED			# load address of GUESSED buffer
	move	$a1, $s1			# load address of the permuted word
	move	$a2, $s2			# load the character the player just entered
	jal	updateGuessed			# updated the GUESSED buffer with correct letters
	
	# if the GUESSED buffer contains underscores '_', continue
	la	$a0, GUESSED			# load GUESSED address for strcontains
	addi	$a1, $0, 45			# set a1 (the char) to 95 (the ascii value of underscore) for strcontains
	jal	strContains			# check if GUESSED still has underscores
	beq	$v0, $0, roundLoopEnd		# if no underscores left in guess, end round
	
	#print yes
	printS(correctGuess) 			# print Yes! 
	jal drawHangMan
	j	roundLoop			# jump to top of loop
roundNoPoints:	
	printS(lost) 				# print you earned no points 
	#jal 	rightLegB			# print you earned no points
roundLoopEnd:

	# End of round msg
	printS(gameOver) 			# display round over message 
	printS(GUESSED) 			# display letters guessed 
	
	move	$v0, $s3			# move s0 (score) to v0 (return register)
		
	## Epilogue ##
	lw	$ra, 0($sp)			# load return address
	lw	$a0, 4($sp)			# load old a0
	lw	$a1, 8($sp)			# load old a1
	lw	$s0, 12($sp)			# load old s0
	lw	$s1, 16($sp)			# load old s1
	lw	$s2, 20($sp)			# load old s2
	addi	$sp, $sp, 24			# deallocate
	jr	$ra				#return
#----------------------------- END playRound --------------------------------/


#----------------------------- START fillBlanks ---------------------------------\
#	fillBlanks(string, num)
#	Places num underscores into string
#	$a0 = string
#	$a1 = num underscores
drawHangMan:
	beq $s3, 7, originB
	beq $s3, 6, headB
	beq $s3, 5, bodyB
	beq $s3, 4, leftArmB
	beq $s3, 3, rightArmB
	beq $s3, 2, leftLegB
	beq $s3, 1, rightLegB	
	beq $s3, 0, rightLegB
originB: 
	printS(gameBoard)
	jr $ra
headB:
	printS(head)
	jr $ra
bodyB:
	printS(body)
	jr $ra
leftArmB:
	printS(leftArm)
	jr $ra
rightArmB:
	printS(rightArm)
	jr $ra
leftLegB:
	printS(leftLeg)
	jr $ra
rightLegB:
	printS(rightLeg)
	jr $ra

fillBlanks:
	## Prologue ##
	addi	$sp, $sp, -8			# allocate 8 bytes
	sw	$a0, 0($sp)			# store current a0
	sw	$a1, 4($sp)			# store current a1
	
	## Code ##
	add	$a0, $a0, $a1			# a0 = address of string + length
	addi	$t1, $0, 45			# set t1 = ascii value for '_' underscore
	sb	$0,0($a0)			# set last byte to nul
fillBlanksLoop:
	beq	$a1, $0, fillBlanksLoopEnd	# if a1 < 0, we're done.
	addi	$a0, $a0, -1			# decrement buffer position
	addi	$a1, $a1, -1			# decrement length
	sb	$t1, 0($a0)			# store underscore
	j	fillBlanksLoop			# back to start of loop
fillBlanksLoopEnd:
	## Epilogue ##
	lw	$a0, 0($sp)			# load old a0
	lw	$a1, 4($sp)			# load old a1
	addi	$sp, $sp, 8			# deallocate
	jr	$ra				#return
#-------------------------------- END fillBlanks ------------------------------/


#----------------------------- START promptChar --------------------------------\
#	promptChar()
#	Prompts for a character
promptChar:
	## Prologue ##
	addi	$sp, $sp, -12			# allocate 4 bytes
	sw	$ra, 0($sp)			# store old return address
	sw	$a0, 4($sp)			# store old a0
	sw	$s0, 8($sp)			# store old s0
	
	## Code ##
	addi $v0, $0, 12			# 4 = print string syscall
	syscall					# v0 now contains a char
	move	$s0, $v0			# temporarily save char
	
	printS(newLine) 			# print newline
	
	move	$v0, $s0			# move char back into return register
	
	## Epilogue ##
	lw	$ra, 0($sp)			# load old return address
	lw	$a0, 4($sp)			# load old a0
	lw	$s0, 8($sp)			# load old s0
	addi	$sp, $sp, 12			# deallocate
	jr	$ra				#return
#------------------------------- END promptChar ------------------------------/



#----------------------------- START strContains ------------------------------\
#	strContains(string, char)
#	Checks to see if a string contains a given character
#	$a0 = string
#	$a1 = char
#
#	Returns 0 if not found, 1 if found
strContains:
	## Prologue ##
	addi	$sp, $sp, -4			# allocate 4 bytes
	sw	$a0, 0($sp)			# store old a0
	
	## Code ##
	and	$v0, $v0, $0			# set $v0 to 0 or FALSE
	
strContainsLoop:
	lb	$t0, 0($a0)				# load char in from string
	beq	$t0, $0, strContainsLoopEnd		#if we reach end of string, stop loop
	beq	$t0, $a1, charFound			#if char matches the passed in value, branch
	addi	$a0, $a0, 1				# increment string address to continue scanning
	j	strContainsLoop				# jump to top of loop
charFound:
	addi	$v0, $0, 1				# if char found, set return value = 1
strContainsLoopEnd:
	## Epilogue ##
	lw	$a0, 0($sp)			# load old a0
	addi	$sp, $sp, 4			# deallocate
	jr	$ra				#return
#------------------------------ END strContains -----------------------------/



#---------------------------- START updateGuessed -------------------------------\
#	updateGuessed(guessed, orig, char)
#	Will update the guessed word buffer with correctly guessed letters
#	$a0 = guessed buffer
#	$a1 = original string
#	$a2 = char
updateGuessed:
	## Prologue ##
	addi	$sp, $sp, -8			# allocate 4 bytes
	sw	$a0, 0($sp)			# store old a0
	sw	$a1, 4($sp)			# store old a1
	
	## Code ##
updateGuessedLoop:
	lb	$t0, 0($a1)				# load char in from string
	beq	$t0, $0, updateGuessedLoopEnd		#if we reach end of string, stop loop
	bne	$t0, $a2, charNotFound			#if char doesn't match, branch
	sb	$a2, 0($a0)				# store passed in char in desired position.
charNotFound:
	addi	$a0, $a0, 1				#increment guessed buffer
	addi	$a1, $a1, 1				#increment original string pos
	j	updateGuessedLoop
updateGuessedLoopEnd:
	## Epilogue ##
	lw	$a1, 4($sp)			# load old a1
	lw	$a0, 0($sp)			# load old a0
	addi	$sp, $sp, 8			# deallocate
	jr	$ra				# return
#----------------------------- END updateGuessed ----------------------------/



#----------------------------- START printInt --------------------------------\
#	printInt( int )
#	Prints an int
#	
#	$a0 = Int to print
printInt:
	## Code ##
	addi $v0, $0, 1				# 1 = print int syscall
	syscall
	## Epilogue ##
	jr	$ra				#return
#------------------------------ END printInt --------------------------------/
