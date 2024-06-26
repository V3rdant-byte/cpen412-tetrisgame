#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "tetris.h"
#include "sp.h"

#define Timer1Data      *(volatile unsigned char *)(0x00400030)
#define Timer1Control   *(volatile unsigned char *)(0x00400032)
#define Timer1Status    *(volatile unsigned char *)(0x00400032)

#define VGA_CTL_REG          *(volatile unsigned char *)(0x00700e00)
#define VGA_X_REG			 *(volatile unsigned char *)(0x00700e10)
#define VGA_Y_REG			 *(volatile unsigned char *)(0x00700e20)
#define VGA_BASE             (0x00700000)

char Table[TETRIS_ROWS][TETRIS_COLS];
int tetris_score;
char GameOn;
int tetris_timer;

typedef struct {
    char array[MAX_SHAPE_SIZE][MAX_SHAPE_SIZE];
    int width, row, col;
} Shape;
Shape current;

Shape ShapesArray[NUM_SHAPES];

struct
{
    int speed;
    int speed_increase;
} Tetris_Speed;


int printw_x;  //hint: could be a useful variable
int printw_y;  //hint: could be a useful variable

int counter;

/* Compute x mod y using binary long division. */
int mod_bld(int x, int y)
{
    int modulus = x, divisor = y;

    while (divisor <= modulus && divisor <= 16384)
        divisor <<= 1;

    while (modulus >= y) {
        while (divisor > modulus)
            divisor >>= 1;
        modulus -= divisor;
    }

    return modulus;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//                        functions to implement
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////



void go_to_top_corner()
{
//Make the cursor (whether visible or not) go to the top left corner of the screen

//write this function
	gotoxy(1, 0);
};

void clear_screen()
{
//Clear the screen
//write this function
	memset(VGA_BASE,' ',3200);
};


void say_awesome() {
//Say the word "Awesome"
//write this function
	talkphonemeAO();
	talkphonemeSS();
	talkphonemeSS();
	talkphonemeEH();
	talkphonemeMM();
	endword();
}

void say_cool() {
//Say the word "Cool"
//write this function
	talkphonemeKK3();
	talkphonemeUH();
	talkphonemeUH();
	talkphonemeEL();
	endword();
}

void say_yeah() {
//Say the word "Yeah"
//write this function
	talkphonemeYY2();
	talkphonemeEH();
	talkphonemeEH();
	endword();
}

void say_gameover() {
	talkphonemeGG1();
	talkphonemeEY();
	talkphonemePA1();
	talkphonemeMM();
	endword();

	talkphonemeOW();
	talkphonemeVV();
	talkphonemeER1();
	endword();
}


void putcharxy(int x, int y, char ch,char* error_message) {
//Put the character "ch" in row x, column y on the screen.
//The parameter "error_message" can be used to print out
//an error message in Hyperterminal during debugging if, 
//for example, x or y are out of range

//write this function
	int cursor = y * 80 + x;
    int addr = VGA_BASE + cursor;

	if ((x + 80*y) > 3200 || (x > 80)) {
		printf("Error: x: %d, y: %d\n", x, y, error_message);
	} else {
		memset(addr, ch, sizeof(char));
	}
}

void gotoxy(int x, int y)
{
	//have the cursor (whether visible or not) go to row x, column y on the screen
    //write this function
	VGA_X_REG = x;
	VGA_Y_REG = y;
	// printf("crx_reg: %d\n", VGA_X_REG);
	// printf("cry_reg: %d\n", VGA_Y_REG);
};

void set_vga_control_reg(char x) {
	//Set the value of the control register in the VGA core
	//write this function
	VGA_CTL_REG = x;
}


char get_vga_control_reg() {
   //Get the value of the control register in the VGA core
   //write this function
   char ctl_reg = VGA_CTL_REG;
   return ctl_reg;
}

void set_color(int color) {
//Set the color of the screen
//write this function
	VGA_CTL_REG = 0xf0 + color;
	// printf("ctl_reg: %d\n", VGA_CTL_REG);
}


int clock() {
	if(Timer1Status == 1) {
	   Timer1Control = 3;
	   counter += 10;
	}
	
	return counter;
}

void printw(const char* str,char* error_message) {
	//like "printf", just on the VGA screen
	//a newline character ("\n") causes the location
	//to move to the beginning of a new line
	//prints the string in the parameter "str", 
	//the parameter "error_message" can be used for debugging
	//hint: maybe this function could use the function  putcharxy(int x, int y, char ch,char* error_message)
    
	//write this function
	int i = 0;
	printw_x = VGA_X_REG;
	printw_y = VGA_Y_REG;
	for (i = 0; i<strlen(str); i++) {
		if (str[i] == '\n') {
			printw_x = 1;
			printw_y = printw_y + 1;
			gotoxy(printw_x, printw_y);
		} else	{
			putcharxy(printw_x - 1, printw_y, str[i], error_message);
			printw_x = printw_x + 1;
			gotoxy(printw_x, printw_y);
		}	
	}
	// printf("x: %d, y: %d\n", printw_x, printw_y);
}

void gameOver()
{
  //replicate the Game Over screen functionality of the solution
  //write this function
	char score[2];
	clear_screen();
	sprintf(score, "%d", tetris_score);

	say_gameover();

	clear_screen();
	set_vga_control_reg(0xe4);
	gotoxy(35,20);
	putcharxy(35, 20, 'G', 'g');
	gotoxy(35,20);
	delay_ms(100);
	putcharxy(36, 20, 'a', 'a');
	gotoxy(36,20);
	delay_ms(100);
	putcharxy(37, 20, 'm', 'm');
	gotoxy(37,20);
	delay_ms(100);
	putcharxy(38, 20, 'e', 'e');
	gotoxy(38,20);
	delay_ms(100);
	putcharxy(39, 20, ' ', ' '); /////////////
	gotoxy(39,20);
	delay_ms(100);
	putcharxy(40, 20, 'o', 'o');
	gotoxy(40, 20);
	delay_ms(100);
	putcharxy(41, 20, 'v', 'v');
	gotoxy(41,20);
	delay_ms(100);
	putcharxy(42, 20, 'e', 'e');
	gotoxy(42,20);
	delay_ms(100);
	putcharxy(43, 20, 'r', 'r');
	gotoxy(43,20);
	delay_ms(100);
	putcharxy(44, 20, '!', '!');
	delay_ms(100);
		
	gotoxy(35,22);
	putcharxy(35, 22, 'S', 's');
	gotoxy(35,22);
	delay_ms(100);
	putcharxy(36, 22, 'c', 'c');
	gotoxy(36,22);
	delay_ms(100);
	putcharxy(37, 22, 'o', 'o');
	gotoxy(37,22);
	delay_ms(100);
	putcharxy(38, 22, 'r', 'r');
	gotoxy(38,22);
	delay_ms(100);
	putcharxy(39, 22, 'e', 'e');      //////////
	gotoxy(39,22);
	delay_ms(100);
	putcharxy(40, 22, ':', ':');
	gotoxy(40,22);
	delay_ms(100);
	putcharxy(41, 22, ' ', " ");
	gotoxy(41,22);
	delay_ms(100);
	if(tetris_score >= 100){
		putcharxy(42, 22, score[0], "score");
		gotoxy(42,22);
		delay_ms(100);
		putcharxy(43, 22, score[1], "score");
		gotoxy(43,22);
		delay_ms(100);
		putcharxy(44, 22, score[1], "score");
		gotoxy(44,22);
		gotoxy(46,22);
	} else {
		putcharxy(42, 22, score[0], "score");
		gotoxy(42,22);
		gotoxy(44,22);
	}
  	delay_ms(100);	
	while(1){
		set_vga_control_reg(0xe1);
		delay_ms(500);	
		set_vga_control_reg(0xe2);
		delay_ms(500);	
		set_vga_control_reg(0xe3);
		delay_ms(500);	
		set_vga_control_reg(0xe4);
		delay_ms(500);	
		set_vga_control_reg(0xe5);
		delay_ms(500);	
		set_vga_control_reg(0xe6);
		delay_ms(500);	
		set_vga_control_reg(0xe7);
		delay_ms(500);	
	}

}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//                      end  functions to implement
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////





void delay_ms(int num_ms) {
	int start_time;
	int current_time;
	start_time = clock();

	do {
	    current_time = clock();
	    if (current_time < start_time) { //handle wraparound
		   num_ms = num_ms - (INT_MAX-start_time);
		   start_time = current_time;
	    }
	} while ((current_time - start_time) < num_ms);
}



int tetris_rand() {
	return ((clock() >> 4)& 0xFFFF); //divide by 4 because clock increases by 10 every interrupt, ensure last digit is "random" too
}


void CopyShape(Shape* shape, Shape* new_shape){
    int i;
    int j;
	new_shape->width = shape->width;
	new_shape->row = shape->row;
	new_shape->col = shape->col;
	for(i = 0; i < new_shape->width; i++){
		for(j=0; j < new_shape->width; j++) {
			new_shape->array[i][j] = shape->array[i][j];
		}
    }
}

int CheckPosition(Shape* shape){ //Check the position of the copied shape
	int i, j;

	for(i = 0; i < shape->width;i++) {
		for(j = 0; j < shape->width ;j++){
			if((shape->col+j < 0 || shape->col+j >= TETRIS_COLS || shape->row+i >= TETRIS_ROWS)){ //Out of borders
				if(shape->array[i][j]) //but is it just a phantom?
					return FALSE;

			}
			else if(Table[shape->row+i][shape->col+j] && shape->array[i][j])
				return FALSE;
		}
	}
	return TRUE;
}

void SetNewRandomShape(){ //updates [current] with new shape
	CopyShape(&ShapesArray[mod_bld(tetris_rand(),NUM_SHAPES)],&current);
    current.col = mod_bld(tetris_rand(),(TETRIS_COLS-current.width+1));
    current.row = 0;
	if(!CheckPosition(&current)){
		GameOn = FALSE;
		//printf("Game on = false\n");
	}
}

void RotateShape(Shape* shape){ //rotates clockwise
	Shape temp;
	int i, j, k, width;
	CopyShape(shape,&temp);
	width = shape->width;
	for(i = 0; i < width ; i++){
		for(j = 0, k = width-1; j < width ; j++, k--){
				shape->array[i][j] = temp.array[k][i];
		}
	}
}

void WriteToTable(){
	int i, j;
	for(i = 0; i < current.width ;i++){
		for(j = 0; j < current.width ; j++){
			if(current.array[i][j])
				Table[current.row+i][current.col+j] = current.array[i][j];
		}
	}
}

void RemoveFullRowsAndUpdateScore(){
	int i, j, sum, count=0;
	int l, k;
	int compliment_to_say;
	for(i=0;i<TETRIS_ROWS;i++){
		sum = 0;
		for(j=0;j< TETRIS_COLS;j++) {
			sum+=Table[i][j];
		}
		if(sum==TETRIS_COLS){
			count++;

			for(k = i;k >=1;k--)
				for(l=0;l<TETRIS_COLS;l++)
					Table[k][l]=Table[k-1][l];
			for(l=0;l<TETRIS_COLS;l++)
				Table[k][l]=0;
			
			compliment_to_say = mod_bld(tetris_rand(),NUM_LINE_SUCCESS_MESSAGES);
			switch (compliment_to_say) {
			case 0:  say_awesome(); break;
			case 1:  say_cool(); break;
			case 2:  say_yeah(); break;
			default: say_yeah(); break;
			}
			Tetris_Speed.speed = Tetris_Speed.speed + Tetris_Speed.speed_increase;
		}
	}
	tetris_score += 100*count;
}

void PrintTable(){
	int i, j;
	char score_str[128];
	char Buffer[TETRIS_ROWS][TETRIS_COLS];
	for(i = 0; i < TETRIS_ROWS ;i++){
		for(j = 0; j < TETRIS_COLS ; j++){
		Buffer[i][j] = 0;
		}
	}

	for(i = 0; i < current.width ;i++){
		for(j = 0; j < current.width ; j++){
			if(current.array[i][j])
				Buffer[current.row+i][current.col+j] = current.array[i][j];
		}
	}
	
	go_to_top_corner();
	printw("\n\n\n","initial_newline");
	for(i=0; i<TETRIS_COLS-9; i++) {
		printw(" ","space");
	}
	printw("CPEN412 Tetris\n","title");
	for(i = 0; i < TETRIS_ROWS ;i++){
		for(j = 0; j < TETRIS_COLS ; j++){
			if (Table[i][j] + Buffer[i][j]) {
				printw("#","table#");
			} else {
				printw(".","table.");
		    }
			//printw(" ","space2");
		}
		printw("\n","newline1");
	}

	sprintf(score_str,"\nScore: %d\n",tetris_score);
	printw(score_str,"scoreprint");
}

void ManipulateCurrent(int action){
	Shape temp;
	CopyShape(&current,&temp);
	switch(action){
		case 's':
			temp.row++;  //move down
			if(CheckPosition(&temp)) {
				current.row++;
			} else {
				WriteToTable();
				RemoveFullRowsAndUpdateScore();
                SetNewRandomShape();
			}
			break;
		case 'd':
			temp.col++;  //move right
			if(CheckPosition(&temp))
				current.col++;
			break;
		case 'a':
			temp.col--;  //move left
			if(CheckPosition(&temp))
				current.col--;
			break;
		case 'w':
			RotateShape(&temp); // rotate clockwise
			if(CheckPosition(&temp))
				RotateShape(&current);
			break;
	}
	PrintTable();
}

void initTetris_Speed()
{
    Tetris_Speed.speed          = INITIAL_TETRIS_SPEED ;
    Tetris_Speed.speed_increase = TETRIS_SPEED_INCREASE;
}

void tetris_mainloop()
{
	int current_time;
	int got_game_over;
    while(1){
        current_time = clock();
        if (kbhit()) {
  		      ManipulateCurrent(getch());
		    if (!GameOn) {
			   break;
			}
		}
        if (current_time >= ((MILLISECONDS_PER_SEC/Tetris_Speed.speed) + tetris_timer)) {
            ManipulateCurrent('s');
			if (!GameOn) {
			   break;
			}

            tetris_timer = current_time;
        }

    }
}

int tetris_main() {
    int i, j;
	int test1;
	char score_str[128];
	printw_x = 0;
	printw_y = 0;
	GameOn = TRUE;
	counter = 0;

    for(i = 0; i < TETRIS_ROWS ;i++){
		for(j = 0; j < TETRIS_COLS ; j++){
			Table[i][j] = 0;
		}
	}

	InstallExceptionHandler(clock, 27) ;

//S shape
ShapesArray[0].array[0][0] = 	0;
ShapesArray[0].array[0][1] = 	1;
ShapesArray[0].array[0][2] = 	1;
ShapesArray[0].array[1][0] = 	1;
ShapesArray[0].array[1][1] = 	1;
ShapesArray[0].array[1][2] = 	0;
ShapesArray[0].array[2][0] = 	0;
ShapesArray[0].array[2][1] = 	0;
ShapesArray[0].array[2][2] = 	0;
ShapesArray[0].width       = 	3;

//Z shape
ShapesArray[1].array[0][0] = 	1;
ShapesArray[1].array[0][1] = 	1;
ShapesArray[1].array[0][2] = 	0;
ShapesArray[1].array[1][0] = 	0;
ShapesArray[1].array[1][1] = 	1;
ShapesArray[1].array[1][2] = 	1;
ShapesArray[1].array[2][0] = 	0;
ShapesArray[1].array[2][1] = 	0;
ShapesArray[1].array[2][2] = 	0;
ShapesArray[1].width       = 	3;


//T shape
ShapesArray[2].array[0][0] = 	0;
ShapesArray[2].array[0][1] = 	1;
ShapesArray[2].array[0][2] = 	0;
ShapesArray[2].array[1][0] = 	1;
ShapesArray[2].array[1][1] = 	1;
ShapesArray[2].array[1][2] = 	1;
ShapesArray[2].array[2][0] = 	0;
ShapesArray[2].array[2][1] = 	0;
ShapesArray[2].array[2][2] = 	0;
ShapesArray[2].width       = 	3;


//L shape
ShapesArray[3].array[0][0] = 	0;
ShapesArray[3].array[0][1] = 	0;
ShapesArray[3].array[0][2] = 	1;
ShapesArray[3].array[1][0] = 	1;
ShapesArray[3].array[1][1] = 	1;
ShapesArray[3].array[1][2] = 	1;
ShapesArray[3].array[2][0] = 	0;
ShapesArray[3].array[2][1] = 	0;
ShapesArray[3].array[2][2] = 	0;
ShapesArray[3].width       = 	3;

//flipped L shape
ShapesArray[4].array[0][0] = 	1;
ShapesArray[4].array[0][1] = 	0;
ShapesArray[4].array[0][2] = 	0;
ShapesArray[4].array[1][0] = 	1;
ShapesArray[4].array[1][1] = 	1;
ShapesArray[4].array[1][2] = 	1;
ShapesArray[4].array[2][0] = 	0;
ShapesArray[4].array[2][1] = 	0;
ShapesArray[4].array[2][2] = 	0;
ShapesArray[4].width       = 	3;

//square shape
ShapesArray[5].array[0][0] = 	1;
ShapesArray[5].array[0][1] = 	1;
ShapesArray[5].array[1][0] = 	1;
ShapesArray[5].array[1][1] = 	1;
ShapesArray[5].width       = 	2;


//long bar shape
ShapesArray[6].array[0][0] = 	0;
ShapesArray[6].array[0][1] = 	0;
ShapesArray[6].array[0][2] = 	0;
ShapesArray[6].array[0][3] = 	0;
ShapesArray[6].array[1][0] = 	1;
ShapesArray[6].array[1][1] = 	1;
ShapesArray[6].array[1][2] = 	1;
ShapesArray[6].array[1][3] = 	1;
ShapesArray[6].array[2][0] = 	0;
ShapesArray[6].array[2][1] = 	0;
ShapesArray[6].array[2][2] = 	0;
ShapesArray[6].array[2][3] = 	0;
ShapesArray[6].array[3][0] = 	0;
ShapesArray[6].array[3][1] = 	0;
ShapesArray[6].array[3][2] = 	0;
ShapesArray[6].array[3][3] = 	0;
ShapesArray[6].width       = 	4;
    set_color(TETRIS_COLOR);
	set_vga_control_reg(OCTL_TETRIS_DEFAULT);
    tetris_score = 0;
	initTetris_Speed();
	clear_screen();

	tetris_timer = clock();
	SetNewRandomShape();
    PrintTable();	
	tetris_mainloop();
	
	for(i = 0; i < TETRIS_ROWS ;i++){
		for(j = 0; j < TETRIS_COLS ; j++){
			if (Table[i][j]) {
			  printf("#");
			} else {
			  printf(".");
			}
		}
		printf("\n");
	}
	printf("\nGame over!\n");
	sprintf(score_str,"\nScore: %d\n",tetris_score);
	printf(score_str);
	gameOver();
    return 0;
}