#include <stdio.h>
#include <ncurses.h>

#import <Foundation/Foundation.h>

// TO  GET ENV
#include <stdlib.h>

// TO GET chdir(); AKA `cd`
// system() doesn't work
#include <unistd.h>

#define WIDTH 30
#define HEIGHT 10 

int startx = 0;
int starty = 0;

char *choices[] = { 
			"Choice 1",
			"Choice 2",
			"Choice 3",
			"Choice 4",
			"Exit",
		  };

int n_choices = sizeof(choices) / sizeof(char *);
void print_menu(
	  WINDOW *menu_win
	, int highlight);

int run_chooser()
{	WINDOW *menu_win;
	int highlight = 1;
	int choice = 0;
	int c;

	initscr();
	clear();
	noecho();
	cbreak();	/* Line buffering disabled. pass on everything */
	startx = (80 - WIDTH) / 2;
	starty = (24 - HEIGHT) / 2;
		
	menu_win = newwin(HEIGHT, WIDTH, starty, startx);
	keypad(menu_win, TRUE);
	mvprintw(0, 0, "Use arrow keys to go up and down, Press enter to select a choice");
	refresh();
	print_menu(menu_win, highlight);
	while(1)
	{	c = wgetch(menu_win);
		switch(c)
		{	case KEY_UP:
				if(highlight == 1)
					highlight = n_choices;
				else
					--highlight;
				break;
			case KEY_DOWN:
				if(highlight == n_choices)
					highlight = 1;
				else 
					++highlight;
				break;
			case 10:
				choice = highlight;
				break;
			default:
				mvprintw(24, 0, "Charcter pressed is = %3d Hopefully it can be printed as '%c'", c, c);
				refresh();
				break;
		}
		print_menu(menu_win, highlight);
		if(choice != 0)	/* User did a choice come out of the infinite loop */
			break;
	}	
	mvprintw(23, 0, "You chose choice %d with choice string %s\n", choice, choices[choice - 1]);
	clrtoeol();
	refresh();
	endwin();

	// chdir("~");
	// chdir("~/GNUstep");
	//
	setenv("PWD","/home/ubuntu",1); 
	return 0;
}

int add_to_favorites(int argc, char*directories_to_add[])
{
	printf("Need to implement add to favorites.\n");

	 for (int i=0; i< argc; i++) {
	     printf("\ndir_to_add%d=%s", i, directories_to_add[i]);
	 }

	printf("\nENV: VAR = %s", getenv("PATH"));
	printf("\nENV: VAR = %s", getenv("HOME"));
	printf("\nENV: VAR = %s", getenv("ROOT"));
	printf("\nENV: VAR = %s", getenv("PWD"));
	printf("\nENV: VAR = %s", getenv("PPID"));

	// The $PPID variable holds the parent process ID. So you could parse the output from ps to get the command.
	// $(ps $PPID | tail -n 1 | awk "{print \$5}")


	 printf("\n");

	return 0;
}


void print_menu(WINDOW *menu_win, int highlight)
{
	int x, y, i;	

	x = 2;
	y = 2;
	box(menu_win, 0, 0);
	for(i = 0; i < n_choices; ++i)
	{	if(highlight == i + 1) /* High light the present choice */
		{	wattron(menu_win, A_REVERSE); 
			mvwprintw(menu_win, y, x, "%s", choices[i]);
			wattroff(menu_win, A_REVERSE);
		}
		else
			mvwprintw(menu_win, y, x, "%s", choices[i]);
		++y;
	}
	wrefresh(menu_win);
}

int main(int argc, char*argv[], char **environ)
{
	 int i=0;
	
	 NSLog(@"we have objc!");

	 printf("\ncmdline args count=%d", argc);

	 /* First argument is executable name only */
	 printf("\nexe name=%s", argv[0]);

	 for (i=1; i< argc; i++) {
	     printf("\narg%d=%s", i, argv[i]);
	 }

	 printf("\n");

	 if (argc > 1)
	 {
		// return add_to_favorites(argv[1]);
		return add_to_favorites(argc-1, argv+1);
	 }
	 else
	 {
		return run_chooser();
	 }
	 //return 0;


}

