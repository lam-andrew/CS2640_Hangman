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
.macro printWordGuess(%x)
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
guessPrompt: .asciiz "\n\nPlease enter a letter for your guess: "
invalidInput: .asciiz "\nInput was invalid please try again."
menu: .asciiz "Try to guess the word by typing in" 
gameoverMessage: .asciiz "SORRY YOU WERE HANGED!\nCorrect string was: "
exitMsg: .asciiz "\n\nNow Exiting Program"
hyphen: .asciiz "-"
newLine: .asciiz "\n"



.text 
main: 
	# print the welcome screen to the user 
	printS(welcomePrompt)
	printS(gameBoard)
	
	# print out the guess word label
	printS(newLine)
	printS(newLine)
	aString("Word: ")
	printWordGuess(5)
	
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
	
# check if the user's guess is in the word 
checkGuess: 
	aString("\nValid Guess")
	
	# have the word letters already stored in an array  
	# lw from the array and compare with guessed letter 
	# continue from there 
	
	j promptGuess	# jump back to promptGuess so the user can guess again 
	
# check if the user has reached maximum amount of errors (6) 
checkErrors: 

	# check the length of our error counter 
	# if it is more than 6 then we display a 
	# lose game message and exit the game 


# exit the program 
exit: 
	li $v0, 4 
	la $a0, exitMsg 
	syscall 
	li $v0, 10 
	syscall 
