"GOAL for M3
Copyright 1984 Infocom, Inc.  All rights reserved.
"

"This code is the local T system."

<GLOBAL DIR-STRINGS
	<PTABLE P?NORTH "north" P?SOUTH "south"
		P?EAST "east" P?WEST "west"
		P?NW "northwest" P?NE "northeast"
		P?SW "southwest" P?SE "southeast"
		P?DOWN "downstairs" P?UP "upstairs"
		P?IN "in" P?OUT "out">>

<ROUTINE DIR-PRINT (DIR "AUX" (CNT 0))
	 #DECL ((DIR CNT) FIX)
	 <REPEAT ()
		 <COND (<==? <GET ,DIR-STRINGS .CNT> .DIR>
			<COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
			       <TELL "the ">)>
			<PRINT <GET ,DIR-STRINGS <+ .CNT 1>>>
			<RTRUE>)>
		 <SET CNT <+ .CNT 1>>>>

<GLOBAL HALL-LINE
	<PTABLE 0 HALLWAY-1 P?EAST
		P?WEST HALLWAY-2 P?EAST
		P?WEST HALLWAY-3 P?EAST
		P?WEST HALLWAY-4 P?NORTH
		P?SOUTH HALLWAY-5 P?EAST
		P?WEST HALLWAY-8 P?EAST
		P?WEST HALLWAY-9 P?EAST
		P?WEST HALLWAY-10 P?EAST
		P?WEST HALLWAY-11 P?NORTH
		P?SOUTH HALLWAY-12 P?NORTH
		P?SOUTH HALLWAY-13 P?NORTH
		P?SOUTH HALLWAY-14 P?NORTH
		P?SOUTH HALLWAY-15 P?NORTH
		P?SOUTH DINING-ROOM P?EAST
		P?WEST KITCHEN P?NORTH
		P?SOUTH BACK-ENTRY 0>>

<GLOBAL BALLROOM-LINE
	<PTABLE 24	BALLROOM-2 P?EAST
		P?WEST	BALLROOM-3 P?SOUTH
		P?NORTH	BALLROOM-6 P?SOUTH
		P?NORTH	BALLROOM-9 P?WEST
		P?EAST	BALLROOM-8 P?WEST
		P?EAST	BALLROOM-7 P?NORTH
		P?SOUTH	BALLROOM-4 P?EAST
		P?WEST	BALLROOM-5 P?NORTH
		P?SOUTH	BALLROOM-2 0>>

<GLOBAL EAST-HALL-LINE
	<PTABLE 0 HALLWAY-16 P?EAST
		P?WEST HALLWAY-17 P?EAST
		P?WEST HALLWAY-19 0>>

<GLOBAL GARAGE-LINE
	<PTABLE 0 HALLWAY-6 P?NORTH
		P?SOUTH HALLWAY-7 P?NORTH
		P?SOUTH WALKWAY P?WEST
		P?EAST GARAGE 0>>

<GLOBAL OUTSIDE-LINE
	<PTABLE 24	GARDEN	       P?NW
		P?SE	NORTH-OF-HOUSE P?WEST
		P?EAST  WEST-OF-GARAGE P?SOUTH
		P?NORTH WEST-OF-HOUSE  P?SOUTH
		P?WEST  CIRCLE	       P?EAST
		P?SOUTH OUTSIDE	       P?NORTH
		P?SOUTH PATIO	       P?NORTH
		P?EAST	BACK-PORCH     P?WEST
		P?NE    GARDEN	       0>>

<GLOBAL TRANSFER-TABLE
	<PTABLE ;"transfers for hall-line"
		0	      0
		HALLWAY-12    BALLROOM-7
		HALLWAY-11    HALLWAY-16
		HALLWAY-5     HALLWAY-6
		HALLWAY-1     WEST-OF-HOUSE

	        ;"transfers for ballroom-line"
		BALLROOM-7    HALLWAY-12
		0	      0
		BALLROOM-7    HALLWAY-12
		BALLROOM-7    HALLWAY-12
		BALLROOM-7    HALLWAY-12

	        ;"transfers for east-hall-line"
		HALLWAY-16    HALLWAY-11
	        HALLWAY-16    HALLWAY-11
	        0	      0
	        HALLWAY-16    HALLWAY-11
		HALLWAY-16    HALLWAY-11

	        ;"transfers for garage-line"
		HALLWAY-6     HALLWAY-5
	        HALLWAY-6     HALLWAY-5
	        HALLWAY-6     HALLWAY-5
	        0	      0
		WALKWAY	      GARDEN

		;"transfers for outside-line"
		WEST-OF-HOUSE HALLWAY-1
		WEST-OF-HOUSE HALLWAY-1
		WEST-OF-HOUSE HALLWAY-1
		GARDEN	      WALKWAY
		0	      0>>

;"corridors are described by the direction they run (west-to-east,
for example) and the rooms one would visit going in that direction"

<GLOBAL COR-1
	<PTABLE P?WEST P?EAST
	        HALLWAY-1 HALLWAY-2 HALLWAY-3 HALLWAY-4 0>>

<GLOBAL COR-2
	<PTABLE P?SOUTH P?NORTH
	        HALLWAY-4 HALLWAY-5 HALLWAY-6 HALLWAY-7 0>>

<GLOBAL COR-4
	<PTABLE P?WEST P?EAST
	        HALLWAY-5 HALLWAY-8 HALLWAY-9 HALLWAY-10 HALLWAY-11 0>>

