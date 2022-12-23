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
#---------------------------------------------------Word Bank-----------------------------------------------------------\
word0:		.asciiz	"computer"
word1:		.asciiz	"architecture"
word2:		.asciiz	"software"
word3:		.asciiz	"hardware"
word4:		.asciiz "binary"
word5:		.asciiz "mips"
word6:		.asciiz "memory"
word7:		.asciiz "macros"
word8:		.asciiz	"hangman"
word9:		.asciiz	"address"
word10:		.asciiz	"programming"
word11:		.asciiz "register"
word12:		.asciiz "instruction"
word13:		.asciiz "vonneumann"
#------------------------------------------------------------------------------------------------------------------------/

words:		.word	word0, word1, word2, word3, word4, word5, word6, word7, word8, word9, word10, word11, word12, word13
wordsLength:	.word	14

gameBoard: .asciiz "\n     |-----|\n           |\n           |\n           |\n         ====="
head: .asciiz      "\n     |-----|\n     O     |\n           |\n           |\n         ====="
body: .asciiz	   "\n     |-----|\n     O     |\n     |     |\n           |\n         ====="
leftArm: .asciiz   "\n     |-----|\n     O     |\n    /|     |\n           |\n         ====="
rightArm: .asciiz  "\n     |-----|\n     O     |\n    /|\\    |\n           |\n         ====="
leftLeg: .asciiz   "\n     |-----|\n     O     |\n    /|\\    |\n    /      |\n         ====="
rightLeg: .asciiz  "\n     |-----|\n     O     |\n    /|\\    |\n    / \\    |\n         ====="

buffer:	.space	32

#guessed letters word
guessed:	.space	32

#String Table
welcomePrompt: 	.asciiz "--------------- WELCOME TO HANGMAN --------------- \n\nRULES OF THE GAME\n1. You may guess any letter of the alphabet\n2. You are allowed 7 guesses\n3. After 7 guesses, the man is hanged and its game over"
correctGuess:	.asciiz "\nCorrect! "
incorrectGuess:	.asciiz "\nIncorrect! "
word:		.asciiz "\nThe word is \n"
score:		.asciiz ". Remaining guesses:  "
guess: 		.asciiz	"Guess a letter: \n"
won: 		.asciiz "You have correctly guessed the word. Congrats!" 
lost:		.asciiz "You failed to guess the word.\n"
gameOver:	.asciiz "\nRound is over. Your final guess was:\n"
correctWord:	.asciiz "\nCorrect word was:\n"
.:		.asciiz ".\n"
replay:		.asciiz "Do you want to play again (y/n)?\n"
newLine:	.asciiz "\n"
exitMsg: 	.asciiz "Thank you for playing! Now exiting program ... "


.text
#------------------------------------------------------------------------------------------------------------------------\
main:
	#print welcome
	printS(welcomePrompt)
	printS(gameBoard)
	lw $s0, words			# Initialize s0 with the first word
	and $s1, $s1, $0		# initialize s1 to 0 (s1 == player score)
	and $s2, $s2, $1		# initialize s2 to 1 (s2 == run counter)
	
	
# Keep running the game until the user decides to quit 
gameLoop:
	jal getRandWord			# get a new random word
	move $s0, $v0			# move to print
	la $a0, buffer			# get buffer to store word
	move $a1, $s0			# get the original word
	jal storeWord				
	
	#play game
	jal playRound			
	
	#output post-round info
	printS(correctWord) 		# print "the correct word was: " 
	move $a0, $s0			# load the correct word into right arg register
	li $v0, 4 			# print the correct word
	syscall 
	printS(newLine)			# print newLine 

# Prompt the player asking if they would want to play again 
playAgain:
	printS(replay)			# print "play again?" 
	jal answerChoice		# prompt for user answer 
	
	beq $v0, 121, gameLoop		# if prompted char is == 'y', return to game loop 
	bne $v0, 110, playAgain		# if we didn't get an 'n' either, branch up to prompt again.
	

exit:	
	printS(exitMsg)
	li $v0, 10
	syscall
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
getRandWord:
	#Allocate
	addi $sp, $sp, -8		# allocate 12 bytes on stack
	sw $a0, 0($sp)			# store a0
	sw $a1, 4($sp)			# store a1
	
	li $v0, 42			# 42 = rand int range syscall	
	lw $a1, wordsLength		# set a1 to wordsLength
	syscall				# a0 now contains a rand int within wordsLength
	
	mul $a0, $a0, 4			# since words are 4 bytes each, the random number needs to be multiplied by 4
	lw $v0, words($a0)		# get word address stored in t0
	
	#Deallocate
	lw $a1, 4($sp)			# load a1
	lw $a0, 0($sp)			# load a0
	addi $sp, $sp, 8		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
