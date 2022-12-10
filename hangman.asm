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

# macro to print user input string 
.macro aString(%strings)
li $v0, 4 
.data
S: .asciiz %strings
la $a0, S 
.text 
la $a0, S
syscall 
.end_macro 

# macro that prints the number of '-' of word length [takes in an int parameter] 
.macro printBlankWord(%x)
li $t0, 0		# initialize counter variable 
loop: 	
	li $v0, 4 	
	la $a0, hyphen 	# print a hyphen
	syscall 
	add $t0, $t0, 1
	blt $t0, %x, loop	# loop for %x parameter length 
.end_macro 

.data 
##### Word Bank #####
word0:	.asciiz "tyler"
word1:  .asciiz "programming"
word2:	.asciiz "instruction"

welcomePrompt: .asciiz "--------------- WELCOME TO HANGMAN --------------- \n\nRULES OF THE GAME\n1. You may guess any letter of the alphabet\n2. You are allowed 6 guesses\n3. After 6 guesses, the man is hanged and its game over" 
gameBoard: .asciiz "\n\n     |-----|\n           |\n           |\n           |\n         ====="
head: .asciiz      "\n\n     |-----|\n     O     |\n           |\n           |\n         ====="
body: .asciiz	   "\n\n     |-----|\n     O     |\n     |     |\n           |\n         ====="
leftArm: .asciiz   "\n\n     |-----|\n     O     |\n    /|     |\n           |\n         ====="
rightArm: .asciiz  "\n\n     |-----|\n     O     |\n    /|\\    |\n           |\n         ====="
leftLeg: .asciiz   "\n\n     |-----|\n     O     |\n    /|\\    |\n    /      |\n         ====="
rightLeg: .asciiz  "\n\n     |-----|\n     O     |\n    /|\\    |\n    / \\    |\n         ====="
guessPrompt: .asciiz "\n\nPlease enter a letter for your guess: "
invalidInput: .asciiz "\nInput was invalid please try again."
menu: .asciiz "Try to guess the word by typing in" 
gameoverMessage: .asciiz "\n\nSORRY YOU WERE HANGED!\nCorrect string was: "
exitMsg: .asciiz "\n\nNow Exiting Program"
hyphen: .asciiz "-"
newLine: .asciiz "\n"


.text 
main: 
	# initialize an error counter variable 
	li $t1, 6 	# $t1 will be the register we use for error count 	

	##### PUSH WORD ONTO STACK #####	
	# push integer $t1 onto the stack
	sub $sp, $sp, 4		# moves $sp downward to make space for our next integer (size word - 4 bytes) on the stack 
	sw $t2, ($sp)		# push $t0 onto the stack (store value in $t2 into $sp) 


welcomeMessage: 
	# print the welcome screen to the user 
	printS(welcomePrompt) 

printGame: 
	printS(gameBoard)
	
	# print out the blank word label 
	aString("\n\n")
	aString("Word: ")
	printBlankWord(5)
	
	# jump to the promptGuess label 
	j promptGuess 
	

promptGuess: 
	jal printLives
	# print out a prompt that tells the user to enter a letter 
	printS(guessPrompt) 
	
	# read a character as the user's guess 
	li $v0, 12 
	syscall 
	move $t0, $v0 
	
	aString("\n")	# new line for formatting
	
	# jump to validateGuess label
	j validateGuess 
 	

	
# check if the user's guess is a valid letter of the alphabet 
validateGuess: 
	# check for each letter of the alphabet 
	beq $t0, 'a', checkGuess
	beq $t0, 'b', checkGuess
	beq $t0, 'c', checkGuess
	beq $t0, 'd', checkGuess
	beq $t0, 'e', checkGuess
	beq $t0, 'f', checkGuess
	beq $t0, 'g', checkGuess
	beq $t0, 'h', checkGuess
	beq $t0, 'i', checkGuess
	beq $t0, 'j', checkGuess
	beq $t0, 'k', checkGuess
	beq $t0, 'l', checkGuess
	beq $t0, 'm', checkGuess
	beq $t0, 'n', checkGuess
	beq $t0, 'o', checkGuess
	beq $t0, 'p', checkGuess
	beq $t0, 'q', checkGuess
	beq $t0, 'r', checkGuess
	beq $t0, 's', checkGuess
	beq $t0, 't', checkGuess
	beq $t0, 'u', checkGuess
	beq $t0, 'v', checkGuess
	beq $t0, 'w', checkGuess
	beq $t0, 'x', checkGuess
	beq $t0, 'y', checkGuess
	beq $t0, 'z', checkGuess
	
	# if not a valid letter from the alphabet 
	printS(invalidInput)	# print an invalid input message 
	j promptGuess		# jump back to promptGuess so the user can guess again
	