<GLOBAL COR-8
	<PTABLE P?SOUTH P?NORTH
	        HALLWAY-16 HALLWAY-11 HALLWAY-12
		HALLWAY-13 HALLWAY-14 HALLWAY-15 0>>

<GLOBAL COR-16
	<PTABLE P?WEST P?EAST
	        HALLWAY-16 HALLWAY-17 HALLWAY-19 0>>

<GLOBAL COR-32
	<PTABLE P?EAST P?WEST
		BALLROOM-1 HALLWAY-14 0>>

<GLOBAL COR-64
	<PTABLE P?EAST P?WEST
		BALLROOM-4 HALLWAY-13 0>>

<GLOBAL COR-128
	<PTABLE P?EAST P?WEST
		BALLROOM-7 HALLWAY-12 0>>

<GLOBAL COR-256
	<PTABLE P?WEST P?EAST
		BALLROOM-6 PATIO 0>>

;"up to 16 corridors (65536) add them to GET-COR if new ones made"

"CODE"

<ROUTINE GOALS? (PER VAL)
	 <PUT <GET-GOALS .PER> ,GOAL-ENABLE .VAL>>

<ROUTINE FOLLOW-GOAL (PER
		      "AUX" (HERE <LOC .PER>) LINE RM GT GOAL FLG TMP
		      (HERE-FLAG 0) (GOAL-FLAG <>) (IGOAL <>) LOC (CNT 1))
	 #DECL ((PER HERE LOC RM) OBJECT (LN CNT) FIX
		(HERE-FLAG GOAL-FLAG) <OR FIX FALSE>)
	 <SET GT <GET-GOALS .PER>>
	 <COND (<==? .HERE <GET .GT ,GOAL-F>>
		<RETURN <GOAL-REACHED .PER T>>)
	       (<NOT <GET .GT ,GOAL-ENABLE>> <RFALSE>)>
	 <COND (<NOT <EQUAL? <SET LOC <GETP .HERE ,P?STATION>>
			     .HERE>>
		<RETURN <MOVE-PERSON .PER .LOC>>)>
	 <COND (<==? <SET GOAL
			  <GET ,TRANSFER-TABLE
			       <SET IGOAL <GET .GT ,GOAL-I>>>>
		     0>
		<SET IGOAL <>>
		<SET GOAL <GET .GT ,GOAL-S>>)>
	 <COND (<NOT .GOAL> <RFALSE>)
	       (<==? .HERE .GOAL>
		<COND (.IGOAL
		       <SET FLG
			    <MOVE-PERSON .PER
					 <GET ,TRANSFER-TABLE
					      <+ .IGOAL 1>>>>
		       <ESTABLISH-GOAL .PER <GET .GT ,GOAL-F>>
		       <RETURN .FLG>)
		      (<NOT <==? .HERE <GET .GT ,GOAL-F>>>
		       ;<PUT .GT ,GOAL-S <>> ;"before move-person!"
		       <SET FLG <MOVE-PERSON .PER <GET .GT ,GOAL-F>>>
		       <RETURN .FLG>)
		      (T
		       <RETURN <GOAL-REACHED .PER>>)>)>
	 <SET LINE <GET-LINE <GETP .GOAL ,P?LINE>>>
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .LINE .CNT>> .HERE>
		        <RETURN>)
		       (<==? .RM .GOAL>
			<SET GOAL-FLAG .CNT>)
		       (<==? <GET .LINE <+ .CNT 1>> 0>
			%<DEBUG-CODE
			  <TELL
"*** " CD .PER " lost between " D .HERE " and " D .GOAL " on line " N <GETP .GOAL ,P?LINE> " ***">>
			<CRLF>
			<QUIT>)>
		 <SET CNT <+ .CNT 3>>>
	 <SET HERE-FLAG .CNT>
	 <COND (<G? <GET .LINE 0> 0>
		<COND (<NOT .GOAL-FLAG>
		       <REPEAT ()
			       <SET RM <GET .LINE .CNT>>
			       <COND (<==? .RM .GOAL>
				      <SET GOAL-FLAG .CNT>
				      <RETURN>)>
			       <SET CNT <+ .CNT 3>>>)>
		<SET GOAL-FLAG <- .GOAL-FLAG .HERE-FLAG>>
		<SET TMP <- <GET .LINE 0> <ABS .GOAL-FLAG>>>
		<COND (<G? <ABS .GOAL-FLAG> .TMP>
		       <COND (<L? .GOAL-FLAG 0>
			      <SET GOAL-FLAG <>>)
			     (ELSE
			      <SET GOAL-FLAG 1>)>)
		      (<G? .GOAL-FLAG 0>
		       <SET GOAL-FLAG <>>)>)>
	 <COND (<AND .GOAL-FLAG <EQUAL? .HERE-FLAG 1>>
		<SET HERE-FLAG <+ <GET .LINE 0> 1>>)>
	 <SET LOC
	      <GET .LINE
		   <COND (.GOAL-FLAG <- .HERE-FLAG 3>)
			 (T <+ .HERE-FLAG 3>)>>>
	 <MOVE-PERSON .PER .LOC>>

<ROUTINE COR-DIR (HERE THERE "AUX" COR RM (PAST 0) (CNT 2))
	 <SET COR <GET-COR <BAND <GETP .THERE ,P?CORRIDOR>
				 <GETP .HERE ,P?CORRIDOR>>>>
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .COR .CNT>> .HERE>
			<SET PAST 1>
			<RETURN>)
		       (<==? .RM .THERE>
			<RETURN>)>
		 <SET CNT <+ .CNT 1>>>
	 <GET .COR .PAST>>