storeWord:
	#Allocate
	addi $sp, $sp, -28		# allocate 28 bytes of space
	sw $ra, 0($sp)			# store return address
	sw $a0, 4($sp)			# store a0
	sw $a1, 8($sp)			# store a1
	sw $s0, 12($sp)			# store s0
	sw $s1, 16($sp)			# store s1
	sw $s2, 20($sp)			# store s2
	sw $s7, 24($sp)			# store s7
	
	move $s0, $a0			# s0 = DESTINATION
	move $s1, $a1			# s1 = SOURCE
	
	jal strcpy
	jal strlen			# get the word length
	
	move $s2, $v0			# s2 = string length
	addi $s7, $s2, -1		# s7 = length -1

	#Deallocate
	lw $ra, 0($sp)			# load return address
	lw $a0, 4($sp)			# load a0
	lw $a1, 8($sp)			# load a1
	lw $s0, 12($sp)			# load s0
	lw $s1, 16($sp)			# load s1
	lw $s2, 20($sp)			# load s2
	lw $s7, 24($sp)			# load s7
	addi $sp, $sp, -28		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
strlen:
	#Allocate
	addi $sp, $sp, -4		# allocate 4 bytes
	sw $a0, 0($sp)			# store current a0
	
	
	and $v0, $v0, $0		# set iterator to 0
lengthLoop:
	lb $t8, 0($a0)			# get the byte from the string	
	beq $t8, $0, lengthLoopEnd	# If null, quit loop
	
	addi $a0, $a0, 1		# increment index
	addi $v0, $v0, 1		# increment count
	
	j lengthLoop	

lengthLoopEnd:	
	#Deallocate
	lw $a0, 0($sp)			# load a0
	addi $sp, $sp, 4		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
strcpy:
	#Allocate
	addi $sp, $sp, -8		# allocate 8 bytes
	sw $a0, 0($sp)			# store current a0
	sw $a1, 4($sp)			# store current a1
	
	and $v0, $v0, $0		# set iterator to 0
copyLoop:
	lb $t8, 0($a1)			# get the byte from the source string	
	sb $t8, 0($a0)			# store byte into dest string
	beq $t8, $0, copyLoopEnd	# If nul, quit loop
		
	addi $a0, $a0, 1		# increment dest address
	addi $a1, $a1, 1		# increment source address
	addi $v0, $v0, 1		# increment count

	j copyLoop			
copyLoopEnd:	
	#Deallocate
	lw $a0, 0($sp)			# load a0
	lw $a1, 4($sp)			# load a1
	addi $sp, $sp, 8		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\ 
playRound:
	#Allocate
	addi $sp, $sp, -24		# allocate 12 bytes
	sw $ra, 0($sp)			# store return address
	sw $a0, 4($sp)			# store current a0
	sw $a1, 8($sp)			# store current a1
	sw $s0, 12($sp)			# store current s0
	sw $s1, 16($sp)			# store current s1
	sw $s2, 20($sp)			# store current s2
	
	jal strlen			# get length
	move $s0, $v0			# store length in s0
	move $s1, $a0			# store the string location
	
	la $a0, guessed			# get the guessed word buffer
	move $a1, $s0			# get the word length
	jal fillBlanks			# fill the word with hyphens
	la $s3, 7			# set the score back to 7 after round end 
	
roundLoop:
	beq $s0, $0, roundLoopEnd	# Sanity check
		
	# Display User Interface 
	printS(word) 			# print "The word is -----" 
	
	printS(guessed)			# print the guessed word so far 
	printS(score) 			# print score message	
	move $a0, $s3			# print actual score
	jal printInt
	printS(.)			# print period 
	
	# output guess a letter prompt
	printS(guess) 			# prints "Guess a letter: "
	
	# prompt for char
	jal answerChoice		# prompt for character
	move $s2, $v0			# save character entered in v0
	
	# see if string contains char
	move $a0, $s1			# move s1 (the location of the original word) into a0
	move $a1, $s2			# move the char entered in a1
	jal strContains			# see if string contains character
	
	
	bne $v0, $0, roundCharFound	
	
	# if char match not found
	subi $s3, $s3, 1		# wrong char, subtract 1 from score
	jal drawHangMan			# draw the hangman
	
	# character not found.
	printS(incorrectGuess) 		# print the incorrect message
	beq $s3, $0, roundNoPoints	# if lives == 0, end round
	
	j roundLoop			# Guess again!

