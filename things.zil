"THINGS for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<OBJECT GLOBAL-OBJECTS
	(FLAGS AN BURNBIT CONTBIT DOORBIT
	       DRINKBIT FEMALE FOODBIT FURNITURE
	       INVISIBLE LOCKED NDESCBIT ONBIT
	       OPENBIT PERSON READBIT RMUNGBIT
	       SEARCHBIT SURFACEBIT TAKEBIT THE
	       TOLD TOOLBIT TOUCHBIT TRANSBIT
	       TRYTAKEBIT VEHBIT WEARBIT WEAPONBIT
	       WINDOWBIT MICHAELBIT ALICIABIT ;"31 BITS")
	(DESCFCN NULL-F)
	(CONTFCN NULL-F)
	(PSEUDO NULL-F)
	(TEXT "FOO")>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZKJLK)	;"This synonym is necessary - God knows">

<OBJECT PSEUDO-OBJECT
	(DESC "pseudo" ;"Place holder (MUST BE 6 CHARACTERS!!!!!)")
	(ACTION NULL-F ;"Place holder")>

<OBJECT NOT-HERE-OBJECT
	(DESC "such thing")
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	;"Protocol: return T if case was handled and msg TELLed,
			  <> if PRSO/PRSI ready to use"
	<COND ;"This COND is game independent (except the TELL)"
	       (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "Those things aren't">
		<TELL-HERE>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 <COND (.PRSO?
		<COND (<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR CLIMB-UP
			      EXAMINE FIND FOLLOW SEARCH SEARCH-OBJECT-FOR
			      WHAT PHONE MAKE THROUGH WALK-TO WAIT-FOR ARREST
			      ACCUSE ANALYZE FINGERPRINT>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
				     <RTRUE>)>)
			     (T
			      <RFALSE>)>)
		      (<VERB? TELL>
		       <SETG P-CONT <>>
		       <SETG QUOTE-FLAG <>>)>)
	       (T
		<COND (<VERB? ASK-ABOUT ASK-FOR SAY
			      SEARCH-OBJECT-FOR SGIVE TELL-ME>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
				     <RTRUE>)>)
			     (T
			      <RFALSE>)>)>)>
	 ;"Here is the default 'cant see any' printer"
	 <SETG P-WON <>>
	 <TELL-CANT-SEE "any">
	 <NOT-HERE-PRINT>
	 <TELL-HERE>
	 <RTRUE>>

<ROUTINE TELL-CANT-SEE (STR)
	 <TELL ,YOU-CANT-SEE .STR>>

