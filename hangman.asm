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
##### Word Bank #####
word0:	.asciiz "assembly"
word1:  .asciiz "programming"
word2:	.asciiz "address"
word3:  .asciiz "register"
word4:	.asciiz "memory"
word5:	.asciiz "intructions"
word6:  .asciiz "microprocessor"
word7:	.asciiz "interlocked"
word8:  .asciiz "pipeline"
word9:	.asciiz "storage"
word10:  .asciiz "architecture"

itworked: .asciiz "\n\nIT WORKED"
welcomePrompt: .asciiz "--------------- WELCOME TO HANGMAN --------------- \n\nRULES OF THE GAME\n1. You may guess any letter of the alphabet\n2. You are allowed 6 guesses\n3. After 6 guesses, the man is hanged and its game over" 
menu: .asciiz "Try to guess the word by typing in" 
gameBoard: .asciiz "\n\n     |-----|\n           |\n           |\n           |\n         ====="
guessPrompt: .asciiz "\n\nPlease enter a letter for your guess: "
invalidInput: .asciiz "\nInput was invalid please try again."
gameoverMessage: .asciiz "SORRY YOU WERE HANGED!\nCorrect string was: "
exitMsg: .asciiz "\n\nNow Exiting Program"

.text 
main: 
	printS(welcomePrompt)
	printS(gameBoard)
	
	# jump to the promptGuess label
	j promptGuess 		
	
	##### TASKS TO COMPLETE ##### 
	
	##### CHOOSE RANDOM WORD FROM WORD BANK ##### 
	# 1. get random word from word bank 
	# 2. store it in memory (so we can loop through it and check for letters) 
	
	##### ALLOW USER TO GUESS ANY LETTER OF THE ALPHABET ##### 
	# 1. Prompt the user to enter a letter and then read the input 					*DONE*
	# 2. Check if the input is valid (if it is a letter of the alphabet) 				*DONE*
	# 	2a. if valid then check if it is in the word 
	# 	2b. if not valid then prompt the user to enter a valid input 				*DONE*
	# 3. If letter is in the word show it on the screen 						[haven't figured out how to do this part yet] 
	# 4. If letter is not in the word, add a body part and decrease amount of guesses left 		[haven't figured out how to do this part yet] 

promptGuess: 
	# print out a prompt that tells the user to enter a letter 
	printS(guessPrompt)
	
	# read a character as the user's guess 
	li $v0, 12 
	syscall 
	move $t0, $v0 
	
	# jump to validateGuess label
	j validateGuess 
 	
	
# check if the user's guess is a valid letter of the alphabet 
validateGuess: 
	# check for each letter of the alphabet 
	beq $t0, 'A', checkGuess
	beq $t0, 'B', checkGuess
	beq $t0, 'C', checkGuess
	beq $t0, 'D', checkGuess
	beq $t0, 'E', checkGuess
	beq $t0, 'F', checkGuess
	beq $t0, 'G', checkGuess
	beq $t0, 'H', checkGuess
	beq $t0, 'I', checkGuess
	beq $t0, 'J', checkGuess
	beq $t0, 'K', checkGuess
	beq $t0, 'L', checkGuess
	beq $t0, 'M', checkGuess
	beq $t0, 'N', checkGuess
	beq $t0, 'O', checkGuess
	beq $t0, 'P', checkGuess
	beq $t0, 'Q', checkGuess
	beq $t0, 'R', checkGuess
	beq $t0, 'S', checkGuess
	beq $t0, 'T', checkGuess
	beq $t0, 'U', checkGuess
	beq $t0, 'V', checkGuess
	beq $t0, 'W', checkGuess
	beq $t0, 'X', checkGuess
	beq $t0, 'Y', checkGuess
	beq $t0, 'Z', checkGuess
	
	# if not a valid letter from the alphabet 
	printS(invalidInput)	# print an invalid input message 
	j promptGuess		# jump back to promptGuess so the user can guess again
	
# check if the user's guess is in the word 
checkGuess: 
	printS(itworked)

# exit the program 
exit: 
	li $v0, 4 
	la $a0, exitMsg 
	syscall 
	li $v0, 10 
	syscall 
