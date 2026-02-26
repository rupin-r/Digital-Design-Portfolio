	.data

	.global up_arrow_b
	.global right_arrow_b
	.global down_arrow_b
	.global left_arrow_b
	.global up_arrow_r
	.global right_arrow_r
	.global down_arrow_r
	.global left_arrow_r
	.global left_border_w
	.global up_border_w
	.global down_border_w
	.global right_border_w
	.global left_border_y
	.global up_border_y
	.global down_border_y
	.global right_border_y
	.global clear_screen
	.global row1
	.global row2
	.global row3
	.global row4
	.global border_left
	.global border_up
	.global border_down
	.global border_right
	.global place1
	.global place2
	.global place3
	.global place4
	.global offset1
	.global offset2
	.global offset3
	.global offset4
	.global offend1
	.global offend2
	.global offend3
	.global offend4

up_arrow_b: 	.string 27, "[30;40m", "       ", 27, "[31;41m", " ", 0xA;	row1
				.string 27, "[6D", "   ", 0xA;					row2
				.string 27, "[12D", "     ", 0xA;				row3
				.string 27, "[18D", "       ", 0xA;				row4
				.string 27, "[24D", "         ", 0xA;			row5
				.string 27, "[30D", "           ", 0xA;			row6
				.string 27, "[36D", "    ", 27, "[30;40m", " ", 27, "[31;41m", "   ", 27, "[30;40m", " ", 27, "[31;41m", "    ", 0xA
				.string 27, "[42D", "    ", 27, "[30;40m", "  ", 27, "[31;41m", "   ", 27, "[30;40m", "  ", 27, "[31;41m", "    ", 0xA
				.string 27, "[45D", "   ", 27, "[30;40m", "   ", 27, "[31;41m", "   ", 27, "[30;40m", "   ", 27, "[31;41m", "   ", 0xA
				.string 27, "[45D", "  ", 27, "[30;40m", "    ", 27, "[31;41m", "   ", 27, "[30;40m", "    ", 27, "[31;41m", "  ", 0xA
				.string 27, "[27D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[6D", " ", 0

right_arrow_b:	.string 27, "[30;40m", "     ", 27, "[31;41m", "   ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[36D", "             ", 0xA
				.string 27, "[42D", "               ", 0xA
				.string 27, "[42D", "             ", 0xA
				.string 27, "[15D", "    ", 0xA
				.string 27, "[15D", "    ", 0xA
				.string 27, "[15D", "    ", 0xA
				.string 27, "[15D", "    ", 0xA
				.string 27, "[15D", "    ", 0xA
				.string 27, "[12D", "   ", 0

down_arrow_b:	.string 27, "[30;40m", "       ", 27, "[31;41m", " ", 0xA
				.string 27, "[6D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[9D", "   ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[31;41m", "   ", 27, "[30;40m", "    ", 27, "[31;41m", "  ", 0xA
				.string 27, "[45D", "   ", 27, "[30;40m", "   ", 27, "[31;41m", "   ", 27, "[30;40m", "   ", 27, "[31;41m", "   ", 0xA
				.string 27, "[45D", "    ", 27, "[30;40m", "  ", 27, "[31;41m", "   ", 27, "[30;40m", "  ", 27, "[31;41m", "    ", 0xA
				.string 27, "[45D", 27, "[30;40m", " ", 27, "[31;41m", "    ", 27, "[30;40m", " ", 27, "[31;41m", "   ", 27, "[30;40m", " ", 27, "[31;41m", "    ", 27, "[30;40m", " ", 0xA
				.string 27, "[39D", 27, "[31;41m", "           ", 0xA
				.string 27, "[30D", "         ", 0xA
				.string 27, "[24D", "       ", 0xA
				.string 27, "[18D", "     ", 0xA
				.string 27, "[12D", "   ", 0xA
				.string 27, "[6D", " ", 0