roundCharFound:
	# update guesses
	la $a0, guessed			# load address of guessed buffer
	move $a1, $s1			# load address of the permuted word
	move $a2, $s2			# load the character the player just entered
	jal updateGuessed		# updated the guessed buffer with correct letters
	
	la $a0, guessed			# load guessed address for strcontains
	addi $a1, $0, 45		# set a1 (the char) to 45 (the ascii value of hyphen) for strcontains
	jal strContains			# check if guessed still has underscores
	beq $v0, $0, roundWin		# if no hyphens left in guess, end round
	
	#print correct
	printS(correctGuess) 		# print correct! 
	jal drawHangMan
	j roundLoop				
	
roundWin: 
	printS(won)			# print that the user successfully guessed the word 
	j roundLoopEnd

roundNoPoints:	
	printS(lost) 			# print that the user failed to guess the word 
	
roundLoopEnd:
	# End of round msg
	printS(gameOver) 		# display round over message 
	printS(guessed) 		# display letters guessed 
	
		
	#Deallocate
	lw $ra, 0($sp)			# load return address
	lw $a0, 4($sp)			# load a0
	lw $a1, 8($sp)			# load a1
	lw $s0, 12($sp)			# load s0
	lw $s1, 16($sp)			# load s1
	lw $s2, 20($sp)			# load s2
	addi $sp, $sp, 24		# deallocate
	jr $ra				#return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
drawHangMan:
	#compare the score with each number to see what image should be displayed
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
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
fillBlanks:
	#Allocate
	addi $sp, $sp, -8		# allocate 8 bytes
	sw $a0, 0($sp)			# store current a0
	sw $a1, 4($sp)			# store current a1
	
	add $a0, $a0, $a1		# a0 = address of string + length
	addi $t1, $0, 45		# set t1 = ascii value for hyphen
	sb $0,0($a0)			# set last byte to null
fillBlanksLoop:
	beq $a1, $0, fillBlanksLoopEnd	# if a1 < 0, we're done.
	addi $a0, $a0, -1		# decrement buffer position
	addi $a1, $a1, -1		# decrement length
	sb $t1, 0($a0)			# store underscore
	j fillBlanksLoop		# back to start of loop
fillBlanksLoopEnd:
	#Deallocate
	lw	$a0, 0($sp)		# load a0
	lw	$a1, 4($sp)		# load a1
	addi	$sp, $sp, 8		# deallocate
	jr	$ra			# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
answerChoice:
	#Allocate
	addi $sp, $sp, -12		# allocate 4 bytes
	sw $ra, 0($sp)			# store return address
	sw $a0, 4($sp)			# store a0
	sw $s0, 8($sp)			# store s0
	
	li $v0, 12			# 4 = print string syscall
	syscall				# v0 now contains a char
	move $s0, $v0			# temporarily save char
	
	printS(newLine) 		# print newline
	
	move $v0, $s0			# move char back into return register
	
	#Deallocate
	lw $ra, 0($sp)			# load return address
	lw $a0, 4($sp)			# load a0
	lw $s0, 8($sp)			# load s0
	addi $sp, $sp, 12		# deallocate
	jr $ra				#return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
strContains:
	#Allocate
	addi $sp, $sp, -4		# allocate 4 bytes
	sw $a0, 0($sp)			# store a0
	
	and $v0, $v0, $0		# set $v0 to 0 or FALSE
	
strContainsLoop:
	lb $t0, 0($a0)			# load char in from string
	beq $t0, $0, strContainsLoopEnd	#if we reach end of string, stop loop
	beq $t0, $a1, charFound		#if char matches the passed in value, branch
	addi $a0, $a0, 1		# increment string address to continue scanning
	j strContainsLoop		
charFound:
	li $v0, 1			# if char found, set return value = 1
	
strContainsLoopEnd:
	#Deallocate
	lw $a0, 0($sp)			# load a0
	addi $sp, $sp, 4		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
updateGuessed:
	#Allocate
	addi $sp, $sp, -8		# allocate 4 bytes
	sw $a0, 0($sp)			# store a0
	sw $a1, 4($sp)			# store a1
	
updateGuessedLoop:
	lb $t0, 0($a1)				# load char in from string
	beq $t0, $0, updateGuessedLoopEnd	#if we reach end of string, stop loop
	bne $t0, $a2, charNotFound		#if char doesn't match, branch
	sb $a2, 0($a0)				# sb - store byte: store passed in char in desired position.
charNotFound:
	addi $a0, $a0, 1		#increment guessed buffer
	addi $a1, $a1, 1		#increment original string pos
	j updateGuessedLoop
	
updateGuessedLoopEnd:
	#Deallocate
	lw $a1, 4($sp)			# load a1
	lw $a0, 0($sp)			# load a0
	addi $sp, $sp, 8		# deallocate
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/



#------------------------------------------------------------------------------------------------------------------------\
printInt:
	li $v0, 1			# 1 = print int syscall
	syscall
	jr $ra				# return
#------------------------------------------------------------------------------------------------------------------------/