<ROUTINE GET-LINE (LN)
	 <COND (<==? .LN 0> ,HALL-LINE)
	       (<==? .LN 1> ,BALLROOM-LINE)
	       (<==? .LN 2> ,EAST-HALL-LINE)
	       (<==? .LN 3> ,GARAGE-LINE)
	       (<==? .LN 4> ,OUTSIDE-LINE)
	       (ELSE <TELL "**UNDEFINED LINE**">)>>

<ROUTINE GET-COR (NUM)
	 #DECL ((NUM) FIX)
	 <COND (<==? .NUM 1> ,COR-1)
	       (<==? .NUM 2> ,COR-2)
	       (<==? .NUM 4> ,COR-4)
	       (<==? .NUM 8> ,COR-8)
	       (<==? .NUM 16> ,COR-16)
	       (<==? .NUM 32> ,COR-32)
	       (<==? .NUM 64> ,COR-64)
	       (<==? .NUM 128> ,COR-128)
	       (T ,COR-256)>>

<GLOBAL CHARACTER-TABLE
	<TABLE PLAYER MICHAEL VERONICA ALICIA RICHARD
	       COL-MARSTON LINDA SEN-ASHER COCHRANE OSTMANN
	       BUTLER BARTENDER DETECTIVE DUFFY>>

<CONSTANT PLAYER-C 0>
<CONSTANT MICHAEL-C 1>
<CONSTANT VERONICA-C 2>
<CONSTANT ALICIA-C 3>
<CONSTANT RICHARD-C 4>
<CONSTANT COL-MARSTON-C 5>
<CONSTANT LINDA-C 6>
<CONSTANT SEN-ASHER-C 7>
<CONSTANT COCHRANE-C 8>
<CONSTANT OSTMANN-C 9>
<CONSTANT BUTLER-C 10>
<CONSTANT BARTENDER-C 11>
<CONSTANT DETECTIVE-C 12>
<CONSTANT DUFFY-C 13>

<ROUTINE INHABITED? (RM)
	 <OR <IN? ,MICHAEL .RM> <IN? ,VERONICA .RM> <IN? ,ALICIA .RM>
	     <IN? ,RICHARD .RM> <IN? ,COL-MARSTON .RM> <IN? ,LINDA .RM>
	     <IN? ,SEN-ASHER .RM> <IN? ,COCHRANE .RM> <IN? ,OSTMANN .RM>
	     <IN? ,BUTLER .RM> <IN? ,BARTENDER .RM> <IN? ,DETECTIVE .RM>
	     <IN? ,DUFFY .RM>>>

"Goal tables for the characters, offset by a constant, which,
for a given character is the P?CHARACTER property of the object."

<GLOBAL GOAL-TABLES
	<TABLE <TABLE <> <> <> 1 <> <> 5 0>
	       <TABLE <> <> <> 1 <> G-MICHAEL 5 0> ;"1"
	       <TABLE <> <> <> 1 <> G-VERONICA 5 0> ;"2"
	       <TABLE <> <> <> 1 <> G-ALICIA 5 0> ;"3"
	       <TABLE <> <> <> 1 <> G-RICHARD 5 0> ;"4"
	       <TABLE <> <> <> 1 <> G-COL-MARSTON 5 0> ;"5"
	       <TABLE <> <> <> 1 <> G-LINDA 5 0> ;"6"
	       <TABLE <> <> <> 1 <> G-SEN-ASHER 5 0> ;"7"
	       <TABLE <> <> <> 1 <> G-COCHRANE 5 0> ;"8"
	       <TABLE <> <> <> 1 <> G-OSTMANN 5 0> ;"9"
	       <TABLE <> <> <> 1 <> G-BUTLER 5 0> ;"10"
	       <TABLE <> <> <> 1 <> G-BARTENDER 5 0> ;"11"
	       <TABLE <> <> <> 1 <> G-DETECTIVE 5 0> ;"12"
	       <TABLE <> <> <> 1 <> G-DUFFY 5 0> ;"13">>

<CONSTANT CHARACTER-MAX 13>

"Offsets into GOAL-TABLEs"

<CONSTANT GOAL-F 0> ;"final goal"
<CONSTANT GOAL-S 1> ;"station of final goal"
<CONSTANT GOAL-I 2> ;"intermediate goal (transfer point)"
<CONSTANT GOAL-ENABLE 3> ;"character can move; usually false only when he's
			   interrupted enroute"
<CONSTANT GOAL-QUEUED 4> ;"secondary goal to go to when current, higher-
			   priority one has been reached"
<CONSTANT GOAL-FUNCTION 5> ;"routine to apply on arrival"
<CONSTANT ATTENTION-SPAN 6> ;"how long character will wait when interrupted"
<CONSTANT ATTENTION 7> ;"used to count down from ATTENTION-SPAN to 0"

"Goal-function constants, similar to M-xxx in MAIN"

<CONSTANT G-REACHED 1>
<CONSTANT G-ENROUTE 2>
<CONSTANT G-IMPATIENT 3>
<CONSTANT G-ALREADY 4>

"Routines to do looking down corridors"