left_arrow_b:	.string 27, "[30;40m", "       ", 27, "[31;41m", "   ", 0xA
				.string 27, "[12D", "    ", 0xA
				.string 27, "[15D", "    ", 27, "[30;40m", " ", 0xA
				.string 27, "[18D", 27, "[31;41m", "    ", 27, "[30;40m", "  ", 0xA
				.string 27, "[21D", 27, "[31;41m", "    ", 27, "[30;40m", "   ", 0xA
				.string 27, "[24D", 27, "[31;41m", "    ", 27, "[30;40m", "    ", 0xA
				.string 27, "[27D", 27, "[31;41m", "             ", 27, "[30;40m", " ", 0xA
				.string 27, "[45D", 27, "[31;41m", "               ", 0xA
				.string 27, "[42D", "             ", 0xA
				.string 27, "[36D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "    ", 0xA
				.string 27, "[9D", "   ", 0

left_border_w:	.string 27, "[30;40m", "       ", 27, "[37;47m", "     ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "         ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "             ", 27, "[37;47m", "  ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "               ", 27, "[37;47m", " ", 0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "             ", 27, "[37;47m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "         ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", "     ", 0

up_border_w:	.string 27, "[30;40m", "       ", 27, "[37;47m", "   ", 0xA
				.string 27, "[12D", "  ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "     ", 27, "[37;47m", "  ", 0xA
				.string 27, "[30D", "  ", 27, "[30;40m", "       ", 27, "[37;47m", "  ", 0xA
				.string 27, "[36D", "  ", 27, "[30;40m", "         ", 27, "[37;47m", "  ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "           ", 27, "[37;47m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "   ", 27, "[37;47m", "   ", 27, "[30;40m", "   ", 27, "[37;47m", "   ", 27, "[30;40m", "   ", 27, "[37;47m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "  ", 27, "[37;47m", "  ", 27, "[30;40m", " ", 27, "[37;47m", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 27, "[30;40m", "  ", 27, "[37;47m", " ", 0xA
				.string 27, "[51D", "    ", 27, "[30;40m", "  ", 27, "[37;47m", " ",  27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", "  ", 27, "[37;47m", "    ", 0xA
				.string 27, "[33D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", "  ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 0xA
				.string 27, "[12D", "   ", 0

down_border_w:	.string 27, "[30;40m", "       ", 27, "[37;47m", "   ", 0xA
				.string 27, "[12D", "  ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 0xA
				.string 27, "[33D", "    ", 27, "[30;40m", "  ", 27, "[37;47m", " ",  27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", "  ", 27, "[37;47m", "    ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "  ", 27, "[37;47m", "  ", 27, "[30;40m", " ", 27, "[37;47m", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 27, "[30;40m", "  ", 27, "[37;47m", " ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "   ", 27, "[37;47m", "   ", 27, "[30;40m", "   ", 27, "[37;47m", "   ", 27, "[30;40m", "   ", 27, "[37;47m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ",0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", " ", 27, "[30;40m", "   ", 27, "[37;47m", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ",0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "           ", 27, "[37;47m", "  ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "         ", 27, "[37;47m", "  ", 0xA
				.string 27, "[36D", "  ", 27, "[30;40m", "       ", 27, "[37;47m", "  ", 0xA
				.string 27, "[30D", "  ", 27, "[30;40m", "     ", 27, "[37;47m", "  ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", " ", 27, "[37;47m", "  ", 0xA
				.string 27, "[12D", "   ", 0

right_border_w:	.string 27, "[30;40m", "     ", 27, "[37;47m", "     ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 0xA
				.string 27, "[18D", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[42D", "         ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "             ", 27, "[37;47m", "  ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "               ", 27, "[37;47m", " ", 0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "             ", 27, "[37;47m", "  ", 0xA
				.string 27, "[48D", "         ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[24D", " ", 27, "[30;40m", "    ", 27, "[37;47m", "  ", 0xA
				.string 27, "[21D", " ", 27, "[30;40m", "   ", 27, "[37;47m", "  ", 0xA
				.string 27, "[18D", "     ", 0

left_border_y:	.string 27, "[30;40m", "       ", 27, "[33;43m", "     ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "         ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "             ", 27, "[33;43m", "  ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "               ", 27, "[33;43m", " ", 0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "             ", 27, "[33;43m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "         ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", "     ", 0

up_border_y:	.string 27, "[30;40m", "       ", 27, "[33;43m", "   ", 0xA
				.string 27, "[12D", "  ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "     ", 27, "[33;43m", "  ", 0xA
				.string 27, "[30D", "  ", 27, "[30;40m", "       ", 27, "[33;43m", "  ", 0xA
				.string 27, "[36D", "  ", 27, "[30;40m", "         ", 27, "[33;43m", "  ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "           ", 27, "[33;43m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "   ", 27, "[33;43m", "   ", 27, "[30;40m", "   ", 27, "[33;43m", "   ", 27, "[30;40m", "   ", 27, "[33;43m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "  ", 27, "[33;43m", "  ", 27, "[30;40m", " ", 27, "[33;43m", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 27, "[30;40m", "  ", 27, "[33;43m", " ", 0xA
				.string 27, "[51D", "    ", 27, "[30;40m", "  ", 27, "[33;43m", " ",  27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", "  ", 27, "[33;43m", "    ", 0xA
				.string 27, "[33D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", "  ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 0xA
				.string 27, "[12D", "   ", 0

down_border_y:	.string 27, "[30;40m", "       ", 27, "[33;43m", "   ", 0xA
				.string 27, "[12D", "  ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 0xA
				.string 27, "[33D", "    ", 27, "[30;40m", "  ", 27, "[33;43m", " ",  27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", "  ", 27, "[33;43m", "    ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "  ", 27, "[33;43m", "  ", 27, "[30;40m", " ", 27, "[33;43m", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 27, "[30;40m", "  ", 27, "[33;43m", " ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "   ", 27, "[33;43m", "   ", 27, "[30;40m", "   ", 27, "[33;43m", "   ", 27, "[30;40m", "   ", 27, "[33;43m", " ",0xA
				.string 27, "[51D", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ",0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", " ", 27, "[30;40m", "   ", 27, "[33;43m", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ",0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "           ", 27, "[33;43m", "  ", 0xA
				.string 27, "[42D", "  ", 27, "[30;40m", "         ", 27, "[33;43m", "  ", 0xA
				.string 27, "[36D", "  ", 27, "[30;40m", "       ", 27, "[33;43m", "  ", 0xA
				.string 27, "[30D", "  ", 27, "[30;40m", "     ", 27, "[33;43m", "  ", 0xA
				.string 27, "[24D", "  ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 0xA
				.string 27, "[18D", "  ", 27, "[30;40m", " ", 27, "[33;43m", "  ", 0xA
				.string 27, "[12D", "   ", 0

right_border_y:	.string 27, "[30;40m", "     ", 27, "[33;43m", "     ", 0xA
				.string 27, "[15D", " ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 0xA
				.string 27, "[18D", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[42D", "         ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[48D", "  ", 27, "[30;40m", "             ", 27, "[33;43m", "  ", 0xA
				.string 27, "[51D", " ", 27, "[30;40m", "               ", 27, "[33;43m", " ", 0xA
				.string 27, "[51D", "  ", 27, "[30;40m", "             ", 27, "[33;43m", "  ", 0xA
				.string 27, "[48D", "         ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[27D", "  ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[24D", " ", 27, "[30;40m", "    ", 27, "[33;43m", "  ", 0xA
				.string 27, "[21D", " ", 27, "[30;40m", "   ", 27, "[33;43m", "  ", 0xA
				.string 27, "[18D", "     ", 0

clear_arrow:	.string 27, "[30;40m", "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0xA
				.string "               ", 0

clear_screen:	.string 27, "[30;40m", 27, "[15;1H", 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0xA, 27, "[0K", 0
clear:			.string 27, "[39;49m", 27, "[0J", 0

row1: .string 27,"[0271;0022H", 27, "[37;40m", 0
row2: .string 27,"[0271;0102H", 27, "[37;40m", 0
row3: .string 27,"[0271;0182H", 27, "[37;40m", 0
row4: .string 27,"[0271;0262H", 27, "[37;40m", 0
border_left:	.string 27, "[0040;0020H", 0
border_up: 		.string 27, "[0040;0180H", 0
border_down: 	.string 27, "[0040;0100H", 0
border_right: 	.string 27, "[0040;0260H", 0
place1: .string "000000000000000", 0
place2: .string "000000000000000", 0
place3: .string "000000000000000", 0
place4: .string "000000000000000", 0
offset1: .byte 0
offset2: .byte 0
offset3: .byte 0
offset4: .byte 0
offend1: .byte 0
offend2: .byte 0
offend3: .byte 0
offend4: .byte 0

	.global Game_loop
	.global simple_int_to_string
	.global character_to_value
	.global timer_init
	.global output_string
	.global output_character
	.global push_btn_interrupt_init
	.global gpio_btn_and_LED_init	; This is from your Lab #4 Library
	.global perfect
	.global good
	.global miss
	.global adc0_init
	.global adc1_init

.text
;pointers to locations in memory for easier access
ptr_to_row1:		.word row1
ptr_to_row2:		.word row2
ptr_to_row3:		.word row3
ptr_to_row4:		.word row4
ptr_to_place1:		.word place1
ptr_to_place2:		.word place2
ptr_to_place3:		.word place3
ptr_to_place4:		.word place4
ptr_to_start1:		.word offset1
ptr_to_end1:		.word offend1
ptr_to_start2:		.word offset2
ptr_to_end2:		.word offend2
ptr_to_start3:		.word offset3
ptr_to_end3:		.word offend3
ptr_to_start4:		.word offset4
ptr_to_end4:		.word offend4
ptr_to_up_b:		.word up_arrow_b
ptr_to_right_b:		.word right_arrow_b
ptr_to_left_b:		.word left_arrow_b
ptr_to_down_b:		.word down_arrow_b
ptr_to_clear:		.word clear_screen
ptr_to_border_lw:	.word left_border_w
ptr_to_border_uw:	.word up_border_w
ptr_to_border_dw:	.word down_border_w
ptr_to_border_rw:	.word right_border_w
ptr_to_border_ly:	.word left_border_y
ptr_to_border_uy:	.word up_border_y
ptr_to_border_dy:	.word down_border_y
ptr_to_border_ry:	.word right_border_y
ptr_to_border_l:	.word border_left
ptr_to_border_u:	.word border_up
ptr_to_border_d:	.word border_down
ptr_to_border_r:	.word border_right
ptr_to_clear_arrow:	.word clear_arrow
ptr_to_cl:			.word clear

;start the game loop that allows for animation


Game_loop:
	PUSH{lr}

	ldr r0, ptr_to_row1
	bl output_string
	mov r0, #0xA
	bl output_character
	mov r0, #0xC
	bl output_character
	mov r0, #0xD
	bl output_character

	ldr r0, ptr_to_place1
	ldr r1, ptr_to_place2
	ldr r2, ptr_to_place3
	ldr r3, ptr_to_place4

	mov r4, #0
	mov r5, #0

reset_loop:

	cmp r4, #15
	beq done_reset

	strb r5, [r0, r4]
	strb r5, [r1, r4]
	strb r5, [r2, r4]
	strb r5, [r3, r4]
	add r4, r4, #1

	b reset_loop

done_reset:

	bl timer_init

print_border:

	ldr r0, ptr_to_clear
	bl output_string
	ldr r0, ptr_to_border_l
	bl output_string
	ldr r0, ptr_to_border_lw
	bl output_string
	ldr r0, ptr_to_border_u
	bl output_string
	ldr r0, ptr_to_border_uw
	bl output_string
	ldr r0, ptr_to_border_d
	bl output_string
	ldr r0, ptr_to_border_dw
	bl output_string
	ldr r0, ptr_to_border_r
	bl output_string
	ldr r0, ptr_to_border_rw
	bl output_string


The_Game_Loop:
	add r0, r0, #1
	mov r1, #1
	sub r0, r0, r1
	cmp r9, #0
	beq skip_input
	mov r7, #8
	and r7, r9, r7
	cmp r9, r7
	bne input_left
	sub r9, r9, #8

;up
	ldr r0, ptr_to_border_u
	bl output_string
	ldr r0, ptr_to_border_uy
	bl output_string
	ldr r2, ptr_to_start3
	ldrb r2, [r2]
	ldr r1, ptr_to_place3
	ldrb r0, [r1, r2]
	cmp r0, #6
	bgt skip_input
	cmp r0, #0
	beq skip_input
	cmp r0, #2
	blt not_perfect_3
	cmp r0, #4
	bgt not_perfect_3
	bl perfect
	b print3
not_perfect_3:
	bl good
print3:
	ldr r2, ptr_to_start3
	ldrb r2, [r2]
	ldr r1, ptr_to_place3
	ldrb r0, [r1, r2]
	bl simple_int_to_string
	ldr r1, ptr_to_row3
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_clear_arrow
	bl output_string
	mov r0, #0
	ldr r2, ptr_to_start3
	ldrb r2, [r2]
	ldr r1, ptr_to_place3
	strb r0, [r1, r2]
	add r2, r2, #1
	cmp r2, #15
	bne all_set3
	sub r2, r2, #15
all_set3:
	ldr r1, ptr_to_start3
	strb r2, [r1]
	b skip_input

input_left:
	mov r7, #1
	and r7, r9, r7
	cmp r9, r7
	bne input_right
	sub r9, r9, #1
	ldr r0, ptr_to_border_l
	bl output_string
	ldr r0, ptr_to_border_ly
	bl output_string
	ldr r2, ptr_to_start1
	ldrb r2, [r2]
	ldr r1, ptr_to_place1
	ldrb r0, [r1, r2]
	cmp r0, #6
	bgt skip_input
	cmp r0, #0
	beq skip_input
	cmp r0, #2
	blt not_perfect_1
	cmp r0, #4
	bgt not_perfect_1
	bl perfect
	b print1
not_perfect_1:
	bl good
print1:
	ldr r2, ptr_to_start1
	ldrb r2, [r2]
	ldr r1, ptr_to_place1
	ldrb r0, [r1, r2]
	bl simple_int_to_string
	ldr r1, ptr_to_row1
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_clear_arrow
	bl output_string
	mov r0, #0
	ldr r2, ptr_to_start1
	ldrb r2, [r2]
	ldr r1, ptr_to_place1
	strb r0, [r1, r2]
	add r2, r2, #1
	cmp r2, #15
	bne all_set1
	sub r2, r2, #15
all_set1:
	ldr r1, ptr_to_start1
	strb r2, [r1]
	b skip_input

input_right:
	mov r7, #2
	and r7, r9, r7
	cmp r9, r7
	bne input_down
	sub r9, r9, #2
	ldr r0, ptr_to_border_r
	bl output_string
	ldr r0, ptr_to_border_ry
	bl output_string
	ldr r2, ptr_to_start4
	ldrb r2, [r2]
	ldr r1, ptr_to_place4
	ldrb r0, [r1, r2]
	cmp r0, #6
	bgt skip_input
	cmp r0, #0
	beq skip_input
	cmp r0, #2
	blt not_perfect_4
	cmp r0, #4
	bgt not_perfect_4
	bl perfect
	b print4
not_perfect_4:
	bl good
print4:
	ldr r2, ptr_to_start4
	ldrb r2, [r2]
	ldr r1, ptr_to_place4
	ldrb r0, [r1, r2]
	bl simple_int_to_string
	ldr r1, ptr_to_row4
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_clear_arrow
	bl output_string
	mov r0, #0
	ldr r2, ptr_to_start4
	ldrb r2, [r2]
	ldr r1, ptr_to_place4
	strb r0, [r1, r2]
	add r2, r2, #1
	cmp r2, #15
	bne all_set4
	sub r2, r2, #15
all_set4:
	ldr r1, ptr_to_start4
	strb r2, [r1]
	b skip_input

input_down:
	mov r7, #4
	and r7, r9, r7
	cmp r9, r7
	bne skip_input
	sub r9, r9, #4
	ldr r0, ptr_to_border_d
	bl output_string
	ldr r0, ptr_to_border_dy
	bl output_string
	ldr r2, ptr_to_start2
	ldrb r2, [r2]
	ldr r1, ptr_to_place2
	ldrb r0, [r1, r2]
	cmp r0, #6
	bgt skip_input
	cmp r0, #0
	beq skip_input
	cmp r0, #2
	blt not_perfect_2
	cmp r0, #4
	bgt not_perfect_2
	bl perfect
	b print2
not_perfect_2:
	bl good
print2:
	ldr r2, ptr_to_start2
	ldrb r2, [r2]
	ldr r1, ptr_to_place2
	ldrb r0, [r1, r2]
	bl simple_int_to_string
	ldr r1, ptr_to_row2
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_clear_arrow
	bl output_string
	mov r0, #0
	ldr r2, ptr_to_start2
	ldrb r2, [r2]
	ldr r1, ptr_to_place2
	strb r0, [r1, r2]
	add r2, r2, #1
	cmp r2, #15
	bne all_set2
	sub r2, r2, #15
all_set2:
	ldr r1, ptr_to_start2
	strb r2, [r1]
	b skip_input

skip_input:
	mov r9, #0
	cmp r8, #1
	bne The_Game_Loop
	mov r8, #0

	ldrb r4, [r10]
	cmp r4, #0x2A
	beq End_of_Song

	ldr r0, ptr_to_border_r
	bl output_string
	ldr r0, ptr_to_border_rw
	bl output_string
	ldr r0, ptr_to_cl
	bl output_string

print_row1:
	ldr r4, ptr_to_start1
	ldrb r4, [r4]
	ldr r5, ptr_to_end1
	ldrb r5, [r5]
	ldr r6, ptr_to_place1


loop_row1:
	cmp r4, r5
	beq print_row2
	ldrb r0, [r6, r4]
	bl simple_int_to_string
	ldr r1, ptr_to_row1
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_left_b
	bl output_string

	add r4, r4, #1
	cmp r4, #15
	bne loop_row1
	sub r4, r4, #15
	b loop_row1

print_row2:
	ldr r4, ptr_to_start2
	ldrb r4, [r4]
	ldr r5, ptr_to_end2
	ldrb r5, [r5]
	ldr r6, ptr_to_place2

loop_row2:
	cmp r4, r5
	beq print_row3

	ldrb r0, [r6, r4]
	bl simple_int_to_string
	ldr r1, ptr_to_row2
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_down_b
	bl output_string

	add r4, r4, #1
	cmp r4, #15
	bne loop_row2
	sub r4, r4, #15
	b loop_row2

print_row3:
	ldr r4, ptr_to_start3
	ldrb r4, [r4]
	ldr r5, ptr_to_end3
	ldrb r5, [r5]
	ldr r6, ptr_to_place3

loop_row3:
	cmp r4, r5
	beq print_row4

	ldrb r0, [r6, r4]
	bl simple_int_to_string
	ldr r1, ptr_to_row3
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_up_b
	bl output_string

	add r4, r4, #1
	cmp r4, #15
	bne loop_row3
	sub r4, r4, #15
	b loop_row3

print_row4:
	ldr r4, ptr_to_start4
	ldrb r4, [r4]
	ldr r5, ptr_to_end4
	ldrb r5, [r5]
	ldr r6, ptr_to_place4

loop_row4:
	cmp r4, r5
	beq done_printing

	ldrb r0, [r6, r4]
	bl simple_int_to_string
	ldr r1, ptr_to_row4
	strb r0, [r1, #5]
	lsr r0, r0, #8
	strb r0, [r1, #4]
	lsr r0, r0, #8
	strb r0, [r1, #3]
	mov r0, r1
	bl output_string
	ldr r0, ptr_to_right_b
	bl output_string

	add r4, r4, #1
	cmp r4, #15
	bne loop_row4
	sub r4, r4, #15
	b loop_row4


done_printing:
	;ldr r0, ptr_loc
	;bl output_string
	;ldr r0, ptr_to_draw_border
	;bl output_string

buffer:

	mov r4, #0
	add r11, r11, #1
	cmp r11, #3
	bne dont_get_next
	mov r11, #0
	ldrb r4, [r10]
	add r10, r10, #1
dont_get_next:
	bl character_to_value

buffer_row1:
	ldr r0, ptr_to_start1
	ldrb r0, [r0]
	ldr r1, ptr_to_end1
	ldrb r1, [r1]
	ldr r2, ptr_to_place1

	mov r5, r0

incr_row1:
	cmp r0, r1
	beq end_buffer_row1

	ldrb r3, [r2, r0]
	sub r3, r3, #1
	cmp r3, #0
	bne skip_clear1
	bl miss
	add r5, r5, #1
	cmp r5, #15
	bne skip_store1
	sub r5, r5, #15
	b skip_store1

skip_clear1:
	strb r3, [r2, r0]

skip_store1:
	add r0, r0, #1
	cmp r0, #15
	bne incr_row1
	sub r0, r0, #15
	b incr_row1

end_buffer_row1:
	ldr r0, ptr_to_start1
	strb r5, [r0]
	and r5, r4, #1
	cmp r5, #0
	beq buffer_row2

	add r5, r1, #1
	cmp r5, #15
	bne skip_turn1
	sub r5, r5, #15

skip_turn1:
	ldr r3, ptr_to_end1
	mov r6, #25
	strb r6, [r2, r1]
	strb r5, [r3]



buffer_row2:
	ldr r0, ptr_to_start2
	ldrb r0, [r0]
	ldr r1, ptr_to_end2
	ldrb r1, [r1]
	ldr r2, ptr_to_place2

	mov r5, r0

incr_row2:
	cmp r0, r1
	beq end_buffer_row2

	ldrb r3, [r2, r0]
	sub r3, r3, #1
	cmp r3, #0
	bne skip_clear2
	bl miss
	add r5, r5, #1
	cmp r5, #15
	bne skip_store2
	sub r5, r5, #15
	b skip_store2

skip_clear2:
	strb r3, [r2, r0]

skip_store2:
	add r0, r0, #1
	cmp r0, #15
	bne incr_row2
	sub r0, r0, #15
	b incr_row2

end_buffer_row2:
	ldr r0, ptr_to_start2
	strb r5, [r0]
	and r5, r4, #2
	cmp r5, #0
	beq buffer_row3

	add r5, r1, #1
	cmp r5, #15
	bne skip_turn2
	sub r5, r5, #15

skip_turn2:
	ldr r3, ptr_to_end2
	mov r6, #25
	strb r6, [r2, r1]
	strb r5, [r3]



buffer_row3:
	ldr r0, ptr_to_start3
	ldrb r0, [r0]
	ldr r1, ptr_to_end3
	ldrb r1, [r1]
	ldr r2, ptr_to_place3

	mov r5, r0

incr_row3:
	cmp r0, r1
	beq end_buffer_row3

	ldrb r3, [r2, r0]
	sub r3, r3, #1
	cmp r3, #0
	bne skip_clear3
	bl miss
	add r5, r5, #1
	cmp r5, #15
	bne skip_store3
	sub r5, r5, #15
	b skip_store3

skip_clear3:
	strb r3, [r2, r0]

skip_store3:
	add r0, r0, #1
	cmp r0, #15
	bne incr_row3
	sub r0, r0, #15
	b incr_row3

end_buffer_row3:
	ldr r0, ptr_to_start3
	strb r5, [r0]
	and r5, r4, #4
	cmp r5, #0
	beq buffer_row4

	add r5, r1, #1
	cmp r5, #15
	bne skip_turn3
	sub r5, r5, #15

skip_turn3:
	ldr r3, ptr_to_end3
	mov r6, #25
	strb r6, [r2, r1]
	strb r5, [r3]



buffer_row4:
	ldr r0, ptr_to_start4
	ldrb r0, [r0]
	ldr r1, ptr_to_end4
	ldrb r1, [r1]
	ldr r2, ptr_to_place4

	mov r5, r0

incr_row4:
	cmp r0, r1
	beq end_buffer_row4

	ldrb r3, [r2, r0]
	sub r3, r3, #1
	cmp r3, #0
	bne skip_clear4
	bl miss
	add r5, r5, #1
	cmp r5, #15
	bne skip_store4
	sub r5, r5, #15
	b skip_store4

skip_clear4:
	strb r3, [r2, r0]

skip_store4:
	add r0, r0, #1
	cmp r0, #15
	bne incr_row4
	sub r0, r0, #15
	b incr_row4

end_buffer_row4:
	ldr r0, ptr_to_start4
	strb r5, [r0]
	and r5, r4, #8
	cmp r5, #0
	beq end_buffer

	add r5, r1, #1
	cmp r5, #15
	bne skip_turn4
	sub r5, r5, #15

skip_turn4:
	ldr r3, ptr_to_end4
	mov r6, #25
	strb r6, [r2, r1]
	strb r5, [r3]

end_buffer:

	b print_border

End_of_Song:
	POP{lr}
	mov pc, lr