<ROUTINE TELL-HERE ()
	 <TELL " here." CR>>

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ (CNT 0) PB? (LOCAL 0))
	;"Protocol: return T if case was handled and msg TELLed,
	    ,NOT-HERE-OBJECT if 'can't see' msg TELLed,
			  <> if PRSO/PRSI ready to use"
	;"Here is where special-case code goes. <MOBY-FIND .TBL> returns
	   number of matches. If 1, then P-MOBY-FOUND is it. One may treat
	   the 0 and >1 cases alike or different. It doesn't matter. Always
	   return RFALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	%<DEBUG-CODE
	  <COND (,HDEBUG
		 <TELL "[Moby-found " N .M-F " objects" "]" CR>)>>
	<COND (<G? .M-F 1>
	       <SET PB? <IN-BALLROOM? ,PLAYER>>
	       <REPEAT ()
		       <COND (<G? <SET CNT <+ .CNT 1>> .M-F>
			      <RETURN>)>
		       <SET OBJ <GET .TBL .CNT>>
		       <COND (<OR <AND .PB? <IN-BALLROOM? .OBJ>>
				  <CORRIDOR-LOOK .OBJ>>
			      <COND (<G? <SET LOCAL <+ .LOCAL 1>> 1>
				     <RETURN>)
				    (ELSE
				     <SETG P-MOBY-FOUND .OBJ>)>)>>
	       <COND (<EQUAL? .LOCAL 1>
		      <SET M-F 1>)>)>
	<COND (<==? .M-F 1>
	       %<DEBUG-CODE 
		 <COND (,HDEBUG
			<TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>>
	       <COND (.PRSO? <SETG PRSO ,P-MOBY-FOUND>)
		     (T <SETG PRSI ,P-MOBY-FOUND>)>
	       <RFALSE>)
	      (<G? .M-F 1>
	       <COND (<VERB? EXAMINE> <RETURN ,NOT-HERE-OBJECT>)
		     (<SET OBJ
			   <APPLY <GETP <SET OBJ <GET .TBL 1>>
					,P?GENERIC>
				  .OBJ>>
		      <COND (<==? .OBJ ,NOT-HERE-OBJECT> <RTRUE>)
			    (.PRSO? <SETG PRSO .OBJ>)
			    (T <SETG PRSI .OBJ>)>)
		     (<NOT ,P-NAM>
		      <TELL-NO-NOUNS>
		      <RTRUE>)
		     (ELSE
		      <WHICH-PRINT 0 .M-F .TBL>
		      <SETG P-ACLAUSE
			     <COND (<==? .TBL ,P-PRSO> ,P-NC1)
				   (T ,P-NC2)>>
		      <SETG P-AADJ ,P-ADJ>
		      <SETG P-ANAM ,P-NAM>
		      <ORPHAN <> <>>
		      <SETG P-OFLAG T>
		      <RTRUE>)>)
	      (<OR <AND <NOT .PRSO?>
			<FSET? ,PRSO ,PERSON>
			<VERB? ASK-ABOUT ASK-FOR TELL-ME WHAT-IS-WAS>>
		   <AND .PRSO?
			<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR>>
		   <AND <NOT <==? ,WINNER ,PLAYER>>
			<VERB? WALK-TO FOLLOW FIND WHAT GIVE SGIVE>>>
	       <COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		      <TELL CD ,WINNER>)
		     (<AND <VERB? ASK-ABOUT ASK-FOR TELL-ME>
			   <NOT <EQUAL? ,PRSO ,PLAYER ,CORPSE>>>
		      <TELL CD ,PRSO>)
		     (ELSE
		      <TELL-ISNT-ANYONE>
		      <RTRUE>)>
	       <TELL
" looks confused. ">
	       <I-DONT-KNOW-ABOUT "any" <>>
	       <NOT-HERE-PRINT>
	       <TELL "!\"" CR>
	       <RTRUE>)
	      (<NOT .PRSO?>
	       <TELL "You wouldn't find any">
	       <NOT-HERE-PRINT>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T ,NOT-HERE-OBJECT)>>

<ROUTINE NOT-HERE-PRINT ()
 <COND (<OR ,P-OFLAG ,P-MERGED>
	<COND (,P-XADJ <TELL " "> <PRINTB ,P-XADJN>)>
	<COND (,P-XNAM <TELL " "> <PRINTB ,P-XNAM>)>)
       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT HE SHE THEY)
	(DESC "it")
	(FLAGS NDESCBIT AN)
	;(ACTION IT-F)>

;<ROUTINE IT-F ()
 <COND (<AND <EQUAL? ,PRSO ,IT>
	     <NOT ,P-IT-OBJECT>
	     ,P-HIM-HER>
	<PERFORM ,PRSA ,P-HIM-HER ,PRSI>
	<RTRUE>)
       (<OR <AND <EQUAL? ,PRSI ,IT>
		 <VERB? ASK-ABOUT ASK-FOR SEARCH-OBJECT-FOR TELL-ME>>
	    <AND <EQUAL? ,PRSO ,IT>
		 <VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR FIND WHAT>>>
	<TELL "\"I'm not sure what you're talking about.\"" CR>)>>

<ROUTINE THE? (NOUN)
	 <COND (<OR <EQUAL? .NOUN ,IT ,YOU ,HIM-HER>
		    <FSET? .NOUN ,PERSON>>
		<RTRUE>)
	       (T <TELL " the">)>>

<ROUTINE THIS-IS-IT (OBJ)
	 %<DEBUG-CODE
	   <COND (,IDEBUG
		  <TELL "[It's " D .OBJ "]" CR>)>>
	 <SETG P-IT-OBJECT .OBJ>
	 <SETG P-IT-LOC ,HERE>>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM INTNUM)
	(DESC "number")
	;(ACTION INTNUM-F)>

<OBJECT WEATHER
	(IN GLOBAL-OBJECTS)
	(SYNONYM WEATHER SKY RAIN CLOUDS)
	(DESC "weather")
	(ACTION WEATHER-F)>

<GLOBAL SAW-RAIN-SLACK-OFF? <>>