<ROUTINE CORRIDOR-LOOK ("OPTIONAL" (ITM <>)
			"AUX" C Z COR VAL (FOUND <>))
	 <COND (<SET C <GETP ,HERE ,P?CORRIDOR>>
		<REPEAT ()
			<COND (<NOT <L? <SET Z <- .C 256>> 0>>
			       <SET COR ,COR-256>)
			      (<NOT <L? <SET Z <- .C 128>> 0>>
			       <SET COR ,COR-128>)
			      (<NOT <L? <SET Z <- .C 64>> 0>>
			       <SET COR ,COR-64>)
			      (<NOT <L? <SET Z <- .C 32>> 0>>
			       <SET COR ,COR-32>)
			      (<NOT <L? <SET Z <- .C 16>> 0>>
			       <SET COR ,COR-16>)
			      (<NOT <L? <SET Z <- .C 8>> 0>>
			       <SET COR ,COR-8>)
			      (<NOT <L? <SET Z <- .C 4>> 0>>
			       <SET COR ,COR-4>)
			      (<NOT <L? <SET Z <- .C 2>> 0>>
			       <SET COR ,COR-2>)
			      (<NOT <L? <SET Z <- .C 1>> 0>>
			       <SET COR ,COR-1>)
			      (T <RETURN>)>
			<SET VAL <CORRIDOR-CHECK .COR .ITM>>
			<COND (<NOT .FOUND> <SET FOUND .VAL>)>
			<SET C .Z>>
		.FOUND)>>

<ROUTINE CORRIDOR-CHECK (COR ITM "AUX" (CNT 2) (PAST 0) (FOUND <>) RM OBJ)
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .COR .CNT>> 0>
			<RFALSE>)
		       (<==? .RM ,HERE> <SET PAST 1>)
		       (<SET OBJ <FIRST? .RM>>
			<REPEAT ()
				<COND (.ITM
				       <COND (<==? .OBJ .ITM>
					      <SET FOUND <GET .COR .PAST>>
					      <RETURN>)>)
				      (<AND <GETP .OBJ ,P?CHARACTER>
					    <NOT <IN-MOTION? .OBJ>>>
				       <TELL CTHE .OBJ " is off to ">
				       <DIR-PRINT <GET .COR .PAST>>
				       <TELL ".">
				       <CRLF>)>
				<SET OBJ <NEXT? .OBJ>>
				<COND (<NOT .OBJ> <RETURN>)>>
			<COND (.FOUND <RETURN .FOUND>)>)>
		 <SET CNT <+ .CNT 1>>>>

"Goal tables for the characters (including PLAYER), offset
by the preceding constants, which, for a given character,
is the P?CHARACTER property of the object."

"The ATTENTION-TABLE is now a thing of the past. ATTENTION
in the GOAL-TABLES is used instead."

"Here's how the movement goals are done:  For each player is
a table which consists of triplets, a number of minutes until
the next movement (an clock interrupt number), a number of
minutes allowed variation (for a bit of randomness), and a
room toward which to start. All movement is controlled by
the GOAL-ENABLE flag in the GOAL-TABLE for a character."

"Time starts at 8AM. Characters are at that point in their
starting positions, as reflected in PEOPLE."

<GLOBAL MOVEMENT-GOALS
	<TABLE
	 ;"PLAYER"
	 <TABLE 0 0 0>
	 ;"MICHAEL"
	 <TABLE 0 0 0>
	 ;"VERONICA"
	 <TABLE 0 0 0>
	 ;"ALICIA"
	 <TABLE 0 0 0>
	 ;"RICHARD"
	 <TABLE 0
		20 -3 SUN-ROOM
		15 -3 BALLROOM-9
		0>
	 ;"COL-MARSTON"
	 <TABLE 0
		40 -3 MORNING-ROOM
		20 -5 LIVING-ROOM
		0>
	 ;"LINDA"
	 <TABLE 0
		20 -2 SUN-ROOM
		15 -3 BALLROOM-9
		0>
	 ;"SEN-ASHER"
	 <TABLE 0
		30 -2 BALLROOM-9
		5 -2 LIVING-ROOM
		10 -2 SITTING-ROOM
		0>
	 ;"COCHRANE"
	 <TABLE 0
		4 -2 BALLROOM-9
		0>
	 ;"OSTMANN"
	 <TABLE 0
		0
		0>
	 ;"BUTLER"
	 <TABLE 0
		0
		0>
	 ;"BARTENDER"
	 <TABLE 0
		0
		0>
	 ;"DETECTIVE"
	 <TABLE 0
		0
		0>
	 ;"DUFFY"
	 <TABLE 0
		0
		0>>>

<GLOBAL DETECTIVE-SCRIPT
	 <TABLE 0
		3 -1 OFFICE
		18 -3 MEDIA-ROOM
		10 -3 HALLWAY-7
		8 -2 LIVING-ROOM
		10 -2 BALLROOM-8
		0>>

<GLOBAL DUFFY-SCRIPT
	<TABLE 0
		3 -1 OFFICE
		20 -3 MEDIA-ROOM
		12 -3 HALLWAY-7
		10 -3 LIVING-ROOM
		12 -3 BALLROOM-8
		0>>

<GLOBAL MICHAEL-LOOP
	 <TABLE 0
		5 -2 BALLROOM-1
		5 -2 BALLROOM-9
		5 -2 BALLROOM-7
		5 -2 BALLROOM-9
		5 -2 BALLROOM-3
		5 -2 BALLROOM-9
		5 -2 BALLROOM-8
		0>>

