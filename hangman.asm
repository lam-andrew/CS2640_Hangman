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

# macro that exits the program 
.macro exit
li $v0, 4 
la $a0, exitMsg 
syscall 
li $v0, 10 
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

welcomePrompt: .asciiz "--------------- WELCOME TO HANGMAN --------------- \n\nRULES OF THE GAME\n1. You may guess any letter of the alphabet\n2. You are allowed 6 guesses\n3. After 6 guesses, the man is hanged and its game over" 
menu: .asciiz "Try to guess the word by typing in" 
gameBoard: .asciiz "\n\n     |-----|\n           |\n           |\n           |\n         ====="
gameoverMessage: .asciiz "YOU WERE HANGED!\nCorrect string was: "
exitMsg: .asciiz "\n\nNow Exiting Program"

.text 
main: 
	printS(welcomePrompt)
	printS(gameBoard)
	exit 
	
	##### CHOOSE RANDOM WORD FROM WORD BANK ##### 
	# 1. get random word from word bank 
	# 2. store it in memory (so we can loop through it and check for letters) 
	
	##### ALLOW USER TO GUESS ANY LETTER OF THE ALPHABET ##### 
	# 1. Prompt the user to enter a letter and then read the input 
	# 2. Check if the input is valid (if it is a letter of the alphabet) 
	# 	2a. if valid then check if it is in the word 
	# 	2b. if not valid then prompt the user to enter a valid input 
	# 3. If letter is in the word show it on the screen 
	# 4. If letter is not in the word, add a body part and decrease amount of guesses left 
	
	
checkGuess: 
	# check for each letter of the alphabet 