<ROUTINE WEATHER-F ()
	 <COND (<VERB? EXAMINE FIND LISTEN>
		<COND (<AND <NOT <OUTSIDE? ,HERE>>
			    <NOT <GLOBAL-IN? ,WINDOW ,HERE>>>
		       <TELL-YOU-CANT "see the outside from here">)
		      (<L? ,PRESENT-TIME 550>
		       <TELL
"The rain is pouring down. It's a great night for ducks!" CR>)
		      (<L? ,PRESENT-TIME 570>
		       <SETG SAW-RAIN-SLACK-OFF? T>
		       <TELL
"The rain has slacked off, it's just a drizzle now." CR>)
		      (<L? ,PRESENT-TIME 630>
		       <TELL
"The rain is coming down in buckets">
		       <COND (,SAW-RAIN-SLACK-OFF? <TELL " again">)>
		       <TELL "." CR>)
		      (ELSE
		       <TELL
"The rain is almost stopped, and the storm seems to be passing off to the
northeast." CR>)>)
	       (<VERB? RUB>
		<COND (<OUTSIDE? ,HERE>
		       <TELL "It's wet." CR>)
		      (ELSE
		       <TELL-YOU-CANT "touch that">)>)>>

<GLOBAL RAIN-STATE 2>

<ROUTINE I-RAIN-SLOWS ()
	 <SETG RAIN-STATE 1>
	 <COND (<OUTSIDE? ,HERE>
		<SETG SAW-RAIN-SLACK-OFF? T>
		<TELL
"Now the rain has slowed. It's just a light shower now." CR>
		<RFALSE>)>>

<ROUTINE I-RAIN-POURS ()
	 <SETG RAIN-STATE 2>
	 <COND (<OUTSIDE? ,HERE>
		<TELL
"Now the rain is coming down in torrents, a real cloudburst." CR>
		<RFALSE>)>>

<ROUTINE I-RAIN-STOPS ()
	 <SETG RAIN-STATE 0>
	 <COND (<OUTSIDE? ,HERE>
		<TELL
"Now the rain has slowed down almost to a stop. Only a few drops
are falling now." CR>
		<RFALSE>)>>

<OBJECT MIDNIGHT
	(IN GLOBAL-OBJECTS)
	(DESC "midnight")
	(SYNONYM MIDNIGHT)
	(FLAGS NDESCBIT)>

<OBJECT HANDCUFFS
	(IN DUFFY)
	(DESC "handcuffs")
	(SYNONYM HANDCUFF CUFF CUFFS)
	(FLAGS NDESCBIT)>

<OBJECT WATER
	(IN LOCAL-GLOBALS)
	(DESC "water")
	(SYNONYM WATER)
	(ACTION WATER-F)
	(FLAGS NDESCBIT)>

<ROUTINE WATER-F ()
	 <COND (<VERB? WALK>
		<PERFORM ,V?LAMP-ON ,WATER>
		<RTRUE>)>>

<OBJECT TELEPHONE
	(IN LOCAL-GLOBALS)
	(DESC "telephone")
	(SYNONYM TELEPHONE PHONE)
	(ACTION TELEPHONE-F)
	(FLAGS NDESCBIT)>

<ROUTINE TELEPHONE-F ()
	 <COND (<VERB? REPLY>
		<TELL "It wasn't ringing." CR>)
	       (<VERB? TAKE>
		<TELL "You hear a dial tone." CR>)
	       (<AND <VERB? PHONE> <EQUAL? ,PRSO ,TELEPHONE>>
		<TELL ,YOU-SHOULD "dial a number, such as 911." CR>)
	       (<VERB? HANG-UP>
		<DISABLE <INT I-HANG-UP>>
		<TELL "You replace the receiver." CR>)>>

<OBJECT GLOBAL-FINGERPRINTS
	(IN GLOBAL-OBJECTS)
	(DESC "fingerprints")
	(SYNONYM FINGERPRINT PRINT PRINTS)
	;(ADJECTIVE FINGER)
	(FLAGS NDESCBIT)>

<OBJECT SINK
	(IN LOCAL-GLOBALS)
	(DESC "sink")
	(SYNONYM SINK BASIN TAP)
	(ACTION SINK-F)
	(FLAGS NDESCBIT)>

<ROUTINE SINK-F ()
	 <COND (<AND <VERB? BRUSH> <EQUAL? ,PRSO ,HANDS>>
		<TELL "Your hands are now clean." CR>)>>

<OBJECT SHOWER
	(IN LOCAL-GLOBALS)
	(DESC "shower")
	(SYNONYM BATH STALL)
	(ADJECTIVE SHOWER)
	(ACTION SHOWER-F)
	(FLAGS NDESCBIT)>

<ROUTINE SHOWER-F ()
	 <COND (<VERB? TAKE LAMP-ON>
		<TELL "You'd get your costume all wet." CR>)
	       (<VERB? LOOK-INSIDE>
		<TELL ,THERE-IS "no blood in the shower." CR>)>>

<OBJECT TOILET
	(IN LOCAL-GLOBALS)
	(DESC "toilet")
	(SYNONYM TOILET)
	(ACTION TOILET-F)
	(CAPACITY 30)
	(FLAGS NDESCBIT FURNITURE VEHBIT OPENBIT SURFACEBIT)>

<ROUTINE TOILET-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-END> <RFALSE>)
	       (<EQUAL? ,PRSO ,TOILET>
		<COND (<VERB? WALK USE>
		       <TELL "You now feel refreshed." CR>)
		      (<VERB? LOOK-INSIDE SMELL>
		       <TELL
"The toilet is immaculate. Nosey, aren't you?" CR>)
		      (<VERB? FLUSH>
		       <TELL ,YOU-ARE "a model and considerate guest." CR>)>)>>



<OBJECT GLOBAL-HERE
	(IN GLOBAL-OBJECTS)
	(DESC "here")
	(SYNONYM HERE)
	(FLAGS NDESCBIT)>

<OBJECT HALLWAY
	(IN GLOBAL-OBJECTS)
	(DESC "hallway")
	(SYNONYM HALL HALLWAY CORRIDOR)
	(FLAGS NDESCBIT)>

<OBJECT GLOBAL-ROOM
	(IN GLOBAL-OBJECTS)
	(DESC "room")
	(SYNONYM ROOM FLOOR)
	(ACTION GLOBAL-ROOM-F)
	(FLAGS NDESCBIT)>

<ROUTINE GLOBAL-ROOM-F ()
	 <COND (<VERB? EXAMINE LOOK-ON>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (<VERB? SEARCH-OBJECT-FOR>
		<PERFORM ,V?FIND ,PRSI>
		<RTRUE>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSI ,GLOBAL-ROOM>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<OBJECT GLOBAL-MURDER
	(IN GLOBAL-OBJECTS)
	(DESC "murder")
	(SYNONYM MURDER KILLING DEATH DEAD)
	(ADJECTIVE VERONICA)
	(ACTION GLOBAL-MURDER-F)
	(FLAGS NDESCBIT)>

<ROUTINE GLOBAL-MURDER-F ("AUX" OW)
	 <COND (<AND <VERB? TELL-ME>
		     <EQUAL? ,WINNER ,PLAYER>
		     <EQUAL? ,PRSI ,GLOBAL-MURDER>>
		<PERFORM ,V?REVEAL ,GLOBAL-MURDER ,PRSO>
		%<DEBUG-CODE
		  <COND (<AND ,GOSSIP <NOT <FSET? ,PLAYER ,TOLD>>>
			 <TELL "[Murder: Player revealed to self?]" CR>)>>
		<FSET ,PLAYER ,TOLD>
		%<DEBUG-CODE
		  <COND (<AND ,GOSSIP <NOT <FSET? ,PRSO ,TOLD>>>
			 <TELL
"[Murder: Player revealed to " D ,PRSO "]" CR>)>>
		<FSET ,PRSO ,TOLD>
		<RTRUE>)
	       (<AND <VERB? $REVEAL>
		     <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<REVEAL-MURDER ,PRSI>
		%<DEBUG-CODE
		  <COND (<AND ,GOSSIP <NOT <FSET? ,WINNER ,TOLD>>>
			 <TELL
"[Murder: " D ,WINNER " revealed to self?]" CR>)>>
		<FSET ,WINNER ,TOLD>
		<COND (<IN? ,PRSI ,HERE>
		       <TELL
CD ,WINNER " sees " D ,PRSI " and they speak for a few moments. "
CD ,PRSI "'s eyes widen as " HE/SHE ,PRSI " is told of the murder.
There is an apparent conflict between shock and the desire to immediately
tell someone else about it." CR>)
		      (<NEARBY? ,PRSI>
		       <TELL
CD ,WINNER " is speaking excitedly and urgently to " D ,PRSI " some
distance away. You can't hear what is being said, but " D ,PRSI " is
very agitated by what " HE/SHE ,PRSI " has heard." CR>)>
		<RTRUE>)
	       (<AND <VERB? IS>
		     <EQUAL? ,PRSO ,VERONICA ,CORPSE ,GLOBAL-VERONICA>
		     <NOT <EQUAL? ,PLAYER ,WINNER>>>
		<SET OW ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?REVEAL ,GLOBAL-MURDER .OW>
		<RTRUE>)>>

<OBJECT GLOBAL-EMBEZZLEMENT
	(IN GLOBAL-OBJECTS)
	(DESC "theft")
	(SYNONYM THEFT EMBEZZLEMENT)
	(FLAGS NDESCBIT)>

<OBJECT HORSE
	(IN GLOBAL-OBJECTS)
	(DESC "horse")
	(SYNONYM HORSE GRUE HORSES)
	(ADJECTIVE LURKING)
	(FLAGS NDESCBIT)>

<OBJECT GLASS
	(DESC "broken glass")
	(SYNONYM GLASS GOBLET)
	(ADJECTIVE BROKEN)
	(FLAGS TAKEBIT TRYTAKEBIT CONTBIT OPENBIT SEARCHBIT)
	(ACTION GLASS-F)>

<ROUTINE GLASS-F ("AUX" (W ,WINNER))
	 <COND (<AND <VERB? TAKE> <IN? ,GLASS ,BUTLER>>
		<SETG WINNER ,BUTLER>
		<PERFORM ,V?GIVE ,GLASS .W>
		<SETG WINNER .W>) 
	       (<AND <VERB? CUT> <EQUAL? ,PRSO ,PLAYER>>
		<TELL
"Suicide is not the answer." CR>)
	       (<VERB? SMELL>
		<TELL
,THERE-IS "something on the glass which smells sweet -- probably the remains
of " 'VERONICA "'s drink." CR>)
	       (<VERB? EXAMINE>
		<TELL
"This is a large fragment of " 'GLASS " from a highball glass.
There is a film of red liquid on the inside." CR>)
	       (<VERB? ANALYZE>
		<COND (<EQUAL? ,PRSI ,GLOBAL-FINGERPRINTS>
		       <TELL ,YOU-DONT-HAVE "the equipment." CR>)
		      (T
		       <TELL
"Since you're not a psychiatrist or a laboratory chemist, your chances
of a successful analysis are poor. Perhaps you should get someone more
competent to do the job." CR>)>)>>

<OBJECT LIQUID
	(IN GLASS)
	(DESC "liquid")
	(SYNONYM LIQUID FILM)
	(ADJECTIVE RED SWEET)
	(FLAGS NDESCBIT)
	(ACTION LIQUID-F)>

<ROUTINE LIQUID-F ()
	 <COND (<VERB? EXAMINE EAT SMELL RUB>
		<TELL
"This seems to be the remains of " 'VERONICA "'s drink." CR>)>>

<OBJECT RECEIPT
	(IN PLAYER)
	(DESC "costume receipt")
	(SYNONYM RECEIPT)
	(ADJECTIVE COSTUME)
	(FLAGS TAKEBIT BURNBIT READBIT)
	(SIZE 2)
	(TEXT
"(A copy is in your game package.)")>

;"\"Costumes Unlimited|
312 Wisconsin Ave.|
Rockville, MD|
555-9009|
|
(1) Cowboy costume with lariat and gunbelt: $65\"

"

<OBJECT COSTUME-SHOP
	(IN GLOBAL-OBJECTS)
	(DESC "Costumes Unlimited")
	(SYNONYM SHOP)
	(ADJECTIVE COSTUME UNLIMITED)
	(FLAGS NDESCBIT)
	(ACTION SHOP-F)>

<ROUTINE SHOP-F ()
	 <COND (<VERB? PHONE>
		<COND (<G? ,PRESENT-TIME 600>
		       <TELL
"The telephone rings continuously for as long as you wait." CR>)
		      (ELSE
		       <MOVE ,JACK ,HERE>
		       <ENABLE <QUEUE I-HANG-UP 5>>
		       <TELL
"A tired-sounding voice answers. \"Costumes Unlimited, Jack
speaking. We're closing at ten. We don't have many costumes left.
Better make it quick.\"" CR>)>)>>

<ROUTINE I-HANG-UP ()
	 <COND (<IN? ,JACK ,HERE>
		<REMOVE ,JACK>
		<TELL
"You hear a click as the telephone is hung up at the other end." CR>)>>

<OBJECT JACK
	(DESC "Jack")
	(SYNONYM JACK)
	(ACTION JACK-F)
	(FLAGS NDESCBIT TRANSBIT PERSON)>

<ROUTINE JACK-F ()
	 <COND (<NOT <IN? ,JACK ,HERE>>
		<TELL "He hung up." CR>)
	       (<OR <EQUAL? ,JACK ,WINNER>
		    <VERB? $CALL>>
		<COND (<VERB? SGIVE TELL-ME> <RFALSE>)
		      (ELSE
		       <TELL "\"Get to the point, I'm busy.\"" CR>)>)
	       (<VERB? TAKE EXAMINE>
		<TELL "Jack's on the telephone, not">
		<TELL-HERE>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,JACK>>
		<COND (<==? ,PRSI ,GLOBAL-VERONICA ,VERONICA ,CORPSE>
		       <COND (<NOT ,JACK-ASKED?>
			      <SETG JACK-ASKED? T>
			      <TELL
"\"" 'VERONICA " Ashcroft, eh? Upper crust type, right? Yeah, she rented " A
,FAIRY-COSTUME ". Real expensive. Great costume, though.\"" CR>)
			     (ELSE <TELL ,REPEATING-YOURSELF CR>)>)
		      (<==? ,PRSI ,FAIRY-COSTUME>
		       <COND (<NOT ,JACK-ASKED?>
			      <SETG JACK-ASKED? T>
			      <TELL
"\"Yeah, we rented one of them. Some society dame rented it. Just a minute,
I can tell you who...\"  There is a short pause. \"Yeah, here she is.
" 'VERONICA " Ashcroft, one Titania costume, a hundred and twenty dollars.
We don't get much call for that one. Heck of a costume, though.\"" CR>)
			     (ELSE <TELL ,REPEATING-YOURSELF CR>)>)
		      (T
		       <TELL "\"Get to the point, I'm busy.\"" CR>)>)>>

<GLOBAL REPEATING-YOURSELF "\"You're repeating yourself.\"">

<GLOBAL JACK-ASKED? <>>

<OBJECT JACKSON
	(IN GLOBAL-OBJECTS)
	(DESC "Earl Davis Jackson")
	(SYNONYM JACKSON EDITOR)
	(ADJECTIVE EARL DAVIS)
	(ACTION JACKSON-F)
	(FLAGS NDESCBIT TRANSBIT PERSON)>

<ROUTINE JACKSON-F ()
	 <COND (<VERB? PHONE>
		<TELL-NO-ANSWER>)>>

<OBJECT CARD
	(IN WASTE-BASKET)
	(DESC "business card")
	(SYNONYM CARD)
	(ADJECTIVE BUSINESS CRUMPLED)
	(FLAGS NDESCBIT BURNBIT READBIT)
	(TEXT
"(A copy is in your game package.)")>

;"The front reads:|
|
\"Kings Point Realty|
	Specializing in finer homes|
	William Cochrane,|
	President\"|
|
On the back is a handwritten message:|
|
\"Don't do something you'll regret. Call me ASAP.|
	Bill\"|
"

<OBJECT WASTE-BASKET
	(IN OFFICE)
	(SYNONYM BASKET WASTEBASKET)
	(ADJECTIVE WASTE)
	(DESC "waste basket")
	(FDESC "Next to the large desk is a waste basket.")
	(ACTION WASTE-BASKET-F)
	(CAPACITY 15)
	(SIZE 15)
	(FLAGS SEARCHBIT CONTBIT OPENBIT TAKEBIT)>

<ROUTINE WASTE-BASKET-F ()
	 <COND (<AND <VERB? LOOK-INSIDE EXAMINE SEARCH SEARCH-OBJECT-FOR>
		     <EQUAL? ,PRSO ,WASTE-BASKET>>
		<COND (<IN? ,CARD ,WASTE-BASKET>
		       <FCLEAR ,CARD ,NDESCBIT>
		       <FSET ,CARD ,TAKEBIT>
		       <TELL
"A crumpled " 'CARD " is on top">)
		      (ELSE
		       <TELL
"It's nearly full">)>
		<TELL " of boring trash">
		<PRINT-CONTENTS ,WASTE-BASKET ", including " ,CARD>
		<TELL "." CR>)>>

<OBJECT DISCUSSION
	(IN GLOBAL-OBJECTS)
	(SYNONYM DISCUSSION ARGUMENT)
	(ADJECTIVE HEATED)
	(DESC "heated discussion")
	(FLAGS NDESCBIT)>

<GLOBAL NUMBERS <LTABLE "one" "two" "three" "too many">>

<OBJECT TAXI
	(IN GLOBAL-OBJECTS)
	(SYNONYM TAXI CAB)
	(DESC "taxi")
	(ACTION TAXI-F)
	(FLAGS NDESCBIT)>

<ROUTINE TAXI-F ()
	 <COND (<VERB? PHONE>
		<TELL
"Since this is late on a rainy, disgusting night, the taxi company has
all its telephones off the hook. Too bad." CR>)>>

<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(DESC "hands")
	(SYNONYM HANDS)
	(ACTION HANDS-F)
	(FLAGS NDESCBIT)>

<ROUTINE HANDS-F ()
	 <COND (<VERB? BRUSH>
		<COND (<GLOBAL-IN? ,SINK ,HERE>
		       <PERFORM ,V?BRUSH ,HANDS ,SINK>
		       <RTRUE>)
		      (ELSE
		       <TELL "There are sinks in the bathrooms." CR>)>)>>

<OBJECT FOOD
	(IN LOCAL-GLOBALS)
	(DESC "food")
	(SYNONYM D\'OEUVRES OEUVRES MUNCHIES FOOD)
	(ADJECTIVE HORS SHRIMP SANDWICHES) 
	(ACTION FOOD-F)
	(FLAGS FOODBIT NDESCBIT TAKEBIT TRYTAKEBIT)>

<ROUTINE FOOD-F ()
	 <COND (<VERB? THROW THROW-AT THROW-THROUGH>
		<TELL "This isn't \"Animal House.\"" CR>)
	       (<VERB? TAKE>
		<TELL
"I suppose you plan to take it home in your pockets and eat it later?" CR>)
	       (<VERB? EAT SMELL>
		<TELL
"Not bad. Obviously " 'VERONICA " found a good caterer." CR>)>>

<OBJECT GLOBAL-CHAIR
	(IN LOCAL-GLOBALS)
	(DESC "chair")
	(SYNONYM CHAIR ARMCHAIR)
	(ADJECTIVE ARM LAWN)
	(FLAGS FURNITURE VEHBIT TRYTAKEBIT TAKEBIT OPENBIT)
	(SIZE 100)
	(ACTION GLOBAL-CHAIR-F)>

<OBJECT GLOBAL-SOFA
	(IN LOCAL-GLOBALS)
	(DESC "sofa")
	(SYNONYM COUCH SOFA)
	(ADJECTIVE LARGE)
	(FLAGS FURNITURE VEHBIT TRYTAKEBIT TAKEBIT OPENBIT)
	(SIZE 100)
	(ACTION GLOBAL-CHAIR-F)>

<ROUTINE GLOBAL-CHAIR-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-BEG ,M-END> <RFALSE>)
	       (<AND <VERB? TAKE> <EQUAL? ,PRSO ,GLOBAL-CHAIR>>
		<TELL ,RIDICULOUS CR>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSI ,GLOBAL-CHAIR ,GLOBAL-SOFA>>
		<FCLEAR ,PRSO ,WEARBIT>
		<MOVE ,PRSO ,HERE>
		<TELL
"It seems a shame to mar " THE ,PRSI " with " A ,PRSO ", so you put it on
the floor instead." CR>)
	       (<AND <VERB? SIT>
		     <EQUAL? ,PRSO ,GLOBAL-CHAIR ,GLOBAL-SOFA>
		     <HELD? ,CORPSE>>
		<TELL CTHE ,PRSO " can't take that much weight." CR>)
	       (<AND <VERB? HIDE-BEHIND> <NOT ,PLAYER-HIDING>>
		<NOW-CONCEALED>)>>

<ROUTINE NOW-CONCEALED ()
	 <SETG PLAYER-HIDING ,PRSO>
	 <TELL
,YOU-ARE "now concealed behind ">
	 <TELL-PRSO>>

<OBJECT CURTAINS
	(IN LOCAL-GLOBALS)
	(DESC "curtains")
	(SYNONYM CURTAINS)
	(FLAGS NDESCBIT)
	(ACTION CURTAINS-F)>

<ROUTINE CURTAINS-F ()
	 <COND (<NOT <GLOBAL-IN? ,CURTAINS ,HERE>>
		<TELL "There are no curtains">
		<TELL-HERE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<FSET? ,HERE ,OPENBIT>
		       <TELL "You see darkness." CR>)
		      (T <TELL "The curtains are closed." CR>)>)
	       (<VERB? EXAMINE>
		<TELL "The curtains are ">
		<COND (<FSET? ,HERE ,OPENBIT> <TELL "open">)
		      (T <TELL "closed">)>
		<TELL "." CR>)
	       (<VERB? OPEN>
		<COND (<FSET? ,HERE ,OPENBIT>
		       <TELL ,THEY-ARE-ALREADY "open." CR>)
		      (ELSE
		       <FSET ,HERE ,OPENBIT>
		       <TELL ,CURTAINS-ARE "open." CR>)>)
	       (<VERB? CLOSE>
		<COND (<NOT <FSET? ,HERE ,OPENBIT>>
		       <TELL ,THEY-ARE-ALREADY "closed." CR>)
		      (ELSE
		       <FCLEAR ,HERE ,OPENBIT>
		       <TELL ,CURTAINS-ARE "closed." CR>)>)>>

<GLOBAL THEY-ARE-ALREADY "They are already ">
<GLOBAL CURTAINS-ARE "Okay, the curtains are ">

<OBJECT WINDOW
	(IN LOCAL-GLOBALS)
	(SYNONYM WINDOW)
	(DESC "window")
	(ACTION WINDOW-F)
	(FLAGS WINDOWBIT NDESCBIT)>

<ROUTINE WINDOW-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL
"All the windows are closed and locked. The house has a reasonably
serious security setup." CR>)
	       (<VERB? LOOK-INSIDE LOOK-OUTSIDE>
		<COND (<OR <FSET? ,HERE ,OPENBIT>
			   <NOT <GLOBAL-IN? ,CURTAINS ,HERE>>>
		       <PERFORM ,V?EXAMINE ,WEATHER>
		       <RTRUE>)
		      (ELSE
		       <TELL "The curtains are drawn." CR>)>)>>

<OBJECT GLOBAL-PLANTS
	(IN LOCAL-GLOBALS)
	(SYNONYM PLANTS POTS PLANT POT)
	(DESC "plant")
	(ACTION GLOBAL-PLANTS-F)
	(FLAGS WINDOWBIT NDESCBIT)>

<ROUTINE GLOBAL-PLANTS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"These are ">
		<COND (<EQUAL? ,HERE ,PORCH>
		       <TELL "small potted shrubs, bushes">)
		      (T
		       <TELL "large shrubs, bushes, trees">)>
		<TELL ", and so on." ,DOING-WELL CR>)
	       (<VERB? TAKE MUNG EAT>
		<TELL-CARE>)>>

<OBJECT HOUSE
	(IN GLOBAL-OBJECTS)
	(SYNONYM HOUSE)
	(ADJECTIVE FARM)
	(DESC "house")
	(ACTION HOUSE-F)
	(FLAGS NDESCBIT)>

<ROUTINE HOUSE-F ()
	 <COND (<VERB? EXAMINE>
		<COND (<OUTSIDE? ,HERE>
		       <TELL
"It's dark, but you know that the Ashcroft house is a large, mostly
colonial structure. It was extensively rebuilt in the late nineteenth
century. It is partly brick, and partly white-painted wood." CR>)
		      (T
		       <TELL "The house is in good repair." CR>)>)>>

<OBJECT KEY
	(IN GLOBAL-OBJECTS)
	(SYNONYM KEY KEYS)
	(DESC "key")
	(ACTION KEY-F)
	(FLAGS NDESCBIT)>

<ROUTINE KEY-F ()
	 <COND (<VERB? FIND>
		<TELL "I don't know where the keys are." CR>)>>

<OBJECT STAIR
	(IN LOCAL-GLOBALS)
	(SYNONYM STAIR STAIRS)
	(DESC "stair")
	(ACTION STAIR-F)
	(FLAGS NDESCBIT)>

<ROUTINE STAIR-F ()
	 <COND (<VERB? CLIMB-FOO CLIMB-UP>
		<DO-WALK ,P?UP>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN>
		<DO-WALK ,P?DOWN>
		<RTRUE>)>>

<OBJECT PARTY
	(IN GLOBAL-OBJECTS)
	(SYNONYM PARTY)
	(DESC "party")
	(ACTION PARTY-F)
	(FLAGS NDESCBIT)>

<ROUTINE PARTY-F ()
	 <COND (<VERB? LEAVE>
		<TELL
"Don't be such a wet blanket!" CR>)>>