<GLOBAL BUTLER-LOOP
	<TABLE 0
	       10 -1 EAST-COAT-CLOSET
	       10 -5 KITCHEN
	       8 -2 BALLROOM-9
	       8 -1 LIVING-ROOM
	       10 -1 HALL
	       0>>

<GLOBAL COCHRANE-LOOP
	<TABLE 0
	       6 -4 BALLROOM-1
	       6 -4 BALLROOM-9
	       0>>

<GLOBAL OSTMANN-LOOP
	<TABLE 0
	       12 -4 BALLROOM-3
	       9 -2 BALLROOM-7
	       15 -2 HALLWAY-15
	       10 -1 BALLROOM-9
	       0>>

<ROUTINE IN-MOTION? (PER "AUX" GT)
	 <COND (<SET GT <GET-GOALS .PER>>
		<COND (<AND <GET .GT ,GOAL-ENABLE>
			    <GET .GT ,GOAL-S>
			    <NOT <==? <LOC .PER> <GET .GT ,GOAL-F>>>>
		       <RTRUE>)
		      (T <RFALSE>)>)>>

<ROUTINE START-MOVEMENT ()
	 <ENABLE <QUEUE G-MICHAEL 1>>
	 <ENABLE <QUEUE G-ALICIA 1>>
	 <ENABLE <QUEUE G-RICHARD 1>>
	 <ENABLE <QUEUE G-COL-MARSTON 1>>
	 <ENABLE <QUEUE G-LINDA 1>>
	 <ENABLE <QUEUE G-SEN-ASHER 1>>
	 <NEW-SCRIPT ,COCHRANE ,COCHRANE-LOOP>
	 <NEW-SCRIPT ,OSTMANN ,OSTMANN-LOOP>
	 <NEW-SCRIPT ,BUTLER ,BUTLER-LOOP>
	 <ENABLE <QUEUE I-FOLLOW -1>>
	 <ENABLE <QUEUE I-ATTENTION -1>>>

"This routine does the interrupt-driven goal establishment
for the various characters, using the MOVEMENT-GOALS table."

<CONSTANT MG-ROOM 0>
<CONSTANT MG-TIME 1>
<CONSTANT MG-VARIATION 2>
<CONSTANT MG-LENGTH <* 3 2>>
<CONSTANT MG-NEXT 4>

<ROUTINE GET-GOALS (PER)
	 <SET PER <GETP .PER ,P?CHARACTER>>
	 <GET ,GOAL-TABLES .PER>>

<ROUTINE NEW-SCRIPT (PER SCRIPT "AUX" CH GT)
	 <SET CH <GETP .PER ,P?CHARACTER>>
	 <PUT ,MOVEMENT-GOALS .CH .SCRIPT>
	 <SET GT <GET ,GOAL-TABLES .CH>>
	 <PUT .GT ,GOAL-QUEUED <>>
	 <IMOVEMENT .PER
		    %<COND (<GASSIGNED? PREDGEN>
			    '<GET .GT ,GOAL-FUNCTION>)
			   (ELSE '<NTH!- .GT <+ 1 <* ,GOAL-FUNCTION 2>>>)>>
	 <RFALSE>>

<ROUTINE IMOVEMENT (PER INT "AUX" TB VAR DIS TIM ID RM GT (FLAG <>))
	 #DECL ((PER) OBJECT (TB) <PRIMTYPE VECTOR> (ID VAR DIS TIM) FIX)
	 <SET ID <GETP .PER ,P?CHARACTER>>
	 <SET TB <GET ,MOVEMENT-GOALS .ID>>
	 <SET GT <GET ,GOAL-TABLES .ID>>
	 <COND (<NOT <==? 0 <SET RM <GET .TB ,MG-ROOM>>>>
		<COND (<GET .GT ,GOAL-QUEUED>
		       <PUT .GT ,GOAL-QUEUED .RM>)
		      (T
		       <ESTABLISH-GOAL .PER .RM>)>)>
	 <COND (<NOT <==? 0 <SET TIM <GET .TB ,MG-TIME>>>>
		<COND (<L? <SET VAR <GET .TB ,MG-VARIATION>> 0>
		       <SET VAR <- .VAR>>
		       <SET FLAG T>)>
		<SET DIS <COND (<AND <G? .VAR 0>
				     <G? ,PRESENT-TIME 540>>
				<RANDOM <* .VAR 2>>)
			       (ELSE 0)>>
	        <ENABLE <QUEUE .INT <+ .TIM <- .DIS .VAR>>>>
		<PUT ,MOVEMENT-GOALS .ID <REST .TB ,MG-LENGTH>>
		<COND (<AND <NOT .FLAG> <NOT <==? 0 <GET .TB ,MG-NEXT>>>>
		       <PUT .TB
			    ,MG-NEXT
			    <+ <GET .TB ,MG-NEXT> <- .VAR .DIS>>>)>)>
	 <RFALSE>>

<ROUTINE I-FOLLOW ("AUX" (FLG <>) (CNT 0) GT VAL)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			<RETURN>)
		       (<AND <GET <SET GT <GET ,GOAL-TABLES .CNT>> ,GOAL-S>
			     <GET .GT ,GOAL-ENABLE>>
			<COND (<SET VAL
				    <FOLLOW-GOAL <GET ,CHARACTER-TABLE .CNT>>>
			       <COND (<NOT <==? .FLG ,M-FATAL>>
				      <SET FLG .VAL>)>)>)>>
	 .FLG>

<ROUTINE I-ATTENTION ("AUX" (FLG <>) (CNT 0) ATT GT)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX> <RETURN>)>
		 <SET GT <GET ,GOAL-TABLES .CNT>>
		 <SET ATT <GET .GT ,ATTENTION>>
		 <COND (<G? .ATT 0>
			<SET ATT <- .ATT 1>>
			<COND (<==? .ATT 0> <PUT .GT ,GOAL-ENABLE T>)
			      (<AND <==? .ATT 1>
				    <IN? <GET ,CHARACTER-TABLE .CNT> ,HERE>
				    %<DEBUG-CODE
				      <D-APPLY "Impatient"
					       <GET .GT ,GOAL-FUNCTION>
					       ,G-IMPATIENT>
				      <APPLY <GET .GT ,GOAL-FUNCTION>
					     ,G-IMPATIENT>>>
			       <SET FLG T>)>
			<PUT .GT ,ATTENTION .ATT>)>>
	 .FLG>