# check if the user's guess is in the word by looping through the guessWord and comparing each letter with the user input 
checkGuess: 
	# intialize an variable to be used in checkGuess 
	li $s0, 0

# crete an innerLoop label inside of the checkGuess label so that $s0 is not re-initialized with 0 
innerLoop: 
 	la $a1, word0 	# load address of $a1 with our guessWord 
 	addu $a1, $a1, $s0	# $a1 = &str[x].  assumes x is in $s0   [use addu, instead of add, because it will not cause exception there's an overflow] 	
 	lbu $a0, ($a1)	# lbu: load byte unassigned (take the contents of memory, load it, and sign extend the result to 32 (or 64) bits) [load $a1 into $a0] 
 	
 	# print out our word to test if this checkGuess label works 
 	li $v0, 11
 	syscall 
 	
 	# if the current chaacter,$a0, is equal to the user input, $t0, then add it to our blank word text (_____) 
 	beq $a0, $t0, updateBlankWord
 	
 	addi, $s0, $s0, 1	# increment the $s0 register variable 
 	blt $s0, 5, innerLoop	# if the $s0 register variable is less than our word length, keep looping 
 	
 	
	# if the letter guessed is in the word update the gameMenu 
	# if the letter guessed is not in the word, increase errorCount register, $t1, by 1 
	
	j checkErrors	# jump back to promptGuess so the user can guess again


# this label is in charge up updating the blank word text when a correct character is guessed 
updateBlankWord: 
	

	
# check if the user has reached maximum amount of errors (6) 
checkErrors: 
	# $t1 is used to count our errors 
	# if the input is invalid, then add a body part
	li $t3, 6
	beq $t1, $t3, headB
	
	li $t3, 5
	beq $t1, $t3, bodyB

	li $t3, 4
	beq $t1, $t3, leftArmB

	li $t3, 3
	beq $t1, $t3, rightArmB

	li $t3, 2
	beq $t1, $t3, leftLegB

	li $t3, 1
	beq $t1, $t3, rightLegB

	# The branches the game will jump to depending on what error count the game is on. Then print the new body part.
	headB:
	printS(head)
	subi $t1, $t1, 1	# subtracts 1 from the error counter 
	j promptGuess
	
	bodyB:
	printS(body)
	subi $t1, $t1, 1	# subtracts 1 from the error counter 
	j promptGuess
	
	leftArmB:
	printS(leftArm)
	subi $t1, $t1, 1	# subtracts 1 from the error counter 
	j promptGuess
	
	rightArmB:
	printS(rightArm)
	subi $t1, $t1, 1	# subtracts 1 from the error counter 
	j promptGuess
	
	leftLegB:
	printS(leftLeg)
	subi $t1, $t1, 1	# subtracts 1 from the error counter 
	j promptGuess
	
	rightLegB:
	printS(rightLeg)
	subi $t1, $t1, 1
	
	# check the length of our error counter 
	blt $t1, 1, exitProgram 

# display to the user that they have won 
printWin: 


# this label will print the number of guesses the user has left 
printLives: 
	aString("\n\nRemaining lives: ")
	
	li $v0, 1 
	move $a0, $t1 
	syscall 
	
	jr $ra	# jr instruction will return the program to where you jump end linked (jal) from 
	
# exit the program 
exitProgram: 
	jal printLives		# display remaining lives (0) 
	printS(gameoverMessage)	# display the gameoverMessage 
	li $v0, 4 
	la $a0, exitMsg 
	syscall 
	li $v0, 10 
	syscall 