<ROUTINE GRAB-ATTENTION (PER "OPTIONAL" (LEN <>) "AUX" GT ATT)
	 #DECL ((PER) OBJECT (ATT) FIX)
	 <SET GT <GET-GOALS .PER>>
	 <COND (<GET .GT ,GOAL-S>
		<COND (.LEN <SET ATT .LEN>)
		      (ELSE <SET ATT <GET .GT ,ATTENTION-SPAN>>)>
		<PUT .GT ,ATTENTION .ATT>
		<COND (<==? .ATT 0>
		       <PUT .GT ,GOAL-ENABLE T>
		       <RFALSE>)
		      (<GET .GT ,GOAL-ENABLE>
		       <PUT .GT ,GOAL-ENABLE <>>)>)>
	 <SETG QCONTEXT .PER>
	 <SETG QCONTEXT-ROOM ,HERE>
	 <RTRUE>>

"Movement etc."

<ROUTINE UNPRIORITIZE (PER "AUX" GT)
	 <SET GT <GET-GOALS .PER>>
	 <PUT .GT ,GOAL-ENABLE T>
	 <COND (<GET .GT ,GOAL-QUEUED>
		<ESTABLISH-GOAL .PER <GET .GT ,GOAL-QUEUED>>
		<PUT .GT ,GOAL-QUEUED <>>)>>

<ROUTINE ESTABLISH-GOAL (PER GOAL "OPTIONAL" (PRIORITY <>)
			 "AUX" H HL GL GT)
	 #DECL ((PER GOAL H) OBJECT (HL GL) FIX)
	 <SET H
	      <COND (<EQUAL? .PER ,PLAYER> ,HERE)
		    (ELSE <LOC .PER>)>>
	 %<DEBUG-CODE
	   <COND (<NOT <IN? .GOAL ,ROOMS>>
		  <TELL
"***Establish goal for " D .PER " to " D .GOAL "***" CR>
		  <RFALSE>)
		 (<EQUAL? ,EDEBUG .PER>
		  <TELL
"[" CD .PER " establishes ">
		  <COND (.PRIORITY
			 <TELL "priority ">)>
		  <TELL "goal of " D .GOAL "]" CR>)>>
	 <SET GT <GET-GOALS .PER>>
	 <COND (.PRIORITY
		<PUT .GT ,ATTENTION 0>
		<PUT .GT ,GOAL-ENABLE T>
		<COND (<NOT <EQUAL? .GOAL <GET .GT ,GOAL-F>>>
		       %<DEBUG-CODE 
			 <COND (<AND ,DEBUG <GET .GT ,GOAL-QUEUED>>
				<TELL
"[" CD .PER ": queued=" D <GET .GT ,GOAL-QUEUED>
", new=" D .GOAL
", here=" D .H "!]" CR>)>>
		       <PUT .GT ,GOAL-QUEUED .H>)>)>
	 <PUT .GT
	      ,GOAL-I
	      <* 2
		 <+ <* %<COND (<GASSIGNED? PREDGEN>
			       '<GETP .H ,P?LINE>)
			      (ELSE
			       '<OR <GETP .H P?LINE> <ERROR .H LINE>>)>
		       ,LINES>
		    <GETP .GOAL ,P?LINE>>>>
	 <PUT .GT ,GOAL-S <GETP .GOAL ,P?STATION>>
	 <PUT .GT ,GOAL-F .GOAL>
	 <LOC .PER>>

<ROUTINE GOAL-REACHED (PER "OPTIONAL" (THERE? <>) "AUX" GT)
	 #DECL ((PER) OBJECT)
	 <SET GT <GET-GOALS .PER>>
	 <COND (<GET .GT ,GOAL-S>
		<PUT .GT ,GOAL-S <>>
		%<DEBUG-CODE
		  <COND (,HDEBUG <TELL "[" D .PER "=]">)>>
		%<DEBUG-CODE
		  <D-APPLY <COND (.THERE? "Already") (T "Reached")>
			   <GET .GT ,GOAL-FUNCTION>
			   <COND (.THERE? ,G-ALREADY) (T ,G-REACHED)>>
		  <APPLY <GET .GT ,GOAL-FUNCTION>
			 <COND (.THERE? ,G-ALREADY) (T ,G-REACHED)>>>)>>

<ROUTINE MOVE-PERSON (PER WHERE "AUX" DIR GT OL COR PCOR CD DF
		      			 (FLG <>) DR (VAL <>) PB?)
	 #DECL ((PER WHERE) OBJECT)
	 <SET GT <GET-GOALS .PER>>
	 <SET OL <LOC .PER>>
	 <SET DIR <DIR-FROM .OL .WHERE>>
	 %<DEBUG-CODE <COND (<NOT .DIR>
			     <TELL
"[Goal bug: " D .PER " from " D .OL " to " D .WHERE "]" CR>)>>
	 <COND (<==? <PTSIZE <SET DR <GETPT .OL .DIR>>> ,DEXIT>
		<SET DR <GETB .DR ,DEXITOBJ>>
		<COND (<NOT <FSET? .DR ,OPENBIT>>
		       <COND (<AND <EQUAL? .PER ,PLAYER>
				   <FSET? .DR ,LOCKED>>
			      T)
			     (T
			      <FCLEAR .DR ,LOCKED>
			      <FSET .DR ,OPENBIT>)>)
		      (T <SET DR <>>)>)
	       (T <SET DR <>>)>
	 <SET PB? <IN-BALLROOM? ,PLAYER>>
	 <COND (<FSET? .PER ,INVISIBLE> T)
	       (<AND .PB?
		     <OR <IN-BALLROOM? .PER>
			 <IN-BALLROOM? .WHERE>>>
	        <COND (<NOT <EQUAL? ,HERE <GET .GT ,GOAL-F>>>
		       <SET FLG T>
		       <TELL CTHE .PER>
		       <COND (<NOT <IN-BALLROOM? .WHERE>>
			      <TELL " leaves the ballroom." CR>)
			     (T
			      <COND (<EQUAL? .OL ,HERE>
				     <TELL " leaves you, and">)>
			      <TELL " is now ">
			      <COND (<EQUAL? .WHERE ,HERE>
				     <TELL "with you ">)>
			      <TELL <GETP .WHERE ,P?FDESC>>
			      <TELL "." CR>)>)>)
	       (<==? .OL ,HERE>
		<SET FLG T>
		<TELL CTHE .PER>
		<COND (<==? .DIR ,P?OUT>
		       <TELL " leaves the room." CR>)
		      (<==? .DIR ,P?IN>
		       <COND (.DR
			      <TELL " opens " THE .DR " and">)>
		       <TELL " goes into another room." CR>)
		      (T
		       <COND (.DR
			      <TELL " opens " THE .DR " and">)>
		       <TELL " heads off to ">
		       <DIR-PRINT .DIR>
		       <TELL "." CR>)>)
	       (<==? .WHERE ,HERE>
		<COND (<NOT <==? ,HERE <GET .GT ,GOAL-F>>>
		       <SET FLG T>
		       <TELL CTHE .PER>
		       <COND (.DR
			      <TELL " opens " THE .DR " and">)>
		       <COND (<AND <VERB? WALK>
				   <==? .DIR ,P-WALK-DIR>
				   <NOT <==? <LOC ,PLAYER> ,LAST-PLAYER-LOC>>>
			      <TELL " walks along with">)
			     (T <TELL " approaches">)>
		       <TELL " you." CR>)>)
	       (<SET COR <GETP ,HERE ,P?CORRIDOR>>
		<COND (<AND <SET PCOR <GETP .OL ,P?CORRIDOR>>
			    <NOT <==? <BAND .COR .PCOR> 0>>>
		       <SET FLG T>
		       <COND (<NOT <GETP .WHERE ,P?CORRIDOR>>
			      <TELL CTHE .PER ", off to ">
			      <DIR-PRINT <COR-DIR ,HERE .OL>>
			      <TELL ",">
			      <COND (.DR
				     <TELL " opens a door and">)>
			      <TELL " leaves your view to ">
			      <DIR-PRINT <DIR-FROM .OL .WHERE>>
			      <TELL "." CR>)
			     (<0? <BAND .COR <GETP .WHERE ,P?CORRIDOR>>>
			      <TELL CTHE .PER ", off to ">
			      <DIR-PRINT <COR-DIR ,HERE .OL>>
			      <TELL ", disappears from sight to ">
			      <DIR-PRINT <SET PCOR <DIR-FROM .OL .WHERE>>>
			      <TELL "." CR>)
			     (T
			      <TELL CTHE .PER " is to ">
			      <DIR-PRINT <SET CD <COR-DIR ,HERE .WHERE>>>
			      <TELL ", heading ">
			      <COND (<==? .CD <SET DF <DIR-FROM .OL .WHERE>>>
				     <TELL "away from you">)
				    (ELSE
				     <TELL "toward ">
				     <DIR-PRINT .DF>)>
			      <TELL "." CR>)>)
		      (<AND <SET PCOR <GETP .WHERE ,P?CORRIDOR>>
			    <NOT <==? <BAND .COR .PCOR> 0>>>
		       <SET FLG T>
		       <TELL "To ">
		       <DIR-PRINT <SET CD <COR-DIR ,HERE .WHERE>>>
		       <TELL " " THE .PER>
		       <TELL " comes into view">
		       <COND (<==? .CD <DIR-FROM .OL .WHERE>>
			      <TELL " heading toward you">)
			     (ELSE
			      <TELL " from ">
			      <DIR-PRINT <DIR-FROM .WHERE .OL>>)>
		       <TELL "." CR>)>)>
	 <MOVE .PER .WHERE>
	 <COND (<EQUAL? .PER ,PLAYER>
		<SETG HERE .WHERE>
		<RFALSE>)>
	 %<DEBUG-CODE <COND (,HDEBUG <TELL "[" D .PER "=]">)>>
	 <COND (<==? <GET .GT ,GOAL-F> .WHERE>
		<COND (<AND <NOT <SET VAL <GOAL-REACHED .PER>>>
			    <NOT <FSET? .PER ,INVISIBLE>>>
		       <COND (.FLG T)
			     (<OR <==? ,HERE .WHERE>
				  <AND .PB? <IN-BALLROOM? .WHERE>>
				  <CORRIDOR-LOOK .PER>>
			      <SET FLG T>
			      <TELL CTHE .PER>
			      <COND (.DR
				     <TELL " opens " THE .DR ", enters and">)>
			      <TELL " stops">
			      <COND (<==? ,HERE .WHERE>
				     <TELL " here">)
				    (.PB?
				     <TELL " " <GETP .WHERE ,P?FDESC>>)
				    (T
				     <TELL ", to ">
				     <DIR-PRINT <COR-DIR ,HERE .WHERE>>)>
			      <TELL "." CR>)>)>)
	       (T
		<COND (%<DEBUG-CODE
			 <D-APPLY "Enroute"
				  <GET .GT ,GOAL-FUNCTION>
				  ,G-ENROUTE>
			 <APPLY <GET .GT ,GOAL-FUNCTION>
				,G-ENROUTE>>
		       <SET FLG T>)>)>
	 <WHERE-UPDATE .PER .FLG>
	 %<DEBUG-CODE
	   <COND (,GDEBUG
		  <TELL
"[" CTHE .PER " just went into " THE .WHERE ".]" CR>)>>
	 <COND (<NOT .VAL> .FLG)
	       (T .VAL)>>

<ROUTINE DIR-FROM (HERE THERE "AUX" (P 0) L T O)
	 #DECL ((HERE THERE O) OBJECT (P L) FIX)
 <REPEAT ()
	 <COND (<0? <SET P <NEXTP .HERE .P>>>
		<RFALSE>)
	       (<EQUAL? .P ,P?IN ,P?OUT> T)
	       (<NOT <L? .P ,LOW-DIRECTION>>
		<SET T <GETPT .HERE .P>>
		<SET L <PTSIZE .T>>
		<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
			    <==? <GETB .T ,REXIT> .THERE>>
		       <RETURN .P>)>)>>>

<ROUTINE LISTENING? (PER)
	 <COND (<SET PER <GET-GOALS .PER>>
		<G? <GET .PER ,ATTENTION> 0>)>>

<ROUTINE WHERE-UPDATE (PER "OPTIONAL" (FLG <>)
		       "AUX" OW WT NC (CNT 0) CHR L (PER? <>))
	 <COND (<NOT <SET L <LOC .PER>>> <RFALSE>)>
	 <SET NC <GETP .PER ,P?CHARACTER>>
	 <SET WT <GET ,WHERE-TABLES .NC>>
	 <COND (<AND <NOT <EQUAL? .PER ,PLAYER>>
		     <HELD? ,CORPSE>>
		<SET PER? <DISCOVER-BODY .PER>>)>
	 <REPEAT ()
		 <COND (<G? .CNT ,CHARACTER-MAX> <RETURN>)
		       (<==? .CNT .NC>)
		       (<OR <IN? <SET CHR <GET ,CHARACTER-TABLE .CNT>>
				 .L>
			    <AND <0? .CNT> .FLG>>
			<COND (<IN? .CHR .L>
			       <COND (<AND <NOT <EQUAL? .PER ,PLAYER>>
					   <FSET? .PER ,TOLD>
					   <NOT <FSET? .CHR ,TOLD>>>
				      <MURDER-TELL .CHR .PER>)
				     (<AND <NOT <EQUAL? .CHR ,PLAYER>>
					   <FSET? .CHR ,TOLD>
					   <NOT <FSET? .PER ,TOLD>>>
				      <MURDER-TELL .PER .CHR>)
				     (<LOC ,CORPSE>
				      <COND (<EQUAL? .PER ,PLAYER>
					     <DISCOVER-BODY .CHR>)
					    (<AND <NOT .PER?>
						  <EQUAL? .CHR ,PLAYER>>
					     <DISCOVER-BODY .PER>)>)>)>
			<PUT .WT .CNT ,PRESENT-TIME>
			<PUT <GET ,WHERE-TABLES .CNT> .NC ,PRESENT-TIME>)>
		 <SET CNT <+ .CNT 1>>>>

<GLOBAL WHERE-TABLES
 <TABLE ;"PLA MIC VER ALI RIC MAR LIN ASH COC OST BUT BAR DET DUF"
   <TABLE 500 500 500   0 500 500 500 500 500 540 500 540   0   0> ;"PLAYER"
   <TABLE 500 540 540   0 500 500 500 500 500 500 500 500   0   0> ;"MICHAEL"
   <TABLE 500 540 540   0 500 500 500 500 500 500 500 500   0   0> ;"VERONICA"
   <TABLE   0   0   0   0   0   0   0   0   0   0   0   0   0   0> ;"ALICIA"
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"RICHARD"
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"COL. M."
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"LINDA"
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"SEN. A."
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"COCHRANE"
   <TABLE 540 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"OSTMANN"
   <TABLE 500 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"BUTLER"
   <TABLE 540 500 500   0 500 500 500 500 500 500 500 500   0   0> ;"BARTENDER"
   <TABLE   0   0   0   0   0   0   0   0   0   0   0   0   0   0> ;"DETECTIVE"
   <TABLE   0   0   0   0   0   0   0   0   0   0   0   0   0   0> ;"DUFFY">>

;"END